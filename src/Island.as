package
{
	import flash.events.Event;
	import org.flixel.*;
	[SWF(width="960", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Island extends FlxGame
	{
		
		public function Island()
		{
			super(480, 240, PlayState, 2);
			useDefaultHotKeys = false;
			pause = new Pause;
		}
		
		override protected function update(event:Event):void
		{
			super.update(event);
			if (FlxG.keys.justPressed("ZERO") || FlxG.keys.justPressed("NUMPADZERO"))
				(FlxG.state as PlayState).toggleSound();
			if (FlxG.keys.justPressed("MINUS") || FlxG.keys.justPressed("NUMPADMINUS"))
			{
				FlxG.volume -= 0.1;
				Assets.updateSound();
			}
			if (FlxG.keys.justPressed("PLUS") || FlxG.keys.justPressed("NUMPADPLUS"))
			{
				FlxG.volume += 0.1;
				Assets.updateSound();
			}
			if (FlxG.keys.justPressed("P"))
				FlxG.pause = !FlxG.pause;
		}

	}
}
