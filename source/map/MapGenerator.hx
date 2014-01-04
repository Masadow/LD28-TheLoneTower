package map;

import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.tile.FlxTilemap;
import flixel.util.FlxRect;
import flixel.util.FlxVector;

/**
 * ...
 * @author Masadow
 */
class MapGenerator
{
	//Roads constants
	private static inline var ROAD_UR = 4;
	private static inline var ROAD_LD = 5;
	private static inline var ROAD_DR = 6;
	private static inline var ROAD_LR = 7;
	private static inline var ROAD_LU = 8;
	private static inline var ROAD_UDR = 9;
	private static inline var ROAD_LDR = 10;
	private static inline var ROAD_LUDR = 11;
	private static inline var ROAD_LUR = 12;
	private static inline var ROAD_LUD = 13;
	private static inline var ROAD_UD = 14;
	private static inline var ROAD = ROAD_LR;

	private static inline var MASK_LEFT = 0x1;
	private static inline var MASK_UP = 0x2;
	private static inline var MASK_RIGHT = 0x4;
	private static inline var MASK_DOWN = 0x8;

	public static var entriesY(default, null) : Array<Int>;
	public static var exitY(default, null) : Array<Int>;

	private static var roadMasks : Map<Int, Int> = null;

	private static function initRoadMasks()
	{
		roadMasks = new Map<Int, Int>();
		
		roadMasks.set(MASK_UP | MASK_RIGHT, ROAD_UR);
		roadMasks.set(MASK_LEFT | MASK_DOWN, ROAD_LD);
		roadMasks.set(MASK_DOWN | MASK_RIGHT, ROAD_DR);
		roadMasks.set(MASK_LEFT | MASK_RIGHT, ROAD_LR);
		roadMasks.set(MASK_LEFT | MASK_UP, ROAD_LU);
		roadMasks.set(MASK_UP | MASK_DOWN | MASK_RIGHT, ROAD_UDR);
		roadMasks.set(MASK_LEFT | MASK_DOWN | MASK_RIGHT, ROAD_LDR);
		roadMasks.set(MASK_LEFT | MASK_UP | MASK_DOWN | MASK_RIGHT, ROAD_LUDR);
		roadMasks.set(MASK_LEFT | MASK_UP | MASK_RIGHT, ROAD_LUR);
		roadMasks.set(MASK_LEFT | MASK_UP | MASK_DOWN, ROAD_LUD);
		roadMasks.set(MASK_UP | MASK_DOWN, ROAD_UD);
	}
	
	public static function generate() : String
	{
		if (roadMasks == null)
			initRoadMasks();
		
		var map : Array<Int> = [for (unused in 0 ... Reg.HEIGHT * Reg.WIDTH) randomGrass() ];
		
		//Place entries and exit at random
		var spaces = [for (x in 0...Reg.HEIGHT) x];
		entriesY = [for (unused in 0...FlxRandom.intRanged(4, 8)) pickSpace(spaces) ];
		spaces = [for (x in 0...Reg.HEIGHT) x];
		exitY = [for (unused in 0...FlxRandom.intRanged(5, 10)) pickSpace(spaces) ];
		
		//Push entries onto the map and draw one or two path to one of the exit
		var moveY : Int;
		var moveX : Int;
		for (entry in entriesY)
		{
			var cursor : Vector2D = new Vector2D(0, entry);
			//Draw initial path
			for (x in 0...FlxRandom.intRanged(1, 8))
			{
				setTile(map, cursor, ROAD);
				cursor.x++;
			}
			setTile(map, cursor, ROAD);
			//for (path in 0...FlxRandom.intRanged(1, 2))
			//{ Draw only one path for now
				//Choose a random direction (UP or DOWN)
				while (true)
				{
					var dir = Std.int(FlxRandom.sign());
					for (y in 0...FlxRandom.intRanged(1, 10))
					{
						cursor.y += dir;
						if (!inBounds(cursor))
						{
							cursor.y -= dir;
							break ;
						}
						setTile(map, cursor, ROAD);
					}
					for (x in 0...FlxRandom.intRanged(2, 12))
					{
						cursor.x++;
						if (!inBounds(cursor) || cursor.x == Reg.WIDTH - 1)
						{
							cursor.x--;
							break ;
						}
						setTile(map, cursor, ROAD);
					}
					if (cursor.x > Reg.WIDTH - 5)
					{
						//Go for the closest end
						var closestExit = 3 * Reg.HEIGHT;
						for (exit in exitY)
						{
							if (Math.abs(closestExit - cursor.y) > Math.abs(exit - cursor.y))
								closestExit = exit;
						}
						while (cursor.y > closestExit)
						{
							cursor.y--;
							setTile(map, cursor, ROAD);
						}
						while (cursor.y < closestExit)
						{
							cursor.y++;
							setTile(map, cursor, ROAD);
						}
						while (cursor.x < Reg.WIDTH)
						{
							setTile(map, cursor, ROAD);
							cursor.x++;
						}
						//Path end
						break ;
					}
				}
			//}
		}

		clearExit(map);
		while (mergeTiles(map)) { }
		while (removeNoIssue(map)) { }
		smoothRoad(map);

		return FlxTilemap.arrayToCSV(map, Reg.WIDTH);
	}

