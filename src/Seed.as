package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Seed extends FlxSprite
	{
		[Embed(source = "data/sfx/sand.mp3")] private var SndSand:Class;
		
		private var colors:Array = [0xff82a364, 0xffa4d17b, 0xff6d8656, 0xff547236, 0xff99c270];
		
		public function Seed()
		{
			super(0, 0);
			createGraphic(1, 1, 0xff99c270);
			exists = false;
		}
		
		public function spawn(X:int, Y:int):void
		{
			x = X;
			y = Y;
			velocity.x = (Math.random() * 10) - 5; // Randomize X spread
			velocity.y = 75; // Fixed Y starting speed
			acceleration.y = 10;
			exists = true;
		}
		
		override public function update():void
		{
			super.update();
			if (y > 158) y = 158; // Fix in case the particle travelled past the boundary
			if ((x < 90) || (x > 390)) exists = false; // This particle is out of bounds
			
			if (Assets.ground.hitTest(new Point(0, 0), 255, new Point(x, y + 1)))
			{ // A particle comes to rest
				if (Assets.ground.hitTest(new Point(0, 0), 255, new Point(x - 1, y + 1)) && Assets.ground.hitTest(new Point(0, 0), 255, new Point(x + 1, y + 1)))
				{ // Test if it's too tall of a hill
					FlxG.play(SndSand, 0.2);
					Assets.ground.setPixel32(x, y, colors[int(Math.random() * 4)]);
					//Assets.sandParticlesUsed++;
					exists = false;
				}
			}
		}
	}
}