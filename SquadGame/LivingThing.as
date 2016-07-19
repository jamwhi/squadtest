package SquadGame 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author James White
	 */
	public class LivingThing extends MovieClip 
	{
		protected var stageRef:Stage;
		
		protected var HPmax:int = 100;
		protected var HP:int = 100;
		protected var disabled : Boolean = false;
		protected var dead : Boolean = false;
		
		protected var speed:Number = 0.5;
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		protected var moveDirection:int = 0;
		
		protected var friction:Number = 0.9;
		protected var maxspeed:Number = 2;
		
		//fire related variables
		protected var fireTimer:Timer; //causes delay between fires
		protected var canFire:Boolean = true; //can you fire a shot
		
		public function LivingThing(stageRef:Stage) 
		{
			// Set the stageRef reference
			this.stageRef = stageRef;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			
			// Setup fireTimer and attach a listener to it.
			fireTimer = new Timer(100, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);
		}
		
		protected function loop(e:Event) : void
		{
			
		}
		
		private function fireTimerHandler(e:TimerEvent) : void
		{
			//timer ran, we can fire again.
			canFire = true;
		}
		
		public function heal(amount:int) : void
		{
			HP += amount;
			if (HP >= HPmax)
				disabled = false;
				
			updateHPBar();
		}
		
		public function isMaxHealth() : Boolean
		{
			if (HP >= HPmax)
				return true;
			
			return false;
		}
		
		protected function moveAndCheckCollisions() : void
		{
			// update positions based on current velocity
			// and check collisions
			
			/* i have this as 2 checks for now - first after moving
			* on the x axis, then after moving on the y axis.
			* this is so running into a wall will only stop the 
			* player in the direction the wall is in.
			* 
			* if i can figure out a way to do it with 1 check
			* that would be nice.
			* */
			
			var tempX : Number = x;
			x += vx;
			
			if (Engine.theLevel.wallshit.hitTestPoint(x, y, true))
			{
				x  = tempX;
				vx = 0;
			}
			
			var tempY : Number = y;
			y += vy;
			
			if (Engine.theLevel.wallshit.hitTestPoint(x, y, true))
			{
				y = tempY;
				vy = 0;
			}
		}
		
		public function takeHit(damage:int) : void
		{
			if (!dead)
			{
				HP -= damage;
				updateHPBar();
				
				if (HP <= 0)
				{
					HP = 0;
					die();
				}
			}
		}
		
		protected function updateHPBar() : void
		{
		}
		
		public function die()
		{
			dead = true;
		}
	}

}