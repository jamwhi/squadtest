package SquadGame 
{	
	
	/**
	 * ...
	 * @author James White
	 */
	
	//import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	//import flash.utils.Timer;
	//import flash.events.TimerEvent;
	
	public class Agent extends SquadGame.LivingThing 
	{
		public var target:LivingThing;
		
		protected var currentState:int = -1;
		protected var moveTarget:int = -1;
		protected var moveTargetPoint:Point = new Point;
		public var currentNode:int = -1;
		protected var currentNodePoint:Point = new Point;
		public var previousNodes:Array = new Array(); //this array stops the agent from backstepping into loops. it stores the last nodes he's been on during this path.
		
		protected var thinkMax:Number = 20;
		protected var thinkCurrent:Number = 0;
		
		protected var healthLost:Number = 0;
		protected var inCover:Boolean = false;
		
		protected var firingState : int = 0;
		// firing state stores how far along the burst this agent is, as well as whether it is moving to/from a duckNode. 
		// -1 = moving to duckNode. -2 = returning from duckNode. positive number = how far into the burst it is. 0 is none.
		
		
		
		public function Agent(stageRef:Stage) 
		{
			super(stageRef);
			
			moveTarget = Engine.theLevel.nearestNode(this.x, this.y);
			moveTargetPoint = new Point(Engine.theLevel.graph[moveTarget].x, Engine.theLevel.graph[moveTarget].y);
			
			this.target = Engine.ourPlayer;
		}
		
		override protected function loop(e:Event) : void
		{
			switch(currentState)
			{
				case -1: // wandering
					wanderTick();
				break;
				
				case 0: // dead
					
				break;
				
				case 1: // moving
					moveTick();
				break;
				
				case 2: // waiting/thinking
					thinkTick();
				break;
				
				case 3: // attacking
					attackTick()
				break;
				
				case 10: //disabled
					disabledTick();
				break;
				
			}
			
			if (healthLost > 0)
			{
				healthLost -= 0.1;
			}
		}
		
		protected function wanderTick() : void
		{			
			thinkCurrent += 1
			
			if (thinkCurrent >= thinkMax)
			{
				// random movement
				maxspeed = 0.3
				moveDirection = Math.random() * 360;
				
				var directionInRadians:Number = moveDirection * Math.PI / 180;
				vx = Math.cos(directionInRadians) * maxspeed;
				vy = Math.sin(directionInRadians) * maxspeed;
				
				thinkCurrent = 0 - (Math.random() * 20);
				
				rotation = moveDirection;
				// Rotate hp bar upright
				hpbar.rotation = -moveDirection;
			}
			
			moveAndCheckCollisions();
			
			if (checkForEnemy())
			{
				// enemy sighted! go to think mode
				Engine.director.alertNewEnemy();
				currentState = 2;
				maxspeed = 3;
			}
		}
		
		protected function checkForEnemy() : Boolean
		{
			if (Engine.theLevel.checkLineOfSight(x, y, target.x, target.y))
			{
				Engine.director.reportEnemy(target.x, target.y);
				return true;
			}
			return false;
		}
		
		protected function thinkTick() : void
		{			
			// give some time to think.
			thinkCurrent += 1;
			
			// if "thinking" is complete, actually make a decision
			if (thinkCurrent >= thinkMax)
			{
				
				thinkCurrent = 0;
				previousNodes.length = 0; //clear the array of travelled nodes
				
				/* think function:
				 * first decide whether to:
				 * 			advance
				 * 				(high health/'morale', few friendly troops moving)
				 * 			find cover / retreat
				 * 				(taking fire)
				 * 			fire on the spot
				 * 				(after advancing, few friendly troops firing)
				 * 			fire from current cover (using ducknode)
				 * 				(having taken cover, fire at the enemy)
				 * 
				 * check healthlost
				 * 		if high, retreat/findcover/stay
				 * 		if medium & in cover, duckfire
				 * 		if low,
				 * check friendlies
				 * 		if low % firing, fire
				 * 		otherwise, advance
				 * */

				if (healthLost >= 20 && healthLost < 30 && inCover)
				{
					if (checkForEnemy())
					{		
						// direct line of sight of enemy, fire fire FIRE!
						
						currentState = 3;
						Engine.director.imFiring(this);
					}
					else
					{
						trace ("taken medium damage, fire from cover");
						//taking a bit of damage, and already in cover. mightaswell duck out and fire
						
						currentState = 3;
						Engine.director.imFiring(this);
					}
				}
				else if (healthLost >= 20)
				{
					// taking heavy damage, retreat!
					
					if (inCover)
					{
						trace ("heavy damage, staying in cover");
						// stay in cover
						thinkCurrent = -50;
					}
					else
					{
						trace ("heavy damage, finding cover");
						// find cover
						currentState = 1;
						
						Engine.theLevel.graph[moveTarget].taken = false;
						moveTarget = Engine.theLevel.randomNode(this.x, this.y, 10000);
						moveTargetPoint = new Point(Engine.theLevel.graph[moveTarget].x, Engine.theLevel.graph[moveTarget].y);
						Engine.theLevel.graph[moveTarget].taken = true;
					}
				}
				else 
				{
					if (checkForEnemy())
					{		
						// direct line of sight of enemy, fire fire FIRE!
						
						currentState = 3;
						Engine.director.imFiring(this);
					}
					
					//on to the second check
					else if (Engine.director.fireOrAdvance())
					{
						// fire on the enemy
						if (inCover)
						{
							trace ("firing from cover");
							// duck out and fire
							currentState = 3;
							Engine.director.imFiring(this);
						}
						else
						{
							trace ("firing at enemy from position");
							// fire straight at the enemy
							currentState = 3;
							Engine.director.imFiring(this);
						}
					}
					else
					{
						trace ("advancing on the enemy");
						// advance towards the enemy
						currentState = 1;
						
						Engine.theLevel.graph[moveTarget].taken = false;
						moveTarget = Engine.theLevel.AIMostDesirableAdvanceNode(this.x, this.y, target.x, target.y, 150);
						moveTargetPoint = new Point(Engine.theLevel.graph[moveTarget].x, Engine.theLevel.graph[moveTarget].y);
						Engine.theLevel.graph[moveTarget].taken = true;
					}
				}
			}
		}
		
		protected function moveTick() : void
		{			
			if (currentNode == -1) // no current node (just spawned?)
			{
					currentNode = Engine.theLevel.nearestNode(this.x, this.y);
					currentNodePoint = new Point(Engine.theLevel.graph[currentNode].x, Engine.theLevel.graph[currentNode].y);
					//moveTarget = currentNode;
					//moveTargetPoint = currentNodePoint;
					trace("CurrentNode = " + currentNode);
			}
			
			var distanceX : Number = currentNodePoint.x - x;
			var distanceY : Number = currentNodePoint.y - y;
			var distanceToNode:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
			
			if (distanceToNode <= maxspeed)
			{
				// close enough to effectively be on the node
				if (currentNode == moveTarget)
				{
					currentState = 2;
				}
				else
				{
					// find the next node to go to to get to the target node
					previousNodes.push(currentNode);
					currentNode = Engine.theLevel.nextNode(currentNode, moveTarget, previousNodes);
					currentNodePoint = new Point(Engine.theLevel.graph[currentNode].x, Engine.theLevel.graph[currentNode].y);
					trace("CurrentNode = " + currentNode);
				}
			}
			
			// move towards currentNode
			
			var angleInRadians : Number = Math.atan2(distanceY, distanceX);
			var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
			moveDirection = angleInDegrees;
			
			var directionInRadians:Number = moveDirection * Math.PI / 180;
			vx = Math.cos(directionInRadians) * maxspeed;
			vy = Math.sin(directionInRadians) * maxspeed;
			
			
			rotation = moveDirection;
			// Rotate hp bar upright
			hpbar.rotation = -angleInDegrees;
			
			moveAndCheckCollisions();
		}
		
		protected function attackTick() : void
		{
			if (inCover)
			{
				// this agent is in cover. this means it has to duck out and shoot a burst, then duck back in.
				if (firingState == 0)
				{
					// move to duckNode
					firingState = -1;
				}
				
				if (firingState < 0)
				{
					var distanceX : Number = 0;
					var distanceY : Number = 0;
					var distanceToNode : Number;
							
					if (firingState == -1)
					{
						// move towards duckNode
						if (Engine.theLevel.graph[currentNode].duckNode != -1)
						{
							distanceX = x - Engine.theLevel.graph[currentNode].duckNode.x;
							distanceY = y - Engine.theLevel.graph[currentNode].duckNode.y;
							distanceToNode = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2));
						}
					}
					else if (firingState == -2)
					{
						// move towards coverNode
						distanceX = x - Engine.theLevel.graph[currentNode].x;
						distanceY = y - Engine.theLevel.graph[currentNode].y;
						distanceToNode = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2));
					}
						
					// do the moving
					
					var angleInRadians : Number = Math.atan2(distanceY, distanceX);
					var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
					moveDirection = angleInDegrees;
					
					var directionInRadians:Number = moveDirection * Math.PI / 180;
					vx = Math.cos(directionInRadians) * maxspeed;
					vy = Math.sin(directionInRadians) * maxspeed;
					
					// check if node has been reached
					if (distanceToNode <= maxspeed)
					{
						if (firingState == -1)
						{
							firingState = 1;
						}
						else if (firingState == -2)
						{
							firingState = 0;
							currentState = 2;
							Engine.director.stoppedFiring(this);
						}
					}
				}
			}
			else
			{
				// not in cover. slightly simpler - just shoot at enemy.
				if (firingState == 0)
					firingState = 1;
					
				// Rotate towards target
				var distanceX : Number = target.x - x;
				var distanceY : Number = target.y - y;
				var angleInRadians : Number = Math.atan2(distanceY, distanceX);
				var angleInDegrees : Number = angleInRadians * (180 / Math.PI);
				rotation = angleInDegrees;
				
				hpbar.rotation = -angleInDegrees;
			}
			
			if (firingState <= 6 && firingState > 0)
			{
				fireBullet();
			}
			else if (firingState > 6)
			{
				// finished firing a burst.
				if (inCover)
				{
					firingState = -2;
				}
				else
				{
					currentState = 2;
					firingState = 0;
					Engine.director.stoppedFiring(this);
				}
			}
		}
		
		protected function disabledTick() : void
		{
			if (HP >= HPmax)
				currentState = 1;
		}
		
		
		public function alertNewEnemy() : void
		{
			// send them to the thinking state if they are wandering
			if (currentState == -1)
			{
				maxspeed = 3;
				currentState = 2;
			}
		}
		
		protected function fireBullet() : void
		{
			//if canFire is true, fire a bullet
			//set canFire to false and start our timer
			//else do nothing.
			
			if (canFire)
			{
				var rotationRad:Number = rotation / 180 * Math.PI;
				stageRef.addChild(new BulletYellow(stageRef, x + Math.cos(rotationRad) * width / 2, y + Math.sin(rotationRad) * height / 2, rotation));
				
				canFire = false;
				firingState += 1;
				fireTimer.start();
			}
		}
		
		override public function takeHit(damage:int) : void
		{	
			super.takeHit(damage);
			
			healthLost += damage;
			
			if (HP <= 20)
			{
				currentState = 10;
				Engine.director.callForMedic(this);
			}
		}
		
		override protected function updateHPBar() : void
		{
			hpbar.hpbar.scaleX = HP / HPmax;
		}
		
		override public function die()
		{
			super.die();
			currentState = 0;
		}
		
	}

}