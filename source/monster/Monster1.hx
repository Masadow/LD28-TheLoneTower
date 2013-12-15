package monster;

/**
 * ...
 * @author Masadow
 */
class Monster1 extends Monster
{

	public function new() 
	{		
		maxHealth = 20;
		reward = 30;
		speed = 150;

		super("images/monster1.png");
		
		health = maxHealth;
	}

}