	private static function clearExit(Map : Array<Int>)
	{
		var rmList : List<Int> = new List<Int>();
		for (exit in exitY)
		{
			if (Map[(exit + 1) * Reg.WIDTH - 1] != ROAD)
				rmList.push(exit);
		}
		for (l in rmList)
		{
			exitY.remove(l);
		}
	}

	private static inline function inBounds(Cursor : Vector2D) : Bool
	{
		return Cursor.x >= 0 && Cursor.x < Reg.WIDTH && Cursor.y >= 0 && Cursor.y < Reg.HEIGHT;
	}

	private static inline function setTile(Map : Array<Int>, Cursor : Vector2D, Value : Int)
	{
		Map[Cursor.y * Reg.WIDTH + Cursor.x] = Value;
	}
	
	private static inline function getTile(Map : Array<Int>, Cursor : Vector2D) : Int
	{
		return Map[Cursor.y * Reg.WIDTH + Cursor.x];
	}
	
	public static inline function isGrass(Tile : Int) : Bool
	{
		return Tile <= 3;
	}
	
	private static function pickSpace(Spaces : Array<Int>) : Int
	{
		var pick : Int = FlxRandom.intRanged(0, Spaces.length - 1);
		var valuePicked = Spaces[pick];
		
		//Make sure we will never have two consecutive entries/exits
		Spaces.remove(valuePicked + 1);
		Spaces.remove(valuePicked - 1);
		Spaces.remove(valuePicked);

		return valuePicked;
	}
	
	private static inline function randomGrass() : Int
	{
		return FlxRandom.intRanged(0, 3);
	}
	
	private static function mergeTiles(Map : Array<Int>) : Bool
	{
		var changed = false;
		for (y in 0 ... Reg.HEIGHT - 1)
		{
			for (x in 0 ... Reg.WIDTH - 1)
			{
				var cursor = new Vector2D(x, y);
				var check : Vector2D;
				if (cursor.x > 0)
				{
					check = new Vector2D(cursor.x - 1, cursor.y + 1);
					if (getTile(Map, check) == ROAD)
						changed = tryMerge(Map, cursor, check, true) || changed;
				}
				check = new Vector2D(cursor.x + 1, cursor.y + 1);
				if (getTile(Map, check) == ROAD)
					changed = tryMerge(Map, cursor, check, false) || changed;
			}
		}
		return changed;
	}
	
