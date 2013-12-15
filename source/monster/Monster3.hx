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
		speed = 20;

		super("images/monster3.png");

		health = maxHealth;
	}
	
}