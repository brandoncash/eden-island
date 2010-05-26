package
{
	import org.flixel.*;
	
	public class Button extends FlxSprite
	{
		[Embed(source = "data/buttons.png")] private var ImgButtons:Class;
		
		public function Button(Anim:String)
		{
			super(0, 0);
			loadGraphic(ImgButtons, false, false, 14, 14);
			addAnimation("sand", [0]);
			addAnimation("sand-pushed", [1]);
			addAnimation("plants", [2]);
			addAnimation("plants-pushed", [3]);
			addAnimation("monkey", [4]);
			addAnimation("monkey-pushed", [5]);
			addAnimation("rain", [6]);
			addAnimation("rain-pushed", [7]);
			addAnimation("earthquake", [8]);
			addAnimation("earthquake-pushed", [9]);
			addAnimation("another", [10]);
			addAnimation("another-pushed", [11]);
			addAnimation("help", [12]);
			addAnimation("help-pushed", [13]);
			addAnimation("about", [14]);
			addAnimation("about-pushed", [15]);
			addAnimation("sound", [16]);
			addAnimation("sound-pushed", [17]);
			
			play(Anim);
		}
		
		override public function update():void
		{
		}
		
	}
}