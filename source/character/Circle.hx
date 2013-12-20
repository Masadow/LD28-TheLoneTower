package character;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.util.loaders.CachedGraphics;
import flash.display.Graphics;

/**
 * ...
 * @author Masadow
 */
class Circle extends FlxSprite
{
	private var _timeleft : Float;
	
	public static function initGraphic()
	{
		//Prepare graphic
		var graphic : CachedGraphics = FlxG.bitmap.create(16, 16, 0x0, true, "circle");
		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.flashGfx.beginFill(0xFFFFFFFF);
		FlxSpriteUtil.flashGfx.lineStyle(2, 0xFFFFFF, 0.5);
		FlxSpriteUtil.flashGfx.drawCircle(8, 8, 8);
		FlxSpriteUtil.flashGfx.endFill();
		graphic.bitmap.draw(FlxSpriteUtil.flashGfxSprite);
//		FlxSpriteUtil.drawCircle(this, 8, 8, 8, 0x0, { color: 0x5FFFFFFF } );
	}

	public function new(MakeGraphic : Bool = true) 
	{
		super();

		loadGraphic("circle");
		
		visible = false;
	}
	
	public function run(X : Float, Y : Float) {
		x = X;
		y = Y;
		visible = true;
		_timeleft = 0.5; //In seconds
	}
	
	override public function update(): Void
	{
		super.update();

		if (_timeleft > 0 && (_timeleft -= FlxG.elapsed) < 0)
		{
			visible = false;
		}
	}
}