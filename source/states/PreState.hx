package states;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import map.Level;
import map.MapGenerator;
import ui.ArrowButton;

/**
 * Level selection screen
 * @author Masadow
 */
class PreState extends FlxState
{
	private var _level : Level;
	private var _mapHilight : FlxSprite;
	private var _map : FlxTilemap;
	
	//Level 0 stands for the last reached level
	public function new(level : Int = 0)
	{
		super();
		
		//Uncomment to reset the save
//		Reg.save.reset();

		//If the save does not exists
		//if (Reg.save.data.level == null)
		//{
			//Reg.resetSave();
		//}

		_level = Level.get(level == 0 ? Reg.save.level.length : level);
	}
	
	override public function create():Void 
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		super.create();

		var txt = new FlxText(0, 60, FlxG.width, "The Lone Tower", 40);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 150, FlxG.width, "Level " + _level.number, 14);
		txt.alignment = "center";
		add(txt);
		_map = new FlxTilemap();
		_map.loadMap(_level.map, "images/tileset.png", 16, 16, 0, 0, 0);
		
		_map.scaleX = 0.5;
		_map.scaleY = 0.5;
		_map.x = FlxG.width / 2 - _map.width / 2;
		_map.y = 180;
		
		_mapHilight = new FlxSprite(_map.x - 3, _map.y - 3);
		_mapHilight.makeGraphic(Std.int(_map.width) + 6, Std.int(_map.height) + 6, 0xFFCCCCCC);

		_mapHilight.visible = false;
		
		add(_mapHilight);
		add(_map);
		
		txt = new FlxText(0, 430, FlxG.width, "Highscore: " + _level.highscore, 14);
		txt.alignment = "center";
		add(txt);
		
		var arrow : ArrowButton = new ArrowButton(ArrowButton.LEFT, 70, function() { FlxG.switchState(new PreState(_level.number - 1)); } );
		arrow.active = _level.number > 1;
		arrow.x = 40;
		arrow.y = FlxG.height / 2 - arrow.height / 2;
		add(arrow);

		arrow = new ArrowButton(ArrowButton.RIGHT, 70, function() { FlxG.switchState(new PreState(_level.number + 1)); } );
		arrow.active = _level.number < Reg.save.level.length - 1;
		arrow.x = FlxG.width - arrow.width - 40;
		arrow.y = FlxG.height / 2 - arrow.height / 2;
		add(arrow);
		
		//txt = new FlxText(0, 250, FlxG.width, "LD 28", 30);
		//txt.alignment = "center";
		//add(txt);

		
		//var btn = new FlxButton(300, 500, "Play", function() { FlxG.switchState(new PlayState(_level)); } );
		//btn.x = FlxG.width / 2 - btn.width / 2;
		//add(btn);

		//btn = new FlxButton(420, 400, "Infinite mode", function() { FlxG.switchState(new PlayState(false)); });
		//add(btn);
	}
	
	override public function update()
	{
		_mapHilight.visible = FlxG.mouse.x > _map.x && FlxG.mouse.x < _map.x + _map.width && FlxG.mouse.y > _map.y && FlxG.mouse.y < _map.y + _map.height;

		super.update();

		if (FlxG.mouse.justPressed && _mapHilight.visible)
		{
			FlxG.switchState(new PlayState(_level));
		}
		
		//if (FlxG.keys.pressed.SPACE)
			//FlxG.switchState(new PlayState());
	}
	
}