package monster;

/**
 * ...
 * @author Masadow
 */
class Monster2 extends Monster
{

	public function new() 
	{		
		maxHealth = 50;
		reward = 50;
		speed = 80;

		super("images/monster2.png");
		
		health = maxHealth;
	}
	
}