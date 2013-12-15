package character;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Masadow
 */
class RangeCircle extends FlxSprite
{
	
	public var range(default, set) : Int;

	private function set_range(Range : Int) : Int
	{
		range = Range;
		makeGraphic(range * 16 * 2 + 16, range * 16 * 2 + 16, 0x0);
		FlxSpriteUtil.drawCircle(this, range * 16 + 8, range * 16 + 8, range * 16 + 8, 0x550000AA);
		return range;
	}
	
	public function new()
	{
		super();
	}
	
}