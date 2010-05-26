package
{
	import org.flixel.*;
	
	public class PirateShip extends FlxSprite
	{
		[Embed(source = "data/pirateship.png")] private var ImgPirateShip:Class;
		[Embed(source = "data/pirateship-sails.png")] private var ImgSails:Class;
		[Embed(source = "data/pirateship-flag-big.png")] private var ImgBigFlag:Class;
		[Embed(source = "data/pirateship-flag-small.png")] private var ImgSmallFlag:Class;
		[Embed(source = "data/pirateship-destroyed-left.png")] private var ImgDestroyedLeft:Class;
		[Embed(source = "data/pirateship-destroyed-right.png")] private var ImgDestroyedRight:Class;
		[Embed(source = "data/pirateship-destroyed-middle.png")] private var ImgDestroyedMiddle:Class;
		[Embed(source = "data/bubbles.png")] private var ImgBubbles:Class;
		[Embed(source = "data/sfx/pirateship-land.mp3")] private var SndLand:Class;
		[Embed(source = "data/sfx/monster-loop.mp3")] private var SndDestroy:Class;
		[Embed(source = "data/sfx/Output.mp3")] private var SndMusicPirates:Class;
		
		public var pirates:FlxGroup;
		private var piratesLeft:int = 5;
		private var _reefed:Boolean = false; // Are the sails up?
		private var frontSails:FlxSprite = new FlxSprite(480, 0);
		private var midSails:FlxSprite = new FlxSprite(480, 0);
		private var backSails:FlxSprite = new FlxSprite(480, 0);
		private var bigFlag:FlxSprite = new FlxSprite(480, 0);
		private var smallFlag:FlxSprite = new FlxSprite(480, 0);
		private var destroyedLeft:FlxSprite = new FlxSprite(480, 0);
		private var destroyedRight:FlxSprite = new FlxSprite(480, 0);
		private var destroyedMiddle:FlxSprite = new FlxSprite(480, 0);
		private var bubbles:FlxEmitter = new FlxEmitter(480, 0);
		private var state:String = "arriving";
		private var timer:Number = 0;
		private var offsetFrames:Array = [0, 1, 2, 1, 0];
		private var currentOffset:int = 0;
		
		public function PirateShip()
		{
			super(480, 79);
			//super(315, 79);
			loadGraphic(ImgPirateShip, false, false, 117, 95);
			exists = false;
			health = 100;
			velocity.x = -10;
			state = "arriving";
			
			pirates = new FlxGroup();
			for (var i:int = 0; i < 5; i++)
			{ // Add a complement of pirates
				pirates.add(new Pirate());
				// TODO: Pirates need to be recycled - when adding them to this list, also add them to Assets.pirates or something
				//		- how to remove them from the Assets.pirates list?
			}
			
			// And sails and flags and stuff:
			frontSails.loadGraphic(ImgSails, true, false, 24, 22);
			frontSails.addAnimation("idle", [0, 1, 2], 10);
			frontSails.addAnimation("idle-slow", [0, 1, 2], 5);
			frontSails.addAnimation("up", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 5, false);
			frontSails.addAnimation("down", [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 5, false);
			frontSails.play("idle");
			
			midSails.loadGraphic(ImgSails, true, false, 24, 22);
			midSails.addAnimation("idle", [0, 1, 2], 10);
			midSails.addAnimation("idle-slow", [0, 1, 2], 5);
			midSails.addAnimation("up", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 5, false);
			midSails.addAnimation("down", [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 5, false);
			midSails.play("idle");
			
			backSails.loadGraphic(ImgSails, true, false, 24, 22);
			backSails.addAnimation("idle", [0, 1, 2], 10);
			backSails.addAnimation("idle-slow", [0, 1, 2], 5);
			backSails.addAnimation("up", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 5, false);
			backSails.addAnimation("down", [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 5, false);
			backSails.play("idle");
			
			bigFlag.loadGraphic(ImgBigFlag, true, false, 14, 13);
			bigFlag.addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10);
			bigFlag.addAnimation("idle-slow", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 7);
			bigFlag.play("idle");
			
			smallFlag.loadGraphic(ImgSmallFlag, true, false, 7, 5);
			smallFlag.addAnimation("idle", [0, 1, 2, 3, 4], 10);
			smallFlag.addAnimation("idle-slow", [0, 1, 2, 3, 4], 5);
			smallFlag.play("idle");
			
			// These are parts of the destroyed ship
			destroyedRight.loadGraphic(ImgDestroyedRight, true, false, 77, 82);
			destroyedRight.addAnimation("reefed", [0, 1, 2, 3, 4, 5, 6, 7], 3, false);
			destroyedRight.addAnimation("unreefed", [8, 9, 10, 11, 12, 13, 14, 15], 3, false);
			destroyedRight.velocity.x = 8;
			destroyedRight.velocity.y = 2;
			
			destroyedMiddle.loadGraphic(ImgDestroyedMiddle, true, false, 32, 62);
			destroyedMiddle.addAnimation("reefed", [0, 1, 2, 2, 1, 0], 3, false);
			destroyedMiddle.addAnimation("unreefed", [3, 4, 5, 5, 5, 4, 4, 4, 3], 3, false);
			destroyedMiddle.velocity.y = 10;
			destroyedMiddle.exists = false;
			
			destroyedLeft.loadGraphic(ImgDestroyedLeft, true, false, 72, 70);
			destroyedLeft.addAnimation("unreefed", [0, 1, 2, 3, 4, 5, 6, 7], 3, false);
			destroyedLeft.addAnimation("reefed", [8, 9, 10, 11, 12, 13, 14, 15], 3, false);
			destroyedLeft.velocity.x = -5;
			destroyedLeft.velocity.y = 2;
			destroyedLeft.exists = false;
			
			bubbles.setXSpeed(-50, 50);
			bubbles.setYSpeed(0, 0);
			bubbles.gravity = 0;
			bubbles.setRotation(0, 0);
			bubbles.setSize(120, 1);
			var bubble:FlxSprite;
			var bubbleAnims:Array = ["one", "two", "three", "four"];
			for (i = 0; i < 20; i++)
			{ // Each of the individual bubble sprites
				bubble = new FlxSprite(480, 0);
				bubble.loadGraphic(ImgBubbles, true, false, 24, 12);
				bubble.addAnimation("one", [0, 1, 2, 3, 4], 10, true);
				bubble.addAnimation("two", [2, 3, 4, 0, 1], 10, true);
				bubble.addAnimation("three", [4, 3, 2, 1, 0], 10, true);
				bubble.addAnimation("four", [2, 1, 0, 4, 3], 10, true);
				bubble.play(bubbleAnims[Math.round(Math.random() * 4)]);
				bubbles.add(bubble);
			}
			bubbles.kill();
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			super.update();
			frontSails.update();
			frontSails.x = x + 26;
			frontSails.y = y + 25;
			midSails.update();
			midSails.x = x + 50;
			midSails.y = y + 19;
			backSails.update();
			backSails.x = x + 75;
			backSails.y = y + 24;
			bigFlag.update();
			bigFlag.x = x + 63;
			bigFlag.y = y + 3;
			smallFlag.update();
			smallFlag.x = x + 101;
			smallFlag.y = y + 35;
			
			switch (state)
			{
				case "arriving":
					if (timer > 0.5)
					{ // Bob the ship up and down
						y = 79 + offsetFrames[currentOffset++]; // Change the offset
						if (currentOffset > 4) currentOffset = 0; // Reset the counter
						timer = 0;
					}
					if (x < 380)
					{ // Start slowing down
						velocity.x = -5;
						frontSails.play("idle-slow");
						midSails.play("idle-slow");
						backSails.play("idle-slow");
						bigFlag.play("idle-slow");
						smallFlag.play("idle-slow");
					}
					if (x < 365) velocity.x = -3; // al...most... there...
					if (x < 350) // They have landed!
						land();
				break;
				case "landed":
					if (x < 345)
					{ // Stop the ship
						velocity.x = 0;
					}
					if ((timer > 3) && (piratesLeft > 0))
					{
						var pirate:Pirate = pirates.getFirstAvail() as Pirate;
						pirate.x = 340;
						pirate.velocity.x = -15;
						pirate.facing = LEFT;
						pirate.anim = "walk";
						pirate.exists = true;
						timer = 0;
						piratesLeft--;
					}
					if (pirates.countDead() == 5)
						leave();
				break;
				case "leaving":
					if (timer > 0.5)
					{ // Bob the ship up and down
						y = 79 + offsetFrames[currentOffset++]; // Change the offset
						if (currentOffset > 4) currentOffset = 0; // Reset the counter
						timer = 0;
					}
					if (x < 300)
						velocity.x = -15;
					if (x < 200)
						velocity.x = -20;
					if (x < -117)
						exists = false;
				break;
				case "destroyed":
					destroyedLeft.update();
					destroyedMiddle.update();
					destroyedRight.update();
					bubbles.update();
					if (timer > 6)
						bubbles.velocity.y = 3;
					if (timer > 8)
						bubbles.kill();
					if (timer > 30)
					{
						visible = false;
						timer = 0;
						//FlxG.playMusic(Assets.SndMusicMain, 0.3);
					}
					if (timer > 60)
					{
						exists = false;
						Assets.canPiratesCome = true;
					}
				break;
			}
		}
		
		/**
		 * The ship is damaged
		 * @param	Damage	How much damage
		 */
		override public function hurt(Damage:Number):void
		{
			// TODO: add debris flying out
			super.hurt(Damage);
		}
		
		/**
		 * The ship is destroyed
		 */
		override public function kill():void
		{
			FlxG.play(SndDestroy);
			state = "destroyed";
			timer = 0;

			destroyedRight.x = x + 34;
			destroyedRight.y = y + 15;
			destroyedRight.exists = true;
			destroyedRight.play(reefed?"unreefed":"reefed");
			
			destroyedMiddle.x = x + 50;
			destroyedMiddle.y = y + 3;
			destroyedMiddle.exists = true;
			destroyedMiddle.play(reefed?"unreefed":"reefed");
			
			destroyedLeft.x = x + 7;
			destroyedLeft.y = y + 17;
			destroyedLeft.exists = true;
			destroyedLeft.play(reefed?"unreefed":"reefed");
			
			bubbles.x = x;
			bubbles.y = y + 75;
			bubbles.start(false, 0.03);
		}
		
		/**
		 * Since we break the sprite up into multiple parts, we need to render each of them
		 */
		override public function render():void
		{
			if (state == "destroyed")
			{
				destroyedLeft.render();
				destroyedMiddle.render();
				destroyedRight.render();
				bubbles.render();
			}
			else
			{
				super.render();
				frontSails.render();
				midSails.render();
				backSails.render();
				bigFlag.render();
				smallFlag.render();
			}
		}
		
		/**
		 * Create a new pirate ship
		 */
		public function spawn():void
		{
			if (exists == true) // There's already a pirate ship on screen
				return;
			FlxG.playMusic(SndMusicPirates, 0.3);
			x = 480;
			y = 79;
			state = "arriving";
			exists = true;
			timer = 0;
			Assets.canPiratesCome = false;
			update();
		}
		
		/**
		 * The ship has come to shore
		 */
		public function land():void
		{
			state = "landed";
			//velocity.x = 0;
			reefed = true;
			timer = 0;
			FlxG.play(SndLand);
		}
		
		/**
		 * The ship is leaving shore
		 */
		public function leave():void
		{
			state = "leaving";
			velocity.x = -10;
			reefed = false;
			Assets.canPiratesCome = false;
			FlxG.playMusic(Assets.SndMusicMain, 0.3);
		}
		
		/**
		 * Put the sails up or down
		 */
		public function set reefed(Reefed:Boolean):void
		{
			_reefed = Reefed;
			if (Reefed)
			{
				frontSails.play("up");
				midSails.play("up");
				backSails.play("up");
			}
			else
			{
				frontSails.play("down");
				midSails.play("down");
				backSails.play("down");
			}
		}
		
		/**
		 * Find out if the sails are up or down
		 */
		public function get reefed():Boolean
		{
			return _reefed;
		}
	}
}