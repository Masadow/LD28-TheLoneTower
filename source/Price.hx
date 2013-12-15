package ;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import character.Character;

/**
 * ...
 * @author Masadow
 */
class Price extends FlxText
{

	private var _tower : Character;
	private var _hud : Hud;
	private var _tilemap : FlxTilemap;

	public var value(default, set) : Int;
	
	private function set_value(Value : Int) : Int
	{
		value = Value;
		text = "-" + value;
		return value;
	}
	
	public function new(Tower : Character, hud : Hud, Tilemap : FlxTilemap)
	{
		super(0, 0, 30);
		
		_tower = Tower;
		_hud = hud;
		_tilemap = Tilemap;
		
		this.alignment = "center";
	}
	
	override public function update() {
		
		super.update();

		var xmap : Int = Std.int(FlxG.mouse.x - FlxG.mouse.x % 16);
		var ymap : Int = Std.int(FlxG.mouse.y - FlxG.mouse.y % 16);

		x = xmap + 6 - _halfWidth;
		y = ymap - 4 - height;

		if (y < 0)
			y += 24 + height;
		
		if (_tilemap.getTile(Std.int(xmap / 16), Std.int(ymap / 16)) != 0) {
			text = "X";
			color = 0xAA0000;
			visible = true;
		}
		else {
			value = Std.int(Math.abs(_tower.x / 16 - xmap / 16) + Math.abs(_tower.y / 16 - ymap / 16)) * 10;
				
			if (_hud.money < value)
				color = 0xAA0000;
			else
				color = 0xFFFFFF;
				
			visible = value > 0;
		}
	}
	
}