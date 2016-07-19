package SquadGame 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author James White
	 */
	public class Medic extends Agent 
	{
		
		public function Medic(stageRef:Stage) 
		{
			super(stageRef);
			gotoAndStop(2);
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
				
				case 4: // running to heal
					toHealTick();
				break;
				
				case 5: // healing
					healTick();
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
		
		override protected function thinkTick() : void
		{
			if (Engine.director.getSitRep(this))
			{
				Engine.director.healing(target, this);
				currentState = 4;
				
				// set moveTarget to the node of the agent that needs healing
				var tempMoveTarget:Agent = target as Agent;
				moveTarget = tempMoveTarget.currentNode;
				moveTargetPoint = new Point(Engine.theLevel.graph[moveTarget].x, Engine.theLevel.graph[moveTarget].y);
				previousNodes.length = 0;
				
				trace ("MOVING TO HEAL!");
				trace ("Current Node = " + currentNode);
				trace ("Target Node = " + moveTarget);
			}
			else
			{
				super.thinkTick();
			}
		}
		
		private function healTick()
		{
			target.heal(1);
			
			if (target.isMaxHealth())
			{
				currentState = 1;
				target = Engine.ourPlayer;
			}
		}
		
		private function toHealTick()
		{			
			
			var distanceX : Number = currentNodePoint.x - x;
			var distanceY : Number = currentNodePoint.y - y;
			var distanceToNode:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
			
			if (distanceToNode <= maxspeed)
			{
				// close enough to effectively be on the node
				if (currentNode == moveTarget)
				{
					// this means the medic got to the targetnode without finding the soldier. From here, we can use the soldier's 
					// last node in his previousNodes array
					var tempTarget:Agent = target as Agent;
					moveTarget = tempTarget.previousNodes[previousNodes.length - 1]
					moveTargetPoint = new Point(Engine.theLevel.graph[moveTarget].x, Engine.theLevel.graph[moveTarget].y);
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

			// check if in range of friendly to heal him
			distanceX = x - target.x;
			distanceY = y - target.y;
			if (Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2)) < hit.width)
			{
				currentState = 5;
			}
			
			rotation = moveDirection;
			// Rotate hp bar upright
			hpbar.rotation = -moveDirection;
				
			moveAndCheckCollisions();
		}
		
		override public function die()
		{
			super.die();
			Engine.hud.addScore(500);
		}
		
	}

}