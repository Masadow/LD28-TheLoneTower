package states;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Masadow
 */
class EndState extends FlxState
{
	
	private var _score : Int;

	public function new(Score : Int = 12347) 
	{
		super();
		_score = Score;
	}
	
	override public function create():Void 
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.show();

		super.create();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.play("sounds/loose.wav");
		
		var txt : FlxText = new FlxText(0, 100, FlxG.width, "GAME OVER", 32);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 200, FlxG.width, _score + " PTS", 48);
		txt.alignment = "center";
		add(txt);

		var btn : FlxButton = new FlxButton(265, 320, "TRY AGAIN", function() { FlxG.switchState(new PlayState()); } );
		
		//Hacking
		btn.scale.set(5, 5);
		btn.label.size = 32;
		btn.label.width = 350;
		btn.label.alignment = "left";
		btn.labelOffset.set(-70, -10);		
		add(btn);
	}
	
}