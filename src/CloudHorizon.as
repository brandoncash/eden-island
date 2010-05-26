package
{
	import org.flixel.*;
	
	public class CloudHorizon extends FlxSprite
	{
		[Embed(source = "data/clouds-horizon.png")] private var ImgClouds:Class;
		
		private var anims:Array = ["one", "two", "three", "four"];
		
		public function CloudHorizon(X:Number, Frame:String="Random")
		{
			super(X, 140);
			loadGraphic(ImgClouds, false, false, 49, 12);
			velocity.x = Math.random() * 2;
			addAnimation("one",[0]);
			addAnimation("two", [2]);
			addAnimation("three", [4]);
			addAnimation("four", [6]);
			addAnimation("one-storm",[1]);
			addAnimation("two-storm", [3]);
			addAnimation("three-storm", [5]);
			addAnimation("four-storm", [7]);
			
			if (Frame == "Random")
				play(anims[Math.floor(Math.random() * 3)]); // Choose a random cloud
			else
				play(Frame);
		}
		
		override public function update():void
		{
			super.update();
			
			if (x > 480)
			{ // The cloud has scrolled by
				x = -60; // So recycle it
				acceleration.x =0
				velocity.x = Math.random() * (Assets.rainEmitter.dead?2:7);
				play(anims[Math.floor(Math.random() * 3)] + (Assets.rainEmitter.dead?'':'-storm')); // Choose a new cloud
			}
		}
	}
}