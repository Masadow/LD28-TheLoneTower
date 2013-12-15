package monster;

/**
 * ...
 * @author Masadow
 */
class Monster2 extends Monster
{

	public function new() 
	{		
		maxHealth = 80;
		reward = 50;
		speed = 30;

		super("images/monster2.png");
		
		health = maxHealth;
	}
	
}