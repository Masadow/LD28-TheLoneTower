package states;

import character.Circle;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import flixel.util.FlxSpriteUtil;
import map.Tile;
import monster.Monster;
import monster.MonsterGroup;
import openfl.Assets;
import flixel.util.FlxPoint;
import character.Character;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Some static constants for the size of the tilemap tiles
	 */
	inline static private var TILESET = "images/tileset.png";
	inline static private var MAP = "data/map.csv";
	inline static private var TILE_WIDTH:Int = 16;
	inline static private var TILE_HEIGHT:Int = 16;
	
	private var _tower: Character;
	private var _tilemap: FlxTilemap;
	private var _path: FlxPath;
	private var _hud : Hud;
	private var _monsters : MonsterGroup;
	private var _mousePointer : FlxSprite;
	private var _towerMoves : FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;

		FlxG.mouse.hide();
		
		super.create();
		
		Reg.emmiters = new FlxGroup();
		
		_mousePointer = new FlxSprite(0, 0, null);
		_mousePointer.makeGraphic(5, 5, 0x0);
		FlxSpriteUtil.drawCircle(_mousePointer, 1, 1, 2, 0xFFFF0000);
		
		//Run soundtrack
		FlxG.sound.playMusic("music/loop.wav", 0.7);

		//Load our tilemap and add it
		_tilemap = new FlxTilemap();
		_tilemap.loadMap(Assets.getText(MAP),
				TILESET,
				TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF,
				0, 0);
		add(_tilemap);

		_tilemap.setTileProperties(4, FlxObject.NONE, 11);
		//_tilemap.setTileProperties(1, FlxObject.LEFT + FlxObject.DOWN);
		//_tilemap.setTileProperties(2, FlxObject.UP + FlxObject.RIGHT);
		//_tilemap.setTileProperties(3, FlxObject.DOWN + FlxObject.RIGHT);
		//_tilemap.setTileProperties(4, FlxObject.UP);
		//_tilemap.setTileProperties(7, FlxObject.UP);
		//_tilemap.setTileProperties(8, FlxObject.NONE);
		//_tilemap.setTileProperties(11, FlxObject.LEFT + FlxObject.RIGHT);
		_tilemap.setTileProperties(0, FlxObject.ANY, 4);

		_hud = new Hud();
		
		_monsters = new MonsterGroup(_hud, _tilemap); 

		//Create the tower
		_tower = new Character(320, 320, _monsters, _hud);
		
		//Create the group containing the moves circles
		_towerMoves = new FlxGroup();
		Circle.initGraphic();

		add(_towerMoves);
		add(_tower);
		add(_monsters);
		add(Reg.emmiters);
		add(_hud);
		add(_mousePointer);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	//Upgrades
	private function checkForUpgrade()
	{
		if (FlxG.keys.justPressed.E && _hud.money >= _hud.priceTarget)
		{
			_hud.money -= _hud.priceTarget;
			_hud.priceTarget += Std.int(_hud.priceTarget / 10);
			_tower.target++;
			FlxG.sound.play("sounds/upgrade.wav");
		}
		else if (FlxG.keys.justPressed.Q && _hud.money >= _hud.priceFirerate)
		{
			_hud.money -= _hud.priceFirerate;
			_hud.priceFirerate += Std.int(_hud.priceFirerate / 10);
			_tower.firerate *= 0.95;
			FlxG.sound.play("sounds/upgrade.wav");
		}
		else if (FlxG.keys.justPressed.W && _hud.money >= _hud.pricePower)
		{
			_hud.money -= _hud.pricePower;
			_hud.pricePower += Std.int(_hud.pricePower / 10);
			_tower.power += 3;
			FlxG.sound.play("sounds/upgrade.wav");
		}
		else if (FlxG.keyboard.justPressed("W", "Q", "E"))
			FlxG.sound.play("sounds/error.wav");
	}

	//Find the nearest tile from origin
	private function nearestTile(Origin : FlxPoint, X : Int, Y : Int) : FlxPoint
	{
		var closest : FlxPoint = null;
		var tmp : FlxPoint = null;
		
		if (X > 0 && Tile.isGrass(_tilemap.getTile(X - 1, Y)))
			closest = new FlxPoint((X - 1) * 16 + 8, Y * 16 + 8);
		if (X < _tilemap.widthInTiles - 1 && Tile.isGrass(_tilemap.getTile(X + 1, Y)))
		{
			tmp = new FlxPoint((X + 1) * 16 + 8, Y * 16 + 8);
			if (closest == null || FlxMath.getDistance(tmp, Origin) < FlxMath.getDistance(closest, Origin))
				closest = tmp;
		}
		if (Y > 0 && Tile.isGrass(_tilemap.getTile(X, Y - 1)))
		{
			tmp = new FlxPoint(X * 16 + 8, (Y - 1) * 16 + 8);
			if (closest == null || FlxMath.getDistance(tmp, Origin) < FlxMath.getDistance(closest, Origin))
				closest = tmp;
		}
		if (Y < _tilemap.heightInTiles - 1 && Tile.isGrass(_tilemap.getTile(X, Y + 1)))
		{
			tmp = new FlxPoint(X * 16 + 8, (Y + 1) * 16 + 8);
			if (closest == null || FlxMath.getDistance(tmp, Origin) < FlxMath.getDistance(closest, Origin))
				closest = tmp;
		}
		//No closest on 4 way intersection since we have already met a closest tile previously.
		return closest;
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		_mousePointer.x = FlxG.mouse.x;
		_mousePointer.y = FlxG.mouse.y;

		var tile = _tilemap.getTile(Std.int(FlxG.mouse.x / 16), Std.int(FlxG.mouse.y / 16));

		//Tower move
		var p = FlxG.mouse.getWorldPosition();
		if (!Tile.isGrass(tile))
		{
			//Find the nearest position
			p = nearestTile(FlxG.mouse.getWorldPosition(), Std.int(FlxG.mouse.x / 16), Std.int(FlxG.mouse.y / 16));
		}
		if (p != null)
		{
			var new_x = p.x - p.x % 16;
			var new_y = p.y - p.y % 16;
			//if the tower has moved
			if (_tower.x != new_x || _tower.y != new_y)
			{
	//			Looking for an object to recycle
				var circle : Circle = null;
				for (towerMove in _towerMoves.iterator(function(m) { return !m.visible; } ))
				{
					circle = cast towerMove;
					break ;
				}
				if (circle == null)
					_towerMoves.add((circle = new Circle()));
				circle.run(_tower.x, _tower.y);
				_tower.x = new_x;
				_tower.y = new_y;
			}
		}

		//Every level up, increase range by one
		if (levelup()) {
			FlxG.sound.play("sounds/levelup.wav");
			_tower.level++;
			_tower.range++;
		}
		
		checkForUpgrade();
		
		//check if a monster has reach the opposite side
		for (monster in _monsters.iterator(function(m) { return m.exists && m.alive; }))
		{
			if ((cast monster).x > FlxG.width - 24) {
				FlxG.switchState(new EndState(_hud.score));
			}
		}

		if (FlxG.keyboard.justPressed("M")) {
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
			else
				FlxG.sound.music.play();
		}
	}
	
	public function levelup() : Bool
	{
		// f(2) = 0
		// f(3) = 200
		// f(10) = 10000
		_hud.nextLevel = Std.int(150 * Math.pow(_tower.level + 1, 2) - 550 * (_tower.range + 1) + 500) - _hud.score;
		return _hud.nextLevel <= 0;
	}
	
}
