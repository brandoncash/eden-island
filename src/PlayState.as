package
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "data/buttons.png")] private var ImgButtons:Class;
		[Embed(source = "data/rain.png")] private var ImgRain:Class;
		[Embed(source = "data/sfx/thunder.mp3")] private var SndThunder:Class;
		[Embed(source = "data/sfx/monkey-death.mp3")] private var SndAchievement:Class;
		
		private var sand:FlxGroup = new FlxGroup();
		private var seeds:FlxGroup = new FlxGroup();
		private var clouds:FlxGroup = new FlxGroup();
		private var water:Water = new Water();
		private var groundRect:Rectangle = new Rectangle(0, 0, 480, 160);
		private var groundPoint:Point = new Point(0, 0);
		private var weatherTimer:Number = 0;
		private var dropTimer:Number = 0;
		private var rainOverlay:FlxSprite = new FlxSprite(0, 0);
		private var helperText:FlxBitmapText;
		private var tools:Array = ['sand', 'plants', 'monkeys'];
		private var currentTool:int = 0;
		
		private var buttons:FlxGroup = new FlxGroup;
		private var sandButton:FlxButton;
		private var plantsButton:FlxButton;
		private var rainButton:FlxButton;
		private var earthquakeButton:FlxButton;
		private var anotherButton:FlxButton;
		private var monkeyButton:FlxButton;
		private var soundButton:FlxButton;
		private var helpButton:FlxButton;
		private var aboutButton:FlxButton;
		
		override public function create():void
		{
			var i:int;
			FlxState.bgColor = 0xff5199d0; // The sky color
			rainOverlay.createGraphic(480, 240, 0x774f3f57);
			rainOverlay.exists = false;
			
			// TODO: don't use built-in cursor, use a FlxSprite instead for animations
			FlxG.mouse.show();
			
			FlxG.playMusic(Assets.SndMusicMain, 0.3);
			
			// This is the starting island
			Assets.ground = new BitmapData(480, 160, true, 0x00000000);
			Assets.ground.fillRect(new Rectangle(75, 159, 330, 1), 0xffe3c885);
			
			// Set up the sand particles
			for (i = 0; i < 35; i++)
				sand.add(new SandParticle());
			add(sand);
			
			// Set up the seeds
			for (i = 0; i < 35; i++)
				seeds.add(new Seed());
			add(seeds);

			// Add some clouds
			clouds.add(new CloudHorizon(Math.random() * 100 - 100, "one"));
			clouds.add(new CloudHorizon(Math.random() * 100 + 50, "two"));
			clouds.add(new CloudHorizon(Math.random() * 100 + 325, "three"));
			clouds.add(new Cloud(Math.random() * -100, Math.random() * 65 + 20, "two"));
			clouds.add(new Cloud(Math.random() * 100 - 100, Math.random() * 65 + 20, "one"));
			clouds.add(new Cloud(Math.random() * 100 + 50, Math.random() * 65 + 20, "two"));
			clouds.add(new Cloud(Math.random() * 100 + 325, Math.random() * 65 + 20, "three"));
			
			// The rain emitter
			for (i = 0; i < 10; i++)
			{
				var drop:FlxSprite = new FlxSprite(0, 0);
				drop.loadGraphic(ImgRain, false, false, 128, 128);
				Assets.rainEmitter.add(drop);
			}
			Assets.rainEmitter.x = 0;
			Assets.rainEmitter.y = 0;
			Assets.rainEmitter.gravity = 0;
			Assets.rainEmitter.setSize(400, 5);
			Assets.rainEmitter.setRotation(0, 0);
			Assets.rainEmitter.setXSpeed(30, 30);
			Assets.rainEmitter.setYSpeed(230, 270);
			Assets.rainEmitter.kill();
			
			// You can add two bushes to start
			Assets.bushes.add(new Bush());
			Assets.bushes.add(new Bush());
			add(Assets.bushes);
			
			// You can add two trees to start
			Assets.trees.add(new Tree());
			Assets.trees.add(new Tree());
			add(Assets.trees);
			
			// You can add three monkeys to start
			Assets.monkeys.add(new Monkey());
			Assets.monkeys.add(new Monkey());
			Assets.monkeys.add(new Monkey());
			add(Assets.monkeys);
			
			// The pirate ship
			Assets.pirateShip = new PirateShip();
			add(Assets.pirateShip);
			
			// The sea monster
			Assets.monster = new Monster();
			add(Assets.monster);
			
			// Draw the helper text
			helperText = new FlxBitmapText(0, 25, Assets.fontSmall, "Click to pour sand.", "center", 480);
			helperText.color = 0xffffff;
			
			// Place the interface buttons
			sandButton = new FlxButton(190, 7, switchToSand);
			sandButton.loadGraphic(new Button('sand'), null, new Button('sand-pushed'));
			sandButton.on = true;
			buttons.add(sandButton);
			plantsButton = new FlxButton(205, 7, switchToPlants);
			plantsButton.loadGraphic(new Button('plants'), null, new Button('plants-pushed'));
			plantsButton.visible = false;
			buttons.add(plantsButton);
			monkeyButton = new FlxButton(220, 7, switchToMonkeys);
			monkeyButton.loadGraphic(new Button('monkey'), null, new Button('monkey-pushed'));
			monkeyButton.visible = false;
			buttons.add(monkeyButton);
			rainButton = new FlxButton(240, 7, toggleRain);
			rainButton.loadGraphic(new Button('rain'), null, new Button('rain-pushed'));
			rainButton.visible = true;
			buttons.add(rainButton);
			earthquakeButton= new FlxButton(255, 7, toggleEarthquake);
			earthquakeButton.loadGraphic(new Button('earthquake'), null, new Button('earthquake-pushed'));
			earthquakeButton.visible = true; // TODO: change this
			buttons.add(earthquakeButton);
			anotherButton = new FlxButton(270, 7, null);
			anotherButton.loadGraphic(new Button('another'), null, new Button('another-pushed'));
			anotherButton.visible = true; // TODO: change this
			buttons.add(anotherButton);
			soundButton = new FlxButton(428, 7, toggleSound);
			soundButton.loadGraphic(new Button('sound'), null, new Button('sound-pushed'));
			soundButton.on = !FlxG.mute; // Set it to the current flixel mute state
			buttons.add(soundButton);
			helpButton = new FlxButton(443, 7, toggleHelp);
			helpButton.loadGraphic(new Button('help'), null, new Button('help-pushed'));
			helpButton.on = true;
			buttons.add(helpButton);
			aboutButton = new FlxButton(458, 7, toggleAbout);
			aboutButton.loadGraphic(new Button('about'), null, new Button('about-pushed'));
			buttons.add(aboutButton);
		}
		
		override public function update():void
		{
			var i:int;
			helperText.update();
			buttons.update();
			clouds.update();
			water.update();
			if (!Assets.rainEmitter.dead) // If it's raining
				Assets.rainEmitter.update(); // We need to update the particles
			super.update();
			
			if (!Assets.rainEmitter.dead)
			{
				weatherTimer += FlxG.elapsed;
				if (weatherTimer > (Math.random() * 3 + 15))
				{
					FlxG.flash.start(0xccffff00, 0.2);
					FlxG.play(SndThunder, 0.5);
					weatherTimer = 0;
				}
			}
			
			switch (tools[currentTool])
			{ // Which tool we're using
				case 'sand':
					dropTimer += FlxG.elapsed;
					if (FlxG.mouse.pressed())
					{ // The mouse button is down.
						if (dropTimer > 0.03)
						{
							if ((FlxG.mouse.x > 90) && (FlxG.mouse.x < 390) && (FlxG.mouse.y > 35) && (FlxG.mouse.y < 160))
							{ // The mouse is in the droppable area, so drop some sand
								var particle:SandParticle = sand.getFirstAvail() as SandParticle;
								if (particle != null)
									particle.spawn(FlxG.mouse.x, FlxG.mouse.y);
							}
							dropTimer = 0;
						}
					}
				break;
				case 'plants':
					dropTimer += FlxG.elapsed;
					if (FlxG.mouse.pressed())
					{ // The mouse button is down.
						if (dropTimer > 0.03)
						{
							if ((FlxG.mouse.x > 90) && (FlxG.mouse.x < 390) && (FlxG.mouse.y > 35) && (FlxG.mouse.y < 160))
							{ // The mouse is in the droppable area, so drop some sand
								var seed:Seed = seeds.getFirstAvail() as Seed;
								if (seed != null)
									seed.spawn(FlxG.mouse.x, FlxG.mouse.y);
							}
							dropTimer = 0;
						}
					}
					/*if (FlxG.mouse.justPressed())
					{ // Mouse click
						if ((FlxG.mouse.x > 120) && (FlxG.mouse.x < 360) && (FlxG.mouse.y > 35) && (FlxG.mouse.y < 160) && (Assets.trees.countDead() > 0))
						{ // The mouse is in the droppable area, so drop a seed
							if (Assets.canAddTrees)
							{
								var tree:Tree = Assets.trees.getFirstDead() as Tree;
								if (tree != null)
								{
									tree.exists = true;
									tree.dead = false;
									tree.x = FlxG.mouse.x;
									tree.y = FlxG.mouse.y;
								}
							}
							else
							{
								var bush:Bush = Assets.bushes.getFirstDead() as Bush;
								if (bush != null)
								{
									bush.exists = true;
									bush.dead = false;
									bush.x = FlxG.mouse.x;
									bush.y = FlxG.mouse.y;
								}
							}
						}
					}*/
				break;
				case 'monkeys':
					if (FlxG.mouse.justPressed())
					{ // Mouse click
						if ((FlxG.mouse.x > 90) && (FlxG.mouse.x < 390) && (FlxG.mouse.y > 35) && (FlxG.mouse.y < 160) && (Assets.monkeys.countDead() > 0))
						{ // The mouse is in the droppable area, so drop a monkey
							var monkey:Monkey = Assets.monkeys.getFirstDead() as Monkey;
							monkey.dead = false;
							monkey.exists = true;
							monkey.anim = "panic";
							monkey.velocity.y = monkey.acceleration.y = 30;
							monkey.acceleration.x = 0;
							monkey.x = FlxG.mouse.x;
							monkey.y = FlxG.mouse.y;
						}
					}
				break;
			}
			
			if (FlxG.keys.justPressed("Q"))
				switchToSand();
			if (Assets.canAddPlants && FlxG.keys.justPressed("W"))
				switchToPlants();
			if (Assets.canAddMonkeys && FlxG.keys.justPressed("E"))
				switchToMonkeys();
			
			if (FlxG.keys.justPressed("R"))
				toggleRain();
			if (FlxG.keys.justPressed("H"))
				toggleHelp();
				
			// Some debug key press stuff ----------------------------
			if (FlxG.keys.justPressed("M"))
				Assets.monster.exists = true;
			if (FlxG.keys.justPressed("S"))
				Assets.pirateShip.spawn();
			if (FlxG.keys.justPressed("K"))
				Assets.pirateShip.kill();
			if (FlxG.keys.justPressed("N"))
				add(new Native());
			// End debug keys ----------------------------------------
			
			// Here are the achievements and help texts
			if (!Assets.canAddPlants && (Assets.sandParticlesUsed > 5))
			{ // You've put down enough sand for plants
				Assets.canAddPlants = true;
				helperText.text = "Because your island has grown, you can now add plants.";
				plantsButton.visible = true;
				FlxG.play(SndAchievement, 0.5);
				FlxG.flash.start(0xbbffffff);
			}
			if (!Assets.canWaterPlants && (Assets.bushes.countLiving() >= 2))
			{ // Added at least 2 plants
				Assets.canWaterPlants = true;
				helperText.text = "Press the rain button to toggle a storm on and off.";
				rainButton.visible = true;
				FlxG.play(SndAchievement, 0.5);
				FlxG.flash.start(0xbbffffff);
			}
			if (!Assets.canAddMonkeys && (Assets.numberOfGrownBushes >= 2))
			{ // You have at least 2 full grown bushes
				Assets.canAddMonkeys = true;
				helperText.text = "Your island can now support animal life.  Try adding some monkeys.";
				// Add a new monkey
				monkey = Assets.monkeys.getFirstDead() as Monkey;
				monkey.dead = false;
				monkey.exists = true;
				monkey.anim = "walk";
				monkey.velocity.y = monkey.acceleration.y = 30;
				monkey.acceleration.x = 0;
				monkey.x = Assets.bushes.members[1].x;
				monkey.y = Assets.bushes.members[1].x - 7;
				// End monkey
				monkeyButton.visible = true;
				FlxG.play(SndAchievement, 0.5);
				FlxG.flash.start(0xbbffffff);
			}
			if (!Assets.canAddTrees && (Assets.monkeys.countLiving() == 3))
			{ // You have added at least 2 monkeys
				Assets.canAddTrees = true;
				helperText.text = "The plant button will now allow you to drop trees.";
				FlxG.play(SndAchievement, 0.5);
				FlxG.flash.start(0xbbffffff);
			}
			if (!Assets.canAddMore && (Assets.numberOfGrownTrees == 2))
			{
				Assets.canAddMore = true;
				helperText.text = "You can now add more plants and animals.";
				for (i = 0; i < 5; i++) // Add a few new monkeys we can use
					Assets.monkeys.add(new Monkey());
				for (i = 0; i < 3; i++) // And trees
					Assets.trees.add(new Tree());
			}
			if (Assets.canPiratesCome && (Assets.monkeys.countLiving() > 6))
			{
				Assets.pirateShip.spawn();
			}
			/*if ((Assets.humans.countLiving() > 3) && (Assets.monkeys.countLiving() > 3))
			{
				if (Assets.monster == null)
				{
					Assets.monster = new Monster();
					add(Assets.monster);
				}
			}*/
		}
		
		/**
		 * We have to render everything in a very specific order
		 */
		override public function render():void
		{
			clouds.render(); // Clouds in the background
			FlxG.buffer.copyPixels(Assets.ground, groundRect, groundPoint, null, null, true); // Then the island
			super.render(); // All sprites (trees, monkeys, pirates, etc.)
			water.render(); // Render the water
			
			// TODO: Render anything on top of water here (monster, for instance)
			
			if (rainOverlay.exists) // This darkens the screen when it's raining
				rainOverlay.render();
			Assets.rainEmitter.render();
			if (helperText.exists) // Some text to help the player out
				helperText.render();
			buttons.render();
		}
		
		/**
		 * Switch to the sand tool
		 */
		public function switchToSand():void
		{
			currentTool = 0;
			sandButton.on = true;
			plantsButton.on = monkeyButton.on = false;
		}
		
		/**
		 * Switch to the plant tool
		 */
		public function switchToPlants():void
		{
			currentTool = 1;
			plantsButton.on = true;
			sandButton.on = monkeyButton.on = false;
		}
		
		/**
		 * Switch to the monkey tool
		 */
		public function switchToMonkeys():void
		{
			currentTool = 2;
			monkeyButton.on = true;
			sandButton.on = plantsButton.on = false;
		}
		
		/**
		 * Toggle the rain
		 */
		public function toggleRain():void
		{ // Toggle rain
			rainButton.on = !rainButton.on;
			rainOverlay.exists = !rainOverlay.exists;
			if (Assets.rainEmitter.dead)
			{ // Start the rain
				for (var i:int = 0; i < clouds.members.length; i++)
					clouds.members[i].acceleration.x = Math.random() * 5 + 3;
				Assets.rainEmitter.start(false, 0.1);
			}
			else
			{ // Stop the rain
				Assets.rainEmitter.kill();
			}
		}
		
		/**
		 * Toggle an earthquake
		 */
		public function toggleEarthquake():void
		{
			earthquakeButton.on = !earthquakeButton.on;
			FlxG.quake.start(0.005, 10); // TODO: Make this actually start/stop with the toggle
		}
		
		/**
		 * Toggle sound
		 */
		public function toggleSound():void
		{
			soundButton.on = !soundButton.on;
			FlxG.mute = !soundButton.on;
			Assets.updateSound();
		}
		
		/**
		 * Toggle the helper text
		 */
		public function toggleHelp():void
		{
			helperText.exists = !helperText.exists;
			helpButton.on = !helpButton.on;
		}
		
		/**
		 * Toggle the about information
		 */
		public function toggleAbout():void
		{
			aboutButton.on = !aboutButton.on;
		}
	}
}
