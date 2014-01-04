package map;

/**
 * ...
 * @author Masadow
 */
class Level
{

	public var map(default, null) : String;
	public var highscore : Int;
	public var number(default, null) : Int;

	public var entriesY(default, null) : Array<Int>;
	public var exitY(default, null) : Array<Int>;

	public function new(Number : Int) 
	{
		map = MapGenerator.generate();

		entriesY = new Array<Int>();
		for (entry in MapGenerator.entriesY)
			entriesY.push(entry);

		exitY = new Array<Int>();
		for (exit in MapGenerator.exitY)
			exitY.push(exit);

		highscore = 0;
		number = Number;
	}

	//Starts from 1
	public static function get(Number : Int, AutoFlush = true) : Level
	{
		if (Number < 1)
			throw "Wrong level requested";
		var needFlush = false;
		while (Number > Reg.save.level.length)
		{
			Reg.save.level.push(new Level(Reg.save.level.length + 1));
			needFlush = AutoFlush;
		}
		if (needFlush)
			Reg.save.flush();
		return Reg.save.level[Number - 1];
	}
}
