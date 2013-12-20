package character;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.util.loaders.CachedGraphics;
import flash.display.Graphics;
import flash.filters.GlowFilter;
import tweenx909.TweenX;
import tweenx909.EaseX;

using tweenx909.ChainX;

/**
 * ...
 * @author Masadow
 */
class Circle extends FlxSprite
{
	private var _timeleft : Float;
	private var _glowFilter : GlowFilter;
	private var _spriteFilter : FlxSpriteFilter;
	
	public static function initGraphic()
	{
		//Prepare graphic
		var graphic : CachedGraphics = FlxG.bitmap.create(16, 16, 0x0, true, "circle");
		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.flashGfx.beginFill(0xFFFFFF);
		FlxSpriteUtil.flashGfx.drawCircle(8, 8, 5);
		FlxSpriteUtil.flashGfx.endFill();
		graphic.bitmap.draw(FlxSpriteUtil.flashGfxSprite);
	}

	public function new(MakeGraphic : Bool = true) 
	{
		super();

		loadGraphic("circle");
		
		//Set glowing
		_glowFilter = new GlowFilter(0xFFFFFF, 1, 2, 2, 2, 10, false, true);
		_spriteFilter = new FlxSpriteFilter(this, 16, 16);
		_spriteFilter.addFilter(_glowFilter);
//		_spriteFilter.applyFilters();

		//Actuate.tween(filter2, 1, { blurX:4, blurY:4 } ).repeat().reflect().onUpdate(updateFilter, [spr2Filter]).ease(Linear.easeNone);
		//Actuate.pause(filter2);
		
		visible = false;
	}
	
	public function run(X : Float, Y : Float) {
		x = X;
		y = Y;
		visible = true;
		_timeleft = 0.5; //In seconds
		
		//Reset glow and play anim
		_glowFilter.blurX = 2;
		_glowFilter.blurY = 2;
		TweenX.to(_glowFilter).blurX(0).blurY(0).time(_timeleft).ease(EaseX.expoInOut);
	}
	
	override public function update(): Void
	{
		super.update();

		_spriteFilter.applyFilters();
		if (_timeleft > 0 && (_timeleft -= FlxG.elapsed) < 0)
		{
			visible = false;
		}
	}
}