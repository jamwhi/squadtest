package SquadGame 
{
	
	/**
	 * ...
	 * @author James White
	 */
	
	//import flash.display.MovieClip; 
	import flash.display.Stage;
	import com.senocular.utils.KeyObject;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	//import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Player extends SquadGame.LivingThing
	{
		// Keyboard input class
		private var key:KeyObject;
		private var mouseDown:Boolean = false;
				
		//fire related variables
		private var currentWeapon:int = 1;
		
		private var weaponLock:Boolean = false; // stops player from changing weapon
		
		
		public function Player(stageRef:Stage) 
		{
			super(stageRef);
			
			// Create the keyboard input and mouse listener
			key = new KeyObject(stageRef);
			stageRef.addEventListener(MouseEvent.MOUSE_DOWN, setMouseDown, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_UP, setMouseUp, false, 0, true);
			
			maxspeed = 3;
		}
		
		override protected function loop(e:Event) : void
		{
			
			// Rotate player towards mouse
			var distanceX : Number = stageRef.mouseX - x;
			var distanceY : Number = stageRef.mouseY - y;
			var angleInRadians : Number = Math.atan2(distanceY, distanceX);
			var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
			rotation = angleInDegrees;
			
			// Rotate hp bar upright
			
			hpbar.rotation = -angleInDegrees;
			
			// Check keyboard input for movement
			if (key.isDown(Keyboard.A))
				vx -= speed;
			else if (key.isDown(Keyboard.D))
				vx += speed;
			else
				vx *= friction;
				
			if (key.isDown(Keyboard.W))
				vy -= speed;
			else if (key.isDown(Keyboard.S))
				vy += speed;
			else
				vy *= friction;
				
			// check other input
			if (key.isDown(Keyboard.SPACE) || mouseDown)
				fireBullet();
				
			// weapon changing
			if (key.isDown(Keyboard.Q))
			{
				if (!weaponLock)
				{
					nextWeapon();
					weaponLock = true;
				}
			}
			else
			{
				weaponLock = false;
			}
				
				
			// check for max speed
			
			if (vx > maxspeed)
				vx = maxspeed;
			else if (vx < -maxspeed)
				vx = -maxspeed;
				
			if (vy > maxspeed)
				vy = maxspeed;
			else if (vy < -maxspeed)
				vy = -maxspeed;
			
			// (little thing for a strange squeezing effect while moving)
			//scaleX = (maxspeed - Math.abs(vx))/(maxspeed*4) + 0.75;
			
			// update positions based on current velocity
			// and check collisions
			
			moveAndCheckCollisions();
		}
		
		private function nextWeapon() : void
		{
			currentWeapon += 1;
			if (currentWeapon > 3)
				currentWeapon = 1;
		}
		private function fireBullet() : void
		{
			//if canFire is true, fire a bullet
			//set canFire to false and start our timer
			//else do nothing.
			
			var rotationRad:Number = rotation / 180 * Math.PI;
			var inaccuracy:Number;
			
			switch (currentWeapon)
			{
				case 1: // pistol
				if (canFire)
				{
					stageRef.addChild(new BulletYellow(stageRef, x + Math.cos(rotationRad) * width / 2, y + Math.sin(rotationRad) * height / 2, rotation));
					
					canFire = false;
					fireTimer.delay = 200;
					fireTimer.start();
					Engine.hud.addBullets(1);
				}
				
				break;
				
				case 2: // rifle
				if (canFire)
				{
					inaccuracy = (Math.random() * 6 - 3);
					stageRef.addChild(new BulletYellow(stageRef, x + Math.cos(rotationRad) * width / 2, y + Math.sin(rotationRad) * height / 2, rotation + inaccuracy));
					
					canFire = false;
					fireTimer.delay = 50;
					fireTimer.start();
					Engine.hud.addBullets(1);
				}
				
				break;
				
				case 3: // shotgun
				if (canFire)
				{

					for (var i:int = 0; i < 9; i++)
					{
						inaccuracy = (Math.random() * 30 - 15);
						stageRef.addChild(new BulletYellow(stageRef, x + Math.cos(rotationRad) * width / 2, y + Math.sin(rotationRad) * height / 2, rotation + inaccuracy));
					}
					
					canFire = false;
					fireTimer.delay = 600;
					fireTimer.start();
					Engine.hud.addBullets(9);
				}
				
				break;
			}
		}

		//HANDLERS
		
		public function setMouseDown(e:MouseEvent) : void
		{
			mouseDown = true;
		}
		public function setMouseUp(e:MouseEvent) : void
		{
			mouseDown = false;
		}
		
		override protected function updateHPBar() : void
		{
			hpbar.hpbar.scaleX = HP / HPmax;
		}
		
		
	}

}