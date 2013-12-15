package character;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import monster.Monster;
import monster.MonsterGroup;
import flixel.util.FlxMath;
import flixel.system.FlxSound;

/**
 * ...
 * @author Masadow
 */
class Character extends FlxSpriteGroup
{
	
	private var _canon : FlxSprite;
	private var _rangeCircle : RangeCircle;
	
	private var _firerate : Float;
	private var _power : Int;

	private var _lastShot : Float;

	private var _monsters : MonsterGroup;
	private var _hud : Hud;
//	private var _

	public var range(get, set) : Int;
	private function get_range() : Int
	{
		return _rangeCircle.range;
	}
	private function set_range(Range : Int) : Int
	{
		_rangeCircle.range = Range;
		return _rangeCircle.range;
	}

	public function new(X : Int, Y : Int, Monsters : MonsterGroup, hud : Hud) 
	{
		super(X, Y);

		_monsters = Monsters;
		_hud = hud;
		
		var structure = new FlxSprite();
		structure.loadGraphic("images/tower.png");
		add(structure);
		
		//Create the canon
		_canon = new FlxSprite();
		_canon.loadGraphic("images/canon.png");
		add(_canon);
		
		//Create the range circle
		_rangeCircle = new RangeCircle();
		_rangeCircle.range = 2;
		add(_rangeCircle);
		
		_power = 20;
		_firerate = 0.5; //Second between shots
		_lastShot = 0;
	}
	
	override  function update():Void 
	{
		super.update();
		
		_rangeCircle.x = x - _rangeCircle.range * 16;
		_rangeCircle.y = y - _rangeCircle.range * 16;

		_lastShot += FlxG.elapsed;
		//Check if we should shoot
		if (_lastShot > _firerate)
		{
			//Check if there is a monster in range
			for (monsterBasic in _monsters.iteratorAlive())
			{
				var monster : Monster = cast monsterBasic;
				var midMonster : FlxPoint = new FlxPoint(monster.x + 8, monster.y + 8);
				if (Std.int(FlxMath.getDistance(midMonster, getMidpoint())) < 16 * range + 8)
				{
					FlxG.sound.play("sounds/shoot.wav");
					monster.hurt(_power);
					if (!monster.alive) {
						//Kill monster, claim reward
						FlxG.sound.play("sounds/dead.wav");
						_hud.money += monster.reward;
						_hud.score += monster.reward;
					}
					_lastShot = 0;
					break ;
				}
			}
		}
		
	}
}