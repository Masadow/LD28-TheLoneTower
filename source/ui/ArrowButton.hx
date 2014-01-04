package ui;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Masadow
 */
class ArrowButton extends FlxSpriteGroup
{

	public static inline var RIGHT : Int = 0;
	public static inline var LEFT : Int = 1;
	
	private var _normal : FlxSprite;
	private var _highlight : FlxSprite;
	private var _pressed : FlxSprite;
	
	private var _callback : Void -> Void;
	
	private function drawTriangle(Sprite : FlxSprite, Direction : Int, Size : Int, Color : UInt)
	{
		Sprite.makeGraphic(Size, Size, 0, true/*, Direction + "triangle" + Size + "-" + Color*/);

		FlxSpriteUtil.flashGfx.clear();
		FlxSpriteUtil.flashGfx.beginFill(Color);

		if (Direction == LEFT)
		{
			FlxSpriteUtil.flashGfx.moveTo(Size, 0);
			FlxSpriteUtil.flashGfx.lineTo(Size, Size);
			FlxSpriteUtil.flashGfx.lineTo(0, Size * 0.5);
			FlxSpriteUtil.flashGfx.lineTo(Size, 0);
		}
		else if (Direction == RIGHT)
		{
			FlxSpriteUtil.flashGfx.moveTo(0, 0);
			FlxSpriteUtil.flashGfx.lineTo(0, Size);
			FlxSpriteUtil.flashGfx.lineTo(Size, Size * 0.5);
			FlxSpriteUtil.flashGfx.lineTo(0, 0);
		}

		FlxSpriteUtil.flashGfx.endFill();

		FlxSpriteUtil.updateSpriteGraphic(Sprite);
	}

	public function new(Direction : Int, Size : Int, Callback : Void -> Void) 
	{
		super();
		
		_normal = new FlxSprite();
		_highlight = new FlxSprite();
		_pressed = new FlxSprite();

		drawTriangle(_normal, Direction, Size, 0x999999);
		drawTriangle(_highlight, Direction, Size, 0x555555);
		drawTriangle(_pressed, Direction, Size, 0xCCCCCC);

		add(_normal);
		add(_highlight);
		add(_pressed);
		
		_highlight.visible = false;
		_pressed.visible = false;
	}
	
	override public function update() : Void
	{
		super.update();
		
		var isOver = FlxG.mouse.x > x && FlxG.mouse.x < x + width && FlxG.mouse.y > y && FlxG.mouse.y < y + height;
		if (isOver && FlxG.mouse.justPressed)
		{
			_normal.visible = false;
			_highlight.visible = false;
			_pressed.visible = true;
		}
		else if (isOver && !FlxG.mouse.pressed)
		{
			_normal.visible = false;
			_highlight.visible = true;
			_pressed.visible = false;
		}
		else if (!FlxG.mouse.pressed || !isOver)
		{
			_normal.visible = true;
			_highlight.visible = false;
			_pressed.visible = false;
		}
		
		if (FlxG.mouse.justReleased && _pressed.visible)
		{
			_callback();
		}
	}
	
}