package SquadGame 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author James White
	 */
	public class Level1 extends MovieClip
	{
		var wallsarray:Array = new Array();
		var wallshitarray:Array = new Array();
		var graph:Array = new Array();
		
		var container:Sprite = new Sprite();
		
		
		public function Level1() 
		{
			wallsarray.push(walls.wall1);
			wallsarray.push(walls.wall2);
			wallsarray.push(walls.wall3);
			wallsarray.push(walls.wall4);
			wallsarray.push(walls.wall5);
			
			wallshitarray.push(wallshit.wall1);
			wallshitarray.push(wallshit.wall2);
			wallshitarray.push(wallshit.wall3);
			wallshitarray.push(wallshit.wall4);
			wallshitarray.push(wallshit.wall5);
			
			//laaame
			graph.push(path0);
			graph.push(path1);
			graph.push(path2);
			graph.push(path3);
			path4.coverType = 1;
			path4.duckNode = 0;
			graph.push(path4); // left, top      0
			path5.coverType = 11;
			path5.duckNode = 1;
			graph.push(path5); // right, top     1
			path6.coverType = 1;
			path6.duckNode = 8;
			graph.push(path6); // left, bottom   8
			path7.coverType = 11;
			path7.duckNode = 25;
			graph.push(path7); // right, bottom  25
			graph.push(path8);
			graph.push(path9);
			graph.push(path10);
			path11.coverType = 1;
			path11.duckNode = 8;
			graph.push(path11); // left, top     8
			path12.coverType = 11;
			path12.duckNode = 9;
			graph.push(path12); // right, top    9
			path13.coverType = 1;
			path13.duckNode = 15;
			graph.push(path13); // left, bottom  15
			path14.coverType = 11;
			path14.duckNode = 16;
			graph.push(path14); // right, bottom 16
			graph.push(path15);
			graph.push(path16);
			
			path17.coverType = 21;
			path17.duckNode = 50;
			graph.push(path17); // top, left    50
			path18.coverType = 21;
			path18.duckNode = 60;
			graph.push(path18); // top, right   60   (39 and 40)
			graph.push(path19);
			graph.push(path20);
			graph.push(path21);
			graph.push(path22);
			graph.push(path23);
			path24.coverType = 11;
			path24.duckNode = 22;
			graph.push(path24); // right, top    22
			graph.push(path25);
			path26.coverType = 11;
			path26.duckNode = 28;
			graph.push(path26); // right, bottom 28
			graph.push(path27);
			graph.push(path28);
			graph.push(path29);
			graph.push(path30);
			path31.coverType = 1;
			path31.duckNode = 27;
			graph.push(path31); // left, bottom 27
			path32.coverType = 1;
			path32.duckNode = 68;
			graph.push(path32); // left, top    68
			graph.push(path33);
			graph.push(path34);
			path35.coverType = 21;
			path35.duckNode = 33;
			graph.push(path35); // top, right    33
			path36.coverType = 21;
			path36.duckNode = 56;
			graph.push(path36); // top, left     56
			
			path37.coverType = 31;
			path37.duckNode = 54;
			graph.push(path37); // bottom, right 54
			path38.coverType = 31;
			path38.duckNode = 44;
			graph.push(path38); // bottom, left  44
			path39.coverType = 31;
			path39.duckNode = 68;
			graph.push(path39); // bottom, right 68   (17 and 18)
			path40.coverType = 31;
			path40.duckNode = 58;
			graph.push(path40); // bottom, left  58
			
			graph.push(path41);
			graph.push(path42);
			graph.push(path43);
			graph.push(path44);
			graph.push(path45);
			graph.push(path46);
			graph.push(path47);
			graph.push(path48);
			graph.push(path49);
			graph.push(path50);
			graph.push(path51);
			graph.push(path52);
			graph.push(path53);
			graph.push(path54);
			graph.push(path55);
			graph.push(path56);
			graph.push(path57);
			graph.push(path58);
			graph.push(path59);
			
			graph.push(path60);
			graph.push(path61);
			graph.push(path62);
			graph.push(path63);
			graph.push(path64);
			graph.push(path65);
			graph.push(path66);
			graph.push(path67);
			graph.push(path68);
			graph.push(path69);
			
			graph.push(path70);
			graph.push(path71);
			graph.push(path72);
			graph.push(path73);
			
			
			
			
			addChild(container);
			container.graphics.lineStyle(2,0x333333);
		}
		
		public function connectGraph() : void
		{
			// connect graph up
			
			var maxDistance:Number = 90;
			
			for (var i : int = 0; i < graph.length; i++)
			{
				for (var j : int = i + 1; j < graph.length; j++)
				{
					// first check if its within a certain distance
					var distanceX : Number = graph[i].x - graph[j].x;
					var distanceY : Number = graph[i].y - graph[j].y;
					var targetDistance:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
					
					if (targetDistance < maxDistance)
					{
						if (checkLineOfSight(graph[i].x, graph[i].y, graph[j].x, graph[j].y, true))
						{
/*							// after checking line of sight, check for other current very close angle connections and only leave the closer one
							// get angle
							var distanceX1 : Number = graph[i].x - graph[j].x;
							var distanceY1 : Number = graph[i].y - graph[j].y;
							var targetDirection:Number = Math.atan2(distanceY1, distanceX1);
							
							var noClash : Boolean = true;
							
							for (var k : int = 0; k < graph[i].connections.length; k++)
							{
								// get angle
								var distanceX2 : Number = graph[i].x - graph[graph[i].connections[k]].x;
								var distanceY2 : Number = graph[i].y - graph[graph[i].connections[k]].y;
								var thisDirection:Number = Math.atan2(distanceY2, distanceX2);
								
								if (Math.abs(targetDirection - thisDirection) < 0.3)
								{
									// too close - find the shorter connection and keep it. delete the longer connection.
									if (Math.abs(distanceX1) + Math.abs(distanceY1) < Math.abs(distanceX2) + Math.abs(distanceY2))
									{
										//then the new connection is shorter - make it and unmake the old one.
										connectNodes(i, j);
										trace ("connecting " + i + " with " + j);
										disconnectNodes(i, graph[i].connections[k]);
										noClash = false;
									}
									else
									{
										// old connection wins. make no change
										noClash = false;
									}
								}
							}
							if (noClash)
							{
*/								connectNodes(i, j);
//								trace ("connecting " + i + " with " + j);
//							}
						}
					}
				}
			}
		}
		
		private function connectNodes(i:Number, j:Number) : void
		{
			// joins 2 nodes, each to eachother
			graph[i].connections.push(j);
			graph[j].connections.push(i);
			//container.graphics.moveTo(graph[i].x, graph[i].y);
			//container.graphics.lineTo(graph[j].x, graph[j].y);
		}
		private function disconnectNodes(j:Number, k:Number) : void
		{
			trace ("Start disconnect... " + j + " from " + k);
			// disconnects 2 nodes from eachother
			var i:int = 0;
			trace (j + " has " + graph[j].connections.length + " connections")
			for (i = 0; i < graph[j].connections.length; i++)
			{
				trace ("   connected to: " + graph[j].connections[i]);
				if (graph[j].connections[i] == k)
				{
					graph[j].connections.splice(i, 1);
					trace ("Disconnected " + j + " from " + k);
					break;
				}
			}
			
			trace (k + " has " + graph[k].connections.length + " connections")
			for (i = 0; i < graph[k].connections.length; i++)
			{
				trace ("   connected to: " + graph[k].connections[i]);
				if (graph[k].connections[i] == j)
				{
					graph[k].connections.splice(i, 1);
					trace ("Disconnected " + k + " from " + j);
					break;
				}
			}
		}

		// returns the closest path node in the graph.
		public function nearestNode(x:Number, y:Number) : int
		{
			var closest:int = 0;
			var closestD:Number = 9001;
			for (var i : int = 0; i < graph.length; i++)
			{
				if (graph[i].x + graph[i].y < closestD)
				{
					closest = i;
					closestD = graph[i].x + graph[i].y;
				}
			}
			
			return closest;
		}
		
		public function randomNode(x:Number, y:Number, maxDistance:Number) : int
		{
			var nodesInRange:Array = new Array;
			
			// check which nodes are in range and add them to the new array
			for (var i : int = 0; i < graph.length; i++)
			{
				var distanceX : Number = x - graph[i].x;
				var distanceY : Number = y - graph[i].y;
				var targetDistance:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
				
				if (targetDistance < maxDistance)
				{
					nodesInRange.push(i);
				}
			}
			// pick a random node within the nodes in range
			var newNodeTarget:int = Math.random() * nodesInRange.length
			trace ("new movement target: node " + newNodeTarget);
			return nodesInRange[newNodeTarget];
		}
		
		public function AIMostDesirableAdvanceNode(startX:Number, startY:Number, targetX:Number, targetY:Number, maxDistance:Number) : int
		{
			var nodesInRange:Array = new Array;
			
			var distanceX : Number;
			var distanceY : Number;

			var targetDistance : Number;
			
			// check which nodes are in range, and not taken, and add them to the new array
			for (var i : int = 0; i < graph.length; i++)
			{
				distanceX = startX - graph[i].x;
				distanceY = startY - graph[i].y;
				targetDistance = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
				
				if (targetDistance < maxDistance)
				{
					if (!graph[i].taken)
						nodesInRange.push(i);
				}
			}
			// pick the closest to the target position with some randomness.
			var winningNode:int = -1;
			var winningDistance:Number = 9001;
			
			for (var j : int = 0; j < nodesInRange.length; j++)
			{
				distanceX = graph[nodesInRange[j]].x - targetX;
				distanceY = graph[nodesInRange[j]].y - targetY;
				targetDistance = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2));// + Math.random() * 40;
				
				if (targetDistance < winningDistance)
				{
					winningDistance = targetDistance;
					winningNode = nodesInRange[j];
				}
			}
			
			return winningNode;
		}
		
		public function nextNode(currentNode:int, targetNode:int, illegalNode:Array) : int
		{
			for (var i:int = 0; i < graph[currentNode].connections.length; i++)
			{
				// if the current node connects directly to the target node
				if (graph[currentNode].connections[i] == targetNode)
				{
					// then the next node is the target node!
					return targetNode;
				}
			}
			
			// otherwise, go to the closest possible node to the target node out of the options
			
			// find distance of target
			var distanceX : Number = graph[currentNode].x - graph[targetNode].x;
			var distanceY : Number = graph[currentNode].y - graph[targetNode].y;
			var targetDistance:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
			
			var bestDistance:Number = 9001;
			var bestNode:int = -1;
			
			// compare to distance each connected node is
			for (var i:int = 0; i < graph[currentNode].connections.length; i++)
			{
				if (illegalNode.indexOf(graph[currentNode].connections[i]) != -1 && graph[currentNode].connections.length > 1)
				{
					//disregard this node, unless it is the ONLY possible node					
				}
				else
				{
					distanceX = graph[targetNode].x - graph[graph[currentNode].connections[i]].x;
					distanceY = graph[targetNode].y - graph[graph[currentNode].connections[i]].y;
					var thisDistance:Number = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2))
					//var distanceDifference:Number = Math.abs(thisDistance - targetDistance);
					
					if (thisDistance < bestDistance)
					{
						// we have a new winner!
						bestNode = graph[currentNode].connections[i];
						bestDistance = thisDistance;
					}
				}
			}
			
			if (bestNode != -1)
				return bestNode;
			
			// if all else fails, return its current node
			return currentNode;
		}
		
		// checks if there are any walls inbetween point 1 and point 2
		public function checkLineOfSight(x1:Number, y1:Number, 
										 x2:Number, y2:Number, 
										 movementWalls:Boolean = false) : Boolean
		{
			var x3:Number, y3:Number, x4:Number, y4:Number;
			
			var i:int = 0;
			
			if (!movementWalls) // if we're using the walls to check line of sight
			{
				for (i = 0; i < wallsarray.length; i++)
				{
					x3 = wallsarray[i].x;
					y3 = wallsarray[i].y;
					x4 = wallsarray[i].x + wallsarray[i].width;
					y4 = wallsarray[i].y;
					
					if (lines_intersect(x1, y1, x2, y2, x3, y3, x4, y4))
						return false;
					
					x4 = wallsarray[i].x;
					y4 = wallsarray[i].y + wallsarray[i].height;
					
					if (lines_intersect(x1, y1, x2, y2, x3, y3, x4, y4))
						return false;
					
					x3 = wallsarray[i].x + wallsarray[i].width;
					y3 = wallsarray[i].y + wallsarray[i].height;
					
					if (lines_intersect(x1, y1, x2, y2, x3, y3, x4, y4))
						return false;
				}
			}
			else // if we're using the movement walls to check possible movements
			{
				for (i = 0; i < wallshitarray.length; i++)
				{
					var point1: Point = new Point(wallshitarray[i].x - 17, wallshitarray[i].y - 17);
					var point2: Point = new Point(wallshitarray[i].x + wallshitarray[i].hit.width * wallshitarray[i].scaleX - 17, wallshitarray[i].y - 17);
					
						//container.graphics.moveTo(point1.x, point1.y);
						//container.graphics.lineTo(point2.x, point2.y);
						
					if (lines_intersect(x1, y1, x2, y2, point1.x, point1.y, point2.x, point2.y))
						return false;
					
					point2.x = wallshitarray[i].x - 17;
					point2.y = wallshitarray[i].y + wallshitarray[i].hit.height * wallshitarray[i].scaleY - 17;
					
						//container.graphics.moveTo(point1.x, point1.y);
						//container.graphics.lineTo(point2.x, point2.y);
						
					if (lines_intersect(x1, y1, x2, y2, point1.x, point1.y, point2.x, point2.y))
						return false;
					
					point1.x = wallshitarray[i].x + wallshitarray[i].hit.width * wallshitarray[i].scaleX - 17;
					point1.y = wallshitarray[i].y + wallshitarray[i].hit.height * wallshitarray[i].scaleY - 17;
					
						//container.graphics.moveTo(point1.x, point1.y);
						//container.graphics.lineTo(point2.x, point2.y);
						
					if (lines_intersect(x1, y1, x2, y2, point1.x, point1.y, point2.x, point2.y))
						return false;
				}
			}
			
			return true;
		}
		
		// checks if two line segments intersect
		public function lines_intersect(x1:Number, y1:Number, 
										x2:Number, y2:Number, 
										x3:Number, y3:Number, 
										x4:Number, y4:Number) : Boolean
		{
			var a1:Number, a2:Number, b1:Number, b2:Number, c1:Number, c2:Number; // Coefficients of line eqns.
			var r1:Number, r2:Number, r3:Number, r4:Number;         // 'Sign' values
			var denom:Number, offset:Number, num:Number;     // Intermediate values
			
			// Compute a1, b1, c1, where line joining points 1 and 2
			// is "a1 x  +  b1 y  +  c1  =  0".

			a1 = y2 - y1;
			b1 = x1 - x2;
			c1 = x2 * y1 - x1 * y2;

			// Compute r3 and r4.
			
			r3 = a1 * x3 + b1 * y3 + c1;
			r4 = a1 * x4 + b1 * y4 + c1;

			// Check signs of r3 and r4.  If both point 3 and point 4 lie on
			// same side of line 1, the line segments do not intersect.
			
			var sameSigns:Boolean = false;
			
			if (r3 > 0 && r4 > 0)
				sameSigns = true;
			if (r3 < 0 && r4 < 0)
				sameSigns = true;

			if ( r3 != 0 &&
				 r4 != 0 &&
				 sameSigns)
				return ( false );

			// Compute a2, b2, c2

			a2 = y4 - y3;
			b2 = x3 - x4;
			c2 = x4 * y3 - x3 * y4;

			// Compute r1 and r2

			r1 = a2 * x1 + b2 * y1 + c2;
			r2 = a2 * x2 + b2 * y2 + c2;

			/* Check signs of r1 and r2.  If both point 1 and point 2 lie
			 * on same side of second line segment, the line segments do
			 * not intersect.
			 */
			
			sameSigns = false;
			
			if (r1 > 0 && r2 > 0)
				sameSigns = true;
			if (r1 < 0 && r2 < 0)
				sameSigns = true;

			if ( r1 != 0 &&
				 r2 != 0 &&
				 sameSigns)
				return ( false );
				
			return (true);

			/* Line segments intersect: compute intersection point. 
			 */

			//denom = a1 * b2 - a2 * b1;
			//if ( denom == 0 )
				//return ( COLLINEAR );
			//offset = denom < 0 ? - denom / 2 : denom / 2;
//
			///* The denom/2 is to get rounding instead of truncating.  It
			 //* is added or subtracted to the numerator, depending upon the
			 //* sign of the numerator.
			 //*/
//
			//num = b1 * c2 - b2 * c1;
			//*x = ( num < 0 ? num - offset : num + offset ) / denom;
//
			//num = a2 * c1 - a1 * c2;
			//*y = ( num < 0 ? num - offset : num + offset ) / denom;
//
			//return ( DO_INTERSECT );

		}
		
	}

}