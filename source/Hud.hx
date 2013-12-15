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
	
	private var _score: FlxText;
	private var _money: FlxText;
	private var _nextLevel: FlxText;
	private var _upgrade: FlxText;

	private function set_score(Score : Int) : Int {
		score = Score;
		_score.text = "Score: " + score;
		return score;
	}

	private function set_money(Money: Int) : Int{
		money = Money;
		_money.text = "Money: " + money;
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

	public function new() 
	{
		super(0, 0);

		scrollFactor.set(0, 0);

		makeGraphic(FlxG.width, FlxG.height, 0xFF00FF00);

		//Create texts
		_money = new FlxText(0, 0, 80);
		_money.scrollFactor.set(0, 0);
		add(_money);
		_score = new FlxText(80, 0, 80);
		_score.scrollFactor.set(0, 0);
		add(_score);
		_nextLevel = new FlxText(160, 0, 80);
		_nextLevel.scrollFactor.set(0, 0);
		add(_nextLevel);
		_upgrade = new FlxText(240, 0, 80);
		_upgrade.scrollFactor.set(0, 0);
		add(_upgrade);
		
		var txt = new FlxText(320, 0, 80, "STOP music with M");
		add(txt);		
		
		money = 1000;
		score = 0;
		upgrade = 0;
	}
}