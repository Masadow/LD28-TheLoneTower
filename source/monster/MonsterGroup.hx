package monster;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;
import flixel.util.FlxRandom;
import map.Level;

/**
 * ...
 * @author Masadow
 */
class MonsterGroup extends FlxGroup
{
	private var _hud : Hud;
	private var _tilemap : FlxTilemap;
	private var _nextSpawn : Float;
	private var _elapsed : Float;
	private var _level : Level;

	public function new(hud : Hud, Tilemap : FlxTilemap, Level : Level)
	{
		super();
		
		_hud = hud;
		_tilemap = Tilemap;
		_level = Level;
		
		_nextSpawn = f(_hud.score);
		_elapsed = 5; //Force spawn at the beginning
	}
	
	//Look if a monster is dead to re use it, if not, create a new one
	private function getMonster<T:Monster>(type : Class<T>) : Monster
	{
		var monster : Monster = null;
		for (dead in iterator(function(m) { return !m.alive && Std.is(m, type); }))
		{
			monster = cast dead;
			break ;
		}

		if (monster == null)
			return Type.createInstance(type, []);
		
		monster.reset(0, 0);
			
		return monster;
	}

	override public function update() {
		super.update();

		_nextSpawn = f(_hud.score);
		
		if (FlxG.paused)
			return ;

		for (entry in _level.entriesY) {
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
				var points : Array<FlxPoint> = null;
				while (points == null)
				{
					//Pick an entry at random
					var entry = _level.entriesY[FlxRandom.intRanged(0, _level.entriesY.length - 1)];
					monster.y = entry * 16;
					
					//Pick an exit at random
					var exit = _level.exitY[FlxRandom.intRanged(0, _level.exitY.length - 1)];
									
					//Set the path for the monster
					var entryY = entry * 16 + 8;
					var exitY = exit * 16 + 8;

					points = _tilemap.findPath(new FlxPoint(8, entryY), new FlxPoint(FlxG.width - 8, exitY));
				}
				if (!FlxG.paused) {
					var path : FlxPath = FlxPath.recycle();

					path.run(monster, points, monster.speed, 0, true);
				}
				
				monster.balanceLife(_hud.score);

				add(monster);
			}
		}
	}

	private function f(Score : Int) : Float {
//		Spawning rate (second per)
		var fscore = Score / 100000;
		fscore = 6 - (fscore * fscore + fscore * Math.sin(Score));
		return fscore > 1 ? fscore : 1;
	}
	
}