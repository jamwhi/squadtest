package SquadGame
{
	
	/**
	 * ...
	 * @author James White
	 */ 
	
	//list of our imports these are classes we need in order to
	//run our application.
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event

	public class Engine extends MovieClip
	{
		public static var ourPlayer:Player;
		public static var enemyList:Array = new Array();
		public static var theLevel:Level1;
		public static var director:AIDirector;
		public static var hud:HUD;
		
		public function Engine()
		{
			// create the level
			
			theLevel = new Level1();
			stage.addChild(theLevel);
			
			theLevel.connectGraph();
			
			// create an object of our player from the Player class
			ourPlayer = new Player(stage);
			// add it to the display list
			stage.addChild(ourPlayer);
			
			ourPlayer.x = stage.stageWidth -50;
			ourPlayer.y = stage.stageHeight -50;
			
			// create an enemy
			var enemy:Agent = new Soldier(stage);
			enemy.x = 50;
			enemy.y = 50;
			//add our enemy to the enemyList
			enemyList.push(enemy);
			stage.addChild(enemy);
			
			// create an enemy
			var enemy2:Agent = new Soldier(stage);
			enemy2.x = 50;
			enemy2.y = 110;
			//add our enemy to the enemyList
			enemyList.push(enemy2);
			stage.addChild(enemy2);
			
			// create an enemy
			var enemy3:Agent = new Soldier(stage);
			enemy3.x = 50;
			enemy3.y = 140;
			//add our enemy to the enemyList
			enemyList.push(enemy3);
			stage.addChild(enemy3);
			
			// create a medic
			enemy = new Medic(stage);
			enemy.x = 50;
			enemy.y = 80;
			//add our enemy to the enemyList
			enemyList.push(enemy);
			stage.addChild(enemy);
			
			
			
			//addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			
			// create the ai director
			director = new AIDirector();
			
			// create hud
			hud = new HUD();
			stage.addChild(hud);
		}
		
		//our loop function
		private function loop(e:Event) : void
		{
			
		}

	}
	
}