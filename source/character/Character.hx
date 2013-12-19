package character;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import monster.Monster;
import monster.MonsterGroup;
import flixel.util.FlxMath;
import flixel.system.FlxSound;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Masadow
 */
class Character extends FlxSpriteGroup
{
	
	private var _canon : FlxSprite;
	private var _rangeCircle : RangeCircle;
	private var _structure : FlxSprite;
	
	public var firerate(default, set) : Float;
	public var power(default, set) : Int;
	public var target(default, set) : Int;
	
	private function set_firerate(Firerate : Float) : Float
	{
		return firerate = _hud.firerate = Firerate;
	}
	private function set_power(Power : Int) : Int
	{
		return power = _hud.power = Power;
	}
	private function set_target(Target : Int) : Int
	{
		return target = _hud.target = Target;
	}

	public var level : Int;

	private var _lastShot : Float;

	private var _monsters : MonsterGroup;
	private var _hud : Hud;

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
		
		level = 2;
		
		_monsters = Monsters;
		_hud = hud;
		
		_structure = new FlxSprite();
		_structure.loadGraphic("images/tower.png");
		add(_structure);
		
		//Create the canon
		_canon = new FlxSprite();
		_canon.loadGraphic("images/canon.png");
		add(_canon);
		
		//Create the range circle
		_rangeCircle = new RangeCircle();
		_rangeCircle.range = 2;
		add(_rangeCircle);
		
		power = 20;
		firerate = 0.5; //Second between shots
		_lastShot = 0;
		target = 1;
	}
	
	static var t : Int = 0;
	
	override  function update():Void 
	{
		super.update();
		
		_rangeCircle.x = _structure.x - _rangeCircle.range * 16;
		_rangeCircle.y = _structure.y - _rangeCircle.range * 16;
		
		//Remove dead missiles
		var removeList: List<FlxBasic> = new List<FlxBasic>();
		for (dead in Reg.emmiters.iterator(function(m) { return !m.alive && Std.is(m, Missile); }))
		{
			removeList.push(dead);
		}
		for (missile in removeList)
		{
			Reg.emmiters.remove(missile);
		}
		
		var maxTarget = target;
		_lastShot += FlxG.elapsed;
		//Check if we should shoot
		if (_lastShot > firerate)
		{
			//Check if there is a monster in range
			for (monsterBasic in _monsters.iterator(function(m) { return m.exists && m.alive; }))
			{
				var monster : Monster = cast monsterBasic;
				var midMonster : FlxPoint = monster.getMidpoint();
				var midPoint : FlxPoint = _structure.getMidpoint();
				var topPoint : FlxPoint = midPoint;
				topPoint.y -= 8;
				if (Std.int(FlxMath.getDistance(midMonster, midPoint)) < 16 * range + 8)
				{
					//Rotate the canon
					//Does not work
					var topmid : FlxPoint = new FlxPoint(midPoint.x - topPoint.x, midPoint.y - topPoint.y);
					var monmid : FlxPoint = new FlxPoint(midPoint.x - midMonster.x, midPoint.y - midMonster.y);
					var topmidb : Float = Math.sqrt(topmid.x * topmid.x + topmid.y * topmid.y);
					var monmidb : Float = Math.sqrt(monmid.x * monmid.x + monmid.y * monmid.y);
					_canon.set_angle(Math.acos((topmid.x * monmid.x + topmid.y * monmid.y) / (topmidb * monmidb)));

					//Fire a missile
					Reg.emmiters.add(new Missile(_structure.x + 8, _structure.y + 8, monster.getMidpoint())); 
					
					FlxG.sound.play("sounds/shoot.wav");
					monster.hurt(power);
					if (!monster.alive) {
						//Kill monster, claim reward
						FlxG.sound.play("sounds/dead.wav");
						_hud.money += monster.reward;
						_hud.score += monster.reward;
					}
					_lastShot = 0;
					if (--maxTarget == 0)
						break ;
				}
			}
		}
		
	}
}