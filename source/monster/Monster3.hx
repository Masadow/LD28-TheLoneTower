package monster;

/**
 * ...
 * @author Masadow
 */
class Monster3 extends Monster
{

	public function new() 
	{
		maxHealth = 200;
		reward = 200;
		speed = 50;
		
		_modifier = 1.7;

		super("images/monster3.png");

		health = maxHealth;
	}
	
}