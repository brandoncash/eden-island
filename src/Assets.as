package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import org.flixel.*;
	
	public class Assets
	{
		[Embed(source = "data/klean-small.png")] static private var ImgFontSmall:Class;
		[Embed(source = "data/sfx/Intro.mp3")] static public var SndMusicMain:Class;
		
		public static var fontSmall:FlxBitmapFont = new FlxBitmapFont(ImgFontSmall, 9, 1, 1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:;,.<=>?@{|}¡abcdefghijklmnopqrstuvwxyz!\"#$%&'()*+-/\\[]^_`~ àáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ©®ß£€¥¢Æ");
		
		public static var musicState:String = "main";
		
		public static var ground:BitmapData;
		
		public static var canAddPlants:Boolean = false; // If the player has progressed to dropping bushes
		public static var canAddTrees:Boolean = false; // If the player has progressed to dropping trees
		public static var canWaterPlants:Boolean = false; // Can the player turn on the rain?
		public static var canAddMonkeys:Boolean = false; // Can the player add monkeys?
		public static var canAddMore:Boolean = false; // Add more stuff
		public static var canPiratesCome:Boolean = true; // Pirates!
		
		public static var sandParticlesUsed:int = 0;
		
		public static var numberOfGrownBushes:int = 0;
		public static var numberOfGrownTrees:int = 0;
		
		public static var rainEmitter:FlxEmitter = new FlxEmitter();
		//public static var quaking:Boolean = false;
		public static var bushes:FlxGroup = new FlxGroup();
		public static var trees:FlxGroup = new FlxGroup();
		public static var monkeys:FlxGroup = new FlxGroup();
		public static var humans:FlxGroup = new FlxGroup();
		
		public static var pirateShip:PirateShip;
		public static var monster:Monster;
		
		//static function set music(State:String):void
		// TODO: add music states
		
		public static function updateSound():void
		{
			var soundPrefs:FlxSave = new FlxSave();
			if(soundPrefs.bind("flixel"))
			{ // Save the sound preferences
				if(soundPrefs.data.sound == null)
					soundPrefs.data.sound = new Object;
				soundPrefs.data.mute = FlxG.mute;
				soundPrefs.data.volume = FlxG.volume;
				soundPrefs.forceSave();
			}
		}
	}
}