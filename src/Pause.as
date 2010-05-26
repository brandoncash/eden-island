package
{
	import org.flixel.*;

	/**
	 * This is displayed when the game is paused.
	 */
	public class Pause extends FlxGroup
	{
		public function Pause()
		{
			super();
			var pausedText:FlxBitmapText = new FlxBitmapText(0, 180, Assets.fontSmall, "PAUSED", "center", FlxG.width);
			pausedText.color = 0xffffff;
			add(pausedText);
		}
	}
}