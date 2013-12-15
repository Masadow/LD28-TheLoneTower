package states;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author Masadow
 */
class PreState extends FlxState
{
	
	override public function create():Void 
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		super.create();
		
		var txt = new FlxText(0, 120, FlxG.width, "The Lone Tower", 40);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 250, FlxG.width, "LD 28", 30);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 400, FlxG.width, "Press SPACE to start", 20);
		txt.alignment = "center";
		add(txt);
	}
	
	override public function update()
	{
		super.update();

		if (FlxG.keys.pressed.SPACE)
			FlxG.switchState(new PlayState());
	}
	
}