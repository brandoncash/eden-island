package
{
	import org.flixel.*;
	
	public class Cloud extends FlxSprite
	{
		[Embed(source = "data/clouds-big.png")] private var ImgClouds:Class;
		
		private var anims:Array = ["one", "two", "three"];
		
		public function Cloud(X:Number, Y:Number, Frame:String="Random")
		{
			super(X, Y);
			loadGraphic(ImgClouds, false, false, 76, 39);
			velocity.x = Math.random() * 5 + 2;
			addAnimation("one",[0]);
			addAnimation("two", [2]);
			addAnimation("three", [4]);
			addAnimation("one-storm",[1]);
			addAnimation("two-storm", [3]);
			addAnimation("three-storm", [5]);
			
			if (Frame == "Random")
				play(anims[Math.floor(Math.random() * 2)]); // Choose a random cloud
			else
				play(Frame);
		}
		
		override public function update():void
		{
			super.update();
			
			if (x > 480)
			{ // The cloud has scrolled by
				x = -100; // So recycle it
				y = Math.random() * 65 + 20;
				acceleration.x = Assets.rainEmitter.dead?0:3;
				velocity.x = Math.random() * (Assets.rainEmitter.dead?5:15) + 2;
				play(anims[Math.floor(Math.random() * 2)] + (Assets.rainEmitter.dead?'':'-storm')); // Choose a new cloud
			}
		}
	}
}