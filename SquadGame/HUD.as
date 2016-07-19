package SquadGame 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author James White
	 */
	public class HUD extends MovieClip
	{
		private var score : Number = 0;
		
		private var bulletsFired : int = 0;
		
		public function HUD() 
		{
			
		}
		
		public function addScore(amount:Number) : void
		{
			score += amount;
			txt_score.text = String(score);
		}
		
		public function addBullets(amount:int) : void
		{
			bulletsFired += amount;
			txt_bulletsFired.text = String(bulletsFired);
		}
		
	}

}