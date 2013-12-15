package monster;

/**
 * ...
 * @author Masadow
 */
class Monster3 extends Monster
{

	public function new() 
	{
		maxHealth = 100;
		reward = 150;
		speed = 50;

		super("images/monster3.png");

		health = maxHealth;
	}
	
}