	private static function tryMerge(Map : Array<Int>, UpLeft : Vector2D, DownRight : Vector2D, Reversed : Bool)
	{
		var upRight : Vector2D;
		var downLeft : Vector2D;
		if (Reversed)
		{
			downLeft = DownRight;
			upRight = UpLeft;
			UpLeft = new Vector2D(downLeft.x, upRight.y);
			DownRight = new Vector2D(upRight.x, downLeft.y);
		}
		else
		{
			upRight = new Vector2D(DownRight.x, UpLeft.y);
			downLeft = new Vector2D(UpLeft.x, DownRight.y);
		}

		if (getTile(Map, upRight) == ROAD && getTile(Map, downLeft) == ROAD
			&& getTile(Map, UpLeft) == ROAD && getTile(Map, DownRight) == ROAD)
		{ //We have a Square
			//Pick one of the 4 to delete
			var cursor = new Vector2D(UpLeft.x + FlxRandom.intRanged(0, 1), UpLeft.y + FlxRandom.intRanged(0, 1));
			setTile(Map, cursor, randomGrass());
			//Look if something has been broken
			var tmp = new Vector2D(cursor.x, cursor.y);
			tmp.x += tmp.x == UpLeft.x ? -1 : 1;
			if (inBounds(tmp) && getTile(Map, tmp) == ROAD)
			{
				tmp.y += tmp.y == UpLeft.y ? 1 : -1;
				setTile(Map, tmp, ROAD);
			}
			tmp = new Vector2D(cursor.x, cursor.y);
			tmp.y += tmp.y == UpLeft.y ? -1 : 1;
			if (inBounds(tmp) && getTile(Map, tmp) == ROAD)
			{
				tmp.x += tmp.x == UpLeft.x ? 1 : -1;
				setTile(Map, tmp, ROAD);
			}
			return true;
		}
		if (getTile(Map, UpLeft) == ROAD && getTile(Map, DownRight) == ROAD
			&& getTile(Map, upRight) != ROAD && getTile(Map, downLeft) != ROAD)
		{
			setTile(Map, FlxRandom.sign() > 0 ? downLeft : upRight, ROAD);
			return true;
		}
		if (getTile(Map, upRight) == ROAD && getTile(Map, downLeft) == ROAD
			&& getTile(Map, UpLeft) != ROAD && getTile(Map, DownRight) != ROAD)
		{
			setTile(Map, FlxRandom.sign() > 0 ? UpLeft : DownRight, ROAD);
			return true;
		}
		return false;
	}
	
	private static function removeNoIssue(Map : Array<Int>) : Bool
	{
		var changed = false;
		for (y in 0 ... Reg.HEIGHT)
		{
			for (x in 0 ... Reg.WIDTH)
			{
				if (x == 0 && Lambda.has(entriesY, y)
					|| x == Reg.WIDTH - 1 && Lambda.has(exitY, y))
					continue ; //Ignore start and end
				var cursor = new Vector2D(x, y);
				if (getTile(Map, cursor) == ROAD)
				{
					var ways = 0;
					cursor.x++;
					ways += getTile(Map, cursor) == ROAD ? 1 : 0;
					cursor.x -= 2;
					ways += getTile(Map, cursor) == ROAD ? 1 : 0;
					cursor.x++;
					cursor.y++;
					ways += getTile(Map, cursor) == ROAD ? 1 : 0;
					cursor.y -= 2;
					ways += getTile(Map, cursor) == ROAD ? 1 : 0;
					if (ways <= 1)
					{
						cursor.y++;
						setTile(Map, cursor, randomGrass());
						changed = true;
					}
				}
			}
		}
		return changed;
	}
	
	private static function smoothRoad(Map : Array<Int>)
	{
		for (y in 0 ... Reg.HEIGHT)
		{
			for (x in 0 ... Reg.WIDTH)
			{
				var cursor = new Vector2D(x, y);
				if (getTile(Map, cursor) != ROAD)
					continue ;
				var ways = 0;
				cursor.x++;
				ways |= !(x == Reg.WIDTH - 1 && Lambda.has(exitY, y)) && (!inBounds(cursor) || isGrass(getTile(Map, cursor))) ? 0 : MASK_RIGHT;
				cursor.x -= 2;
				ways |= !(x == 0 && Lambda.has(entriesY, y)) && (!inBounds(cursor) || isGrass(getTile(Map, cursor))) ? 0 : MASK_LEFT;
				cursor.x++;
				cursor.y++;
				ways |= !inBounds(cursor) || isGrass(getTile(Map, cursor)) ? 0 : MASK_DOWN;
				cursor.y -= 2;
				ways |= !inBounds(cursor) || isGrass(getTile(Map, cursor)) ? 0 : MASK_UP;
				cursor.y++;
				setTile(Map, cursor, roadMasks.get(ways));
			}
		}
	}
}
