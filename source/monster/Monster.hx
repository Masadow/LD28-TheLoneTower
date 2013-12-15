package monster;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.FlxObject;

/**
 * ...
 * @author Masadow
 */
class Monster extends FlxSpriteGroup
{
	public var reward(default, null) : Int;
	public var speed(default, null) : Int;
	private var maxHealth : Int;
	private var _graphic : FlxSprite;
	private var _healthBar : FlxBar;

	private function new(Asset : String)
	{
		super();

		_graphic = new FlxSprite(0, 0, Asset);
		add(_graphic);
		
		width = _graphic.width;
		height = _graphic.height;

		_healthBar = new FlxBar( - width / 2, 0, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(width * 2), 2, this, "health", 0, maxHealth);
		_healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
		add(_healthBar);
		_healthBar.currentValue = maxHealth;
	}
	
	override public function draw() {
		super.draw();
	}
	
	override public function update() {
		_healthBar.angle = 0;
		super.update();
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		health = maxHealth;
		alive = true;
		revive();
	}
	
}