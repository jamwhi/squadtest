package SquadGame 
{
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author James White
	 */
	public class Soldier extends Agent 
	{
		
		public function Soldier(stageRef:Stage) 
		{
			super(stageRef);
			maxspeed = 3;
		}
		
		override public function takeHit(damage:int) : void
		{
			super.takeHit(damage);
			if (HP < 20 && currentState != 10)
			{
				Engine.director.callForMedic(this);
			}
		}
		
		override public function die()
		{
			super.die();
			Engine.hud.addScore(200);
		}
		
	}

}