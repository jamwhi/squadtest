package SquadGame 
{
	import flash.display.MovieClip
	
	/**
	 * ...
	 * @author James White
	 */
	public class Wall extends MovieClip
	{
		
		public function Wall() 
		{
			this.hit.width += 34 / this.scaleX;
			this.hit.height += 34 / this.scaleY;
		}
		
	}

}