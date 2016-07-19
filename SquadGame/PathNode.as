package SquadGame 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author James White
	 */
	public class PathNode extends MovieClip
	{
		public var connections : Array = new Array;
		
		public var taken : Boolean = false;
		
		public var coverType : int = 0;
		
		// 0 means not cover
		
		// 1 means left cover (the wall is to the right)
		// 2 means left super cover (no duckout point)
		
		// 11 means right cover
		// 12 means right super cover (etc)
		
		// 21 means top cover ( wall is below)
		
		// 31 means bottom cover
		
		
		public var duckNode : int = -1;
		// duckpoint is where the agent will go from this covernode to shoot from
		
		public function PathNode() 
		{
			
		}
		
	}

}