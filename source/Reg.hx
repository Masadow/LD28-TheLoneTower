package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;
import map.Level;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg
{
	public static inline var WIDTH : Int = 50;
	public static inline var HEIGHT : Int = 35;
	public static inline var HUD_HEIGHT : Int = 40; // = 600 - 35 * 16
	
	static public var save(get, null):Save = null;
	
	static public var emmiters:FlxGroup = new FlxGroup();

	public static function get_save() : Save
	{
		if (save == null)
		{
			save = Save.load();
		}
		return save;
	}
}