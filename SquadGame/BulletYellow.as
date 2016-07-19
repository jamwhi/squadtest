package SquadGame 
{
		
	/**
	 * ...
	 * @author James White
	 */
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;

	public class BulletYellow extends MovieClip
	{
		
		private var stageRef:Stage;
		private var bulletSpeed:Number = 18;
		
		public function BulletYellow(stageRef:Stage, x:Number, y:Number, rotation:Number) : void
		{
			this.stageRef = stageRef;
			this.x = x;
			this.y = y;
			this.rotation = rotation;
			
			checkCollisions();
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		private function loop(e:Event) : void
		{
			checkCollisions();
			//move bullet forward
			var rotationRad:Number = rotation / 180 * Math.PI;
			
			y += Math.sin(rotationRad) * bulletSpeed;
			x += Math.cos(rotationRad) * bulletSpeed;
			
			if (y < 0 || y > stageRef.stageHeight)
				removeSelf();
				
			if (x < 0 || x > stageRef.stageWidth)
				removeSelf();
				
		}
		
		private function checkCollisions()
		{
			// hit detection checks
			
			// find the global coordintes of the hitbox's point
			var hitPoint:Point = new Point(hit.x, hit.y);
			hitPoint = localToGlobal(hitPoint);
			
			// hit player check
			
			var target:Player = Engine.ourPlayer;
			
			if (Math.sqrt(Math.pow((hitPoint.x) - (target.x), 2) + Math.pow((hitPoint.y) - (target.y), 2)) < target.hit.width / 2)
			{
				stageRef.addChild(new BulletHit(stageRef, hitPoint.x, hitPoint.y));
				target.takeHit(2);
				removeSelf();
			}
			
			// hit enemy check
			var target2:Agent;
			for (var i:int = 0; i < Engine.enemyList.length; i++)
			{
				target2 = Engine.enemyList[i];
				if (Math.sqrt(Math.pow((hitPoint.x) - (target2.x), 2) + Math.pow((hitPoint.y) - (target2.y), 2)) < target2.hit.width / 2)
				{
					stageRef.addChild(new BulletHit(stageRef, hitPoint.x, hitPoint.y));
					Engine.enemyList[i].takeHit(2);
					removeSelf();
				}
			}
			
			// hit walls check
			if (Engine.theLevel.walls.hitTestPoint(hitPoint.x, hitPoint.y, true))
			{
				removeSelf();
			}
		}
 
		private function removeSelf() : void
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			
			if (stageRef.contains(this))
				stageRef.removeChild(this);
		}

		
	}

}