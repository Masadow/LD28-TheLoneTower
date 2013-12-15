package ;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Masadow
 */
class Hover extends FlxSprite
{

	public function new() 
	{
		super();
		
		loadGraphic("images/select.png");
	}
	
	override public function update() {
		this.x = FlxG.mouse.x - FlxG.mouse.x % 16;
		this.y = FlxG.mouse.y - FlxG.mouse.y % 16;
	}
	
	
}