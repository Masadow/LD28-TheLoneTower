package character;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import monster.Monster;
import monster.MonsterGroup;
import flixel.util.FlxMath;
import flixel.system.FlxSound;
import flixel.addons.text.FlxBlinkText;
import haxe.ds.ArraySort;

/**
 * ...
 * @author Masadow
 */
class Character extends FlxSpriteGroup
{
	
	private var _canon : FlxSprite;
	private var _rangeCircle : RangeCircle;
	private var _structure : FlxSprite;
	
	private var _powerUpgrade : FlxBlinkText;
	private var _targetUpgrade : FlxBlinkText;
	private var _firerateUpgrade : FlxBlinkText;
	
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
		
		_firerateUpgrade = new FlxBlinkText(-12, -10, 12, "Q", 0.3);
		_firerateUpgrade.visible = false;
		_firerateUpgrade.alpha = 0.8;
		add(_firerateUpgrade);
		_powerUpgrade = new FlxBlinkText(2, -10, 12, "W", 0.3);
		_powerUpgrade.visible = false;
		_powerUpgrade.alpha = 0.8;
		add(_powerUpgrade);
		_targetUpgrade = new FlxBlinkText(16, -10, 12, "E", 0.3);
		_targetUpgrade.visible = false;
		_targetUpgrade.alpha = 0.8;
		add(_targetUpgrade);
		
	}
	
	static var t : Int = 0;
	
	override  function update():Void 
	{
		super.update();
		
		_rangeCircle.x = _structure.x - _rangeCircle.range * 16;
		_rangeCircle.y = _structure.y - _rangeCircle.range * 16;
		
		//Upgrade UI
		_firerateUpgrade.visible = _hud.money > _hud.priceFirerate;
		_powerUpgrade.visible = _hud.money > _hud.pricePower;
		_powerUpgrade.visible = _hud.money > _hud.priceTarget;
		
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
		//Retrieve every monsters in range
		if (_lastShot > firerate)
		{
			var monstersInRange : Array<Monster> = new Array<Monster>();
			//Check if there is a monster in range
			for (monsterBasic in _monsters.iterator(function(m) { return m.exists && m.alive; }))
			{
				var midMonster : FlxPoint = (cast monsterBasic).getMidpoint();
				var midPoint : FlxPoint = _structure.getMidpoint();
				if (Std.int(FlxMath.getDistance(midMonster, midPoint)) < 16 * range + 8)
				{
					monstersInRange.push(cast monsterBasic);
				}
			}
			//Sort monsters in range by X position
			ArraySort.sort(monstersInRange, function(left, right) { return Std.int(right.x - left.x); });
//			monstersInRange
			//Now shoot as many monsters as the tower can
			for (monster in monstersInRange)
			{
				//Rotate the canon
				//Does not work
				//var topPoint : FlxPoint = midPoint;
				//topPoint.y -= 8;
				//var topmid : FlxPoint = new FlxPoint(midPoint.x - topPoint.x, midPoint.y - topPoint.y);
				//var monmid : FlxPoint = new FlxPoint(midPoint.x - midMonster.x, midPoint.y - midMonster.y);
				//var topmidb : Float = Math.sqrt(topmid.x * topmid.x + topmid.y * topmid.y);
				//var monmidb : Float = Math.sqrt(monmid.x * monmid.x + monmid.y * monmid.y);
				//_canon.set_angle(Math.acos((topmid.x * monmid.x + topmid.y * monmid.y) / (topmidb * monmidb)));

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