package SquadGame 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author James White
	 */
	public class AIDirector 
	{
		
		private var needsMedic : Array = new Array();
		private var squadMates : Array = new Array();
		private var target : LivingThing;
		private var lastKnownLocation : Point = new Point();
		private var numFiring : int = 0;
		
		public function AIDirector() 
		{
		}
		
		public function addSquadMate(who:LivingThing) : void
		{
			squadMates.push(who);
		}
		
		public function callForMedic(who:LivingThing) : void
		{
			needsMedic.push(squadMates.indexOf(who));
			target = who;
		}
		
		public function imFiring(who:LivingThing) : void
		{
			numFiring += 1;
		}
		
		public function stoppedFiring(who:LivingThing) : void
		{
			numFiring -= 1;
		}
		
		public function getSitRep(who:Agent) : Boolean
		{
			if (needsMedic.length >= 1)
			{
				trace ("need medic == true");
				who.target = squadMates[needsMedic[0]];
				return true;
			}
			return false;
		}
		
		public function healing(who:LivingThing, target:LivingThing)
		{
			needsMedic.splice(squadMates.indexOf(target), 1);
		}
		
		public function reportEnemy(x:Number, y:Number)
		{
			lastKnownLocation.x = x;
			lastKnownLocation.y = y;
		}
		
		public function getlastKnownLocation() : Point
		{
			return lastKnownLocation;
		}
		
		public function alertNewEnemy()
		{
			// alert nearby teammates of a new threat 
			for (var i:int = 0; i < Engine.enemyList.length; i++)
			{
				Engine.enemyList[i].alertNewEnemy();
			}
		}
		
		public function fireOrAdvance() : Boolean
		{
			if (numFiring <= squadMates.length * 0.4) // if 40% of less of squadmates are firing, return true
				return true;
				
			return false;
		}
	}

}