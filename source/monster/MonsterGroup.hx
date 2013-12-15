package monster;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Masadow
 */
class MonsterGroup extends FlxGroup
{
	private var _hud : Hud;
	private var _tilemap : FlxTilemap;
	private var entriesY : Array<Int>;
	private var exitY : Map < Int, Array<Int> > ;
	private var _nextSpawn : Float;
	private var _elapsed : Float;

	public function new(hud : Hud, Tilemap : FlxTilemap)
	{
		super();
		
		entriesY = [1, 11, 24];
		
		exitY = new Map < Int, Array<Int> > ();
		exitY[1] = [0, 5, 15];
		exitY[11] = [16, 26];
		exitY[24] = [29, 31, 33, 35];
		
		_hud = hud;
		_tilemap = Tilemap;
		
		_nextSpawn = f(_hud.score);
		_elapsed = 5; //Force spawn at the beginning
	}
	
	//Look if a monster is dead to re use it, if not, create a new one
	private function getMonster<T:Monster>(type : Class<T>) : Monster
	{
		var monster : Monster = null;
		for (dead in iteratorDead())
		{
			if (Std.is(dead, type))
			{				
				monster = cast dead;
				break ;
			}
		}

		if (monster == null)
			return Type.createInstance(type, []);
		
		monster.reset(0, 0);
			
		return monster;
	}

	override public function update() {
		super.update();

		for (entry in entriesY) {
			//Do we spawn a monster ?
			_elapsed += FlxG.elapsed;
			if (_elapsed >= _nextSpawn) {
				_elapsed -= _nextSpawn;
				//Pick a monster at random
				var monster : Monster = null;
				switch (FlxRandom.intRanged(0, 2)) {
					case 0: monster = getMonster(Monster1);
					case 1: monster = getMonster(Monster2);
					case 2: monster = getMonster(Monster3);
				}
				//Pick an entry at random
				var entry = entriesY[FlxRandom.intRanged(0, entriesY.length - 1)];
				monster.y = entry * 16;
				
				//Pick an exit at random
				var exit = exitY[entry][FlxRandom.intRanged(0, exitY[entry].length - 1)];
				
				//entry = entriesY[1];
				//monster.y = entry * 16;
				//exit = exitY[entry][1];
				
				//Set the path for the monster
				var entryY = entry * 16 + 8;
				var exitY = exit * 16 + 8;
				
				var points = _tilemap.findPath(new FlxPoint(8, entryY), new FlxPoint(FlxG.width - 8, exitY));
				if (points != null) {
					var path : FlxPath = FlxPath.recycle();
					
					path.run(monster, points, monster.speed, 0, true);
					//path.run(monster, points, 100, 0, true);
				}

				add(monster);
			}
		}
	}
	
	private function f(Score : Int) : Float {
//		Spawning rate (second per)
//		f(x) = a x + b;
//		f(0) = b = 5
//		f(1000) = a 1000 + 5 = 2
//		a = -3 / 1000
		return - 3 / 1000 * Score + 5;
	}
	
}