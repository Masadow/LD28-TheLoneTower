package ;
import flixel.effects.FlxFlicker;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import tweenx909.rule.BoolRuleX;
import tweenx909.TweenX;
import tweenx909.EaseX;
import tweenx909.ChainX;

/**
 * ...
 * @author Masadow
 */
class Hud extends FlxSpriteGroup
{

	public var money(get, set) : Int;
	public var score(default, set) : Int;
	public var nextLevel(default, set) : Int;

	private var _score: FlxText;
	private var _money: FlxText;
	private var _nextLevel: FlxText;
	private var _lastScoreNotif : Int;
	private var _scoreNotif : FlxText;

	private function set_score(Score : Int) : Int {
		score = Score;
		_score.text = "Score: " + score;
		if (score > _lastScoreNotif + 1000)
		{
			_lastScoreNotif += 1000;
			_scoreNotif.text = _lastScoreNotif + " PTS";
			_scoreNotif.alpha = 1;
		}
		return score;
	}

	private function get_money() : Int
	{
		return Reg.save.money;
	}
	private function set_money(Money: Int) : Int
	{
		Reg.save.money = Money;
		_money.text = "Money: " + Money + "$";
		return Money;
	}
	
	private function set_nextLevel(NextLevel : Int) : Int
	{
		nextLevel = NextLevel;
		_nextLevel.text = "Next level: " + nextLevel;
		return nextLevel;
	}

	public function new() 
	{
		super(0, 0);

		scrollFactor.set(0, 0);

		makeGraphic(FlxG.width, FlxG.height, 0xFF00FF00);

		//Create texts
		_money = new FlxText(0, 0, 120, "", 11);
		add(_money);
		_score = new FlxText(120, 0, 120, "", 11);
		add(_score);
		_nextLevel = new FlxText(240, 0, 120, "", 11);
		add(_nextLevel);
		var txt = new FlxText(0, 20, 300, "Mute: Music with M / Sound with S", 11);
		add(txt);

		_scoreNotif = new FlxText(0, 150, FlxG.width, "", 20);
		_scoreNotif.alignment = "center";
		add(_scoreNotif);
		
		money = Reg.save.money;
		score = 0;
		_lastScoreNotif = 0;

	}

	override public function update():Void 
	{
		super.update();
		
		if (_scoreNotif.alpha > 0)
			_scoreNotif.alpha -= FlxG.elapsed / (_scoreNotif.alpha * 3);
	}
}
