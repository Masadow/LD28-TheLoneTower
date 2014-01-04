package states;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import map.Level;
import tweenx909.rule.BoolRuleX;

/**
 * ...
 * @author Masadow
 */
class EndState extends FlxState
{
	
	private var _score : Int;
	private var _money : FlxText;
	
	private var _firerate : FlxText;
	private var _power : FlxText;
	private var _target : FlxText;

	private var _sound : Bool;
	
	private var _level : Level;
	private var _nextLevel : Int;
	private var _record : Bool;
	private var _unlockLevel : Bool;

	public function new(level : Level, Score : Int = 12347, Sound : Bool = true) 
	{
		super();
		_score = Score;
		_sound = Sound;
		_level = level;
		
		//Unlock next level
		if (_level.number == Reg.save.level.length && Score > 5000)
		{
			Level.get(_level.number + 1); //Force creation of next level
			_unlockLevel = true;
			_nextLevel = _level.number + 1;
		}
		else
		{
			_nextLevel = _level.number;
			_unlockLevel = false;
		}

		_record = Score > _level.highscore;
		_level.highscore =  _record ? Score : _level.highscore;
	}
	
	override public function create():Void 
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.show();

		super.create();

		//Make sure everything is saved from here
		Reg.save.flush();
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		if (_sound)
			FlxG.sound.play("sounds/loose.wav");
		
		var txt : FlxText = new FlxText(0, 80, FlxG.width, "GAME OVER", 32);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 180, FlxG.width, _score + " PTS", 48);
		txt.alignment = "center";
		add(txt);
		
		if (_record)
		{
			txt = new FlxText(0, 240, FlxG.width, "New record !", 12);
			txt.alignment = "center";
			add(txt);
		}

		if (_unlockLevel)
		{
			txt = new FlxText(0, 260, FlxG.width, "Level " + _nextLevel + " unlocked !", 12);
			txt.alignment = "center";
			add(txt);
		}

		_money = new FlxText(200, 300, 150, "Money left: " + Reg.save.money + "$", 12);
		add(_money);
		
		addUpgrade(350, "Firerate: ", "firerate", function() { return (Reg.save.firerate *= 0.95) + ""; });
		addUpgrade(400, "Power: ", "power", function() { return (Reg.save.power += 3) + ""; });
		addUpgrade(450, "Target: ", "target", function() { return (++Reg.save.target) + ""; } );

		var btn : FlxButton = new FlxButton(600, 520, "Done", function() { FlxG.switchState(new PreState(_nextLevel)); } );
		add(btn);
		//btn = new FlxButton(500, 520, "Reset", function()
			//{
				//FlxG.save.erase();
				//FlxG.save.bind("save");
				//Reg.resetSave();
				//FlxG.switchState(new EndState(_level, _score, false));
			//}
		//);
		
		//Hacking
		//btn.scale.set(5, 5);
		//btn.label.size = 32;
		//btn.label.width = 350;
		//btn.label.alignment = "left";
		//btn.labelOffset.set(-70, -10);		
		//add(btn);
	}
	
	private function addUpgrade(Y : Int, Text : String, Varname : String, Callback : Void -> String)
	{
		var txt : FlxText = new FlxText(220, Y, 200, Text);
		add(txt);

		txt = new FlxText(300, Y, 80, Reflect.field(Reg.save, Varname));
		txt.alignment = "right";
		add(txt);
		
		var btn : FlxButton = null;
		btn = new FlxButton(400, Y, "Buy : " + Reflect.field(Reg.save, Varname + "Price") + "$", function () {
			var price : Int = Reflect.field(Reg.save, Varname + "Price");
			if (price > Reg.save.money)
				return ;
			Reg.save.money -= price;
			txt.text = Callback();
			price += Std.int(price / 10);
			Reflect.setField(Reg.save, Varname + "Price", price);
			btn.label.text = "Buy : " + price + "$";
			_money.text = "Money left: " + Reg.save.money + "$";
			Reg.save.flush();
			FlxG.sound.play("sounds/upgrade.wav");
		});
		add(btn);
	}
	
}