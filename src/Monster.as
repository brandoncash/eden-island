package
{
	import org.flixel.*;
	
	public class Monster extends FlxSprite
	{
		[Embed(source = "data/monster-head.png")] private var ImgHead:Class;
		[Embed(source = "data/monster-tentacle.png")] private var ImgTentacle:Class;
		[Embed(source = "data/sfx/sea monster emerge.mp3")] private var SndEmerge:Class;
		[Embed(source = "data/sfx/cluclu.mp3")] private var SndMusic:Class;
		
		private var timer:Number = 0;
		private var bobTimer:Number = 0;
		private var offsetFrames:Array = [0, 1, 2, 1, 0];
		private var currentOffset:int = 0;
		private var out:Boolean = false;
		
		public function Monster()
		{
			super(15, 161);
			loadGraphic(ImgHead, true, true, 59, 38);
			velocity.y = -10;
			exists = false;
			
			addAnimation("idle", [0, 1, 2], 2, true);
			play("idle");
			
			//var tentacle:FlxSprite = new FlxSprite();
			//tentacle.exists = false;
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			bobTimer += FlxG.elapsed;
			
			if (out && (bobTimer > 0.5))
			{ // Bob the monster up and down
				y = 123 + offsetFrames[currentOffset++]; // Change the offset
				if (currentOffset > 4) currentOffset = 0; // Reset the counter
				bobTimer = 0;
			}
			
			if (y < 123)
			{
				out = true;
				velocity.y = acceleration.y = 0;
				FlxG.play(SndEmerge);
				//FlxG.playMusic(SndMusic); // Music will be moved to Assets
				Assets.pirateShip.kill();
			}
			
			if (timer > 15)
			{ // Start going back into the water
				velocity.y = 10;
				out = false;
			}
			if (timer > 30)
			{ // Get rid of the monster
				exists = false;
				timer = 0;
				y = 161;
				velocity.y = -10;
				//FlxG.playMusic(Assets.SndMusicMain, 0.3); // Music control will be moved to Assets.music or something
			}
			
			super.update();
		}

	}
}