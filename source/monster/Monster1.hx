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
		_modifier = 0.6;

		super("images/monster1.png");
		
		health = maxHealth;
	}

}