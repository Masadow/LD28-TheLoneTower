package ;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Masadow
 */
class Missile extends FlxSprite
{

	private var _target : FlxPoint;
	private var _lastDistance : Float;
	
	public function new(X : Float, Y : Float, Target : FlxPoint)
	{
		super(X, Y);
		_target = Target;
		makeGraphic(2, 6, 0xFFFF0000); //Red missile
		
		//calculate angle
		angle = FlxAngle.getAngle(new FlxPoint(X, Y), _target);
		velocity.x = Math.sin(FlxAngle.asRadians(angle)) * 1000;
		velocity.y = -Math.cos(FlxAngle.asRadians(angle)) * 1000;
		_lastDistance = 1000000;
	}
	
	override public function revive():Void 
	{
		super.revive();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxMath.getDistance(_target, getMidpoint()) > _lastDistance)
			kill();
		_lastDistance = FlxMath.getDistance(_target, getMidpoint());
	}
	
}