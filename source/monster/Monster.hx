package monster;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import openfl.utils.Float32Array;

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
	private var _emitter : FlxEmitter;
	private var _barWidth : Int;
	private var _modifier : Float;
		
	override public function getMidpoint(?point:FlxPoint):FlxPoint 
	{
		return _graphic.getMidpoint(point);
	}

	
	override public function get_width():Float
	{
		return _graphic.width;
	}
	
	override public function get_height():Float
	{
		return _graphic.height;
	}
	
	private function new(Asset : String)
	{
		super();

		_graphic = new FlxSprite(0, 0, Asset);
		add(_graphic);
		
		_modifier = 1;
		
		width = _graphic.width;
		height = _graphic.height;

		_barWidth = Std.int((maxHealth / 100) * width);

		//Explode effect
		_emitter = new FlxEmitter();
		_emitter.makeParticles(Asset, 20);
		_emitter.xVelocity.min = -20;
		_emitter.xVelocity.max = 20;
		_emitter.yVelocity.min = -20;
		_emitter.yVelocity.max = 20;
		_emitter.startScale.min = 0.3;
		_emitter.startScale.max = 0.3;
		_emitter.endScale.min = 0.1;
		_emitter.endScale.max = 0.1;
		Reg.emmiters.add(_emitter);
	}
	
	override public function draw() {
		super.draw();
	}
	
	override public function update() {
		_healthBar.angle = 0;
		super.update();
	}
	
	override public function kill():Void 
	{
		super.kill();

		_emitter.at(_graphic);
		_emitter.start(true, 1, 0, 0, 1);
	}
	
	public function balanceLife(Score : Int):Void
	{
		maxHealth += Std.int((Score / 200) * _modifier);
		health = maxHealth;
		remove(_healthBar);
		_healthBar = new FlxBar( _graphic.width / 2 - _barWidth, 0, FlxBar.FILL_LEFT_TO_RIGHT, _barWidth * 2, 2, this, "health", 0, maxHealth);
		_healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
		add(_healthBar);
		_healthBar.currentValue = maxHealth;
		width = _graphic.width;
		height = _graphic.height;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		health = maxHealth;
		alive = true;
		revive();
	}
}