package monster;

/**
 * ...
 * @author Masadow
 */
class Monster1 extends Monster
{

	public function new() 
	{		
		maxHealth = 50;
		reward = 30;
		speed = 20;

		super("images/monster1.png");
		
		health = maxHealth;
	}

}