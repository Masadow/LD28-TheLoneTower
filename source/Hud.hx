package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * ...
 * @author Masadow
 */
class Hud extends FlxSpriteGroup
{

	public var money(default, set) : Int;
	public var score(default, set) : Int;
	public var nextLevel(default, set) : Int;
	public var upgrade(default, set) : Int;
	public var target(default, set) : Int;
	public var firerate(default, set) : Float;
	public var power(default, set) : Int;
	public var priceTarget : Int;
	public var priceFirerate : Int;
	public var pricePower : Int;

	private var _score: FlxText;
	private var _money: FlxText;
	private var _nextLevel: FlxText;
	private var _upgrade: FlxText;
	private var _target : FlxText;
	private var _power : FlxText;
	private var _firerate : FlxText;

	private function set_score(Score : Int) : Int {
		score = Score;
		_score.text = "Score: " + score;
		return score;
	}

	private function set_money(Money: Int) : Int{
		money = Money;
		_money.text = "Money: " + money + "$";
		return money;
	}
	
	private function set_nextLevel(NextLevel : Int) : Int
	{
		nextLevel = NextLevel;
		_nextLevel.text = "Next level: " + nextLevel;
		return nextLevel;
	}

	private function set_upgrade(Upgrade : Int) : Int
	{
		upgrade = Upgrade;
		_upgrade.text = "Upgrade points: " + upgrade;
		return upgrade;
	}
	
	private function set_power(Power : Int) : Int
	{
		power = Power;
		_power.text = "Power (W for "+ pricePower +"$): " + power;
		return power;
	}

	private function set_firerate(Firerate : Float) : Float
	{
		firerate = Firerate;
		_firerate.text = "Firerate (Q for "+ priceFirerate +"$): " + Math.round((1 / firerate) * 10) / 10;
		return firerate;
	}

	private function set_target(Target : Int) : Int
	{
		target = Target;
		_target.text = "Targets (E for " + priceTarget +"$): " + target;
		return target;
	}

	public function new() 
	{
		super(0, 0);

		scrollFactor.set(0, 0);

		makeGraphic(FlxG.width, FlxG.height, 0xFF00FF00);

		//Create texts
		_money = new FlxText(0, 0, 120, "", 11);
		_money.scrollFactor.set(0, 0);
		add(_money);
		_score = new FlxText(120, 0, 120, "", 11);
		_score.scrollFactor.set(0, 0);
		add(_score);
		_nextLevel = new FlxText(240, 0, 120, "", 11);
		_nextLevel.scrollFactor.set(0, 0);
		add(_nextLevel);
		_upgrade = new FlxText(360, 0, 120, "", 11);
		_upgrade.scrollFactor.set(0, 0);
//		add(_upgrade);
		_firerate = new FlxText(0, FlxG.height - 20, 200, "", 12);
		_firerate.scrollFactor.set(0, 0);
		add(_firerate);
		_power = new FlxText(200, FlxG.height - 20, 200, "", 12);
		_power.scrollFactor.set(0, 0);
		add(_power);
		_target = new FlxText(400, FlxG.height - 20, 200, "", 12);
		_target.scrollFactor.set(0, 0);
		add(_target);
		
		var txt = new FlxText(240, 20, 120, "Mute with M", 11);
		add(txt);
		
		money = 0;
		score = 0;
		upgrade = 0;
		pricePower = 200;
		priceFirerate = 300;
		priceTarget = 1000;
	}
}