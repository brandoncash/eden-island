package
{
	import org.flixel.*;
	
	public class Monkey extends FlxSprite
	{
		[Embed(source = "data/monkey.png")] private var ImgPirates:Class;
		[Embed(source = "data/sfx/coconut.mp3")] static private var SndCoconut:Class;
		
		public var anim:String = "panic";
		private var timer:Number = 0;
		
		public function Monkey()
		{
			super(0, 0);
			loadGraphic(ImgPirates, true, true, 8, 8);
			
			addAnimation("idle", [6], 0, false);
			addAnimation("walk", [0, 1], 5, true);
			addAnimation("panic", [2, 3], 5, true);
			addAnimation("climb", [4, 5], 5, true);
			addAnimation("perched", [4]);
			addAnimation("die", [6, 7, 8, 9, 10, 11], 5, false);
			
			velocity.y = acceleration.y = 30;
			acceleration.x = 0;
			exists = false;
			dead = true;
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			play(anim);
			
			switch (anim)
			{
				case "walk":
					if (x < 90)
					{
						velocity.x = 15;
						facing = RIGHT;
					}
					if (x > 380)
					{
						velocity.x = -15;
						facing = LEFT;
					}
					FlxU.overlap(this, Assets.trees, overlapTree);
				break;
				case "panic":
					if (timer > 2)
					{
						anim = "walk";
						timer = 0;
					}
				break;
				case "climb":
					FlxU.overlap(this, Assets.trees, overlapTree);
				break;
				case "perched":
					// TODO: throw coconuts
				break;
				case "die":
					if (timer > 10)
					{ // This monkey has been dead for 10 seconds or more
						dead = true; // Time to dispose of the body
						timer = 0;
					}
				break;
			}
			
			if (y > 151)
			{ // The monkey hit the island
				if (velocity.y > 50)
				{ // Monkey goes splat
					//Assets.numberOfMonkeysLeft++;
					anim = "die";
				}
				else
				{ // Set the monkey to start walking
					anim = "walk";
					facing = RIGHT;
					velocity.x = 15;
				}
				y = 151;
				velocity.y = acceleration.y = 0;
			}
			
			super.update();
		}
		
		/**
		 * This monkey's gone to heaven
		 */
		override public function kill():void
		{
			anim = "die";
		}
		
		/**
		 * Monkey overlappin' a tree
		 * @param	monkey	The monkey
		 * @param	tree	The tree
		 */
		public function overlapTree(monkey:Monkey, tree:Tree):Boolean
		{
			if (!tree.growing && !tree.percher)
			{ // If there is no monkey in this tree
				if (((monkey.facing == RIGHT) && (int(monkey.x) == tree.x + 1)) || ((monkey.facing == LEFT) && (int(monkey.x) == tree.x + 10)))
				{ // Start climbing
					anim = "climb";
					monkey.velocity.y = -3;
					monkey.velocity.x = monkey.acceleration.x = 0;
					tree.percher = true;
				}
			}
			if (monkey.y < (tree.y + 5))
			{ // The monkey has reached the top of the tree
				monkey.anim = "perched";
				monkey.velocity.y = 0;
			}
			return true;
		}
		
		/**
		 * A monkey in a tree throwing a coconut
		 */
		public static function throwCoconut(X:Number, Y:Number):void
		{
			var coconut:FlxSprite = new FlxSprite(X, Y);
			coconut.createGraphic(2, 2, 0xff583d16);
			coconut.velocity.y = 30;
			coconut.velocity.x = Math.random() * 10 - 5;
			FlxG.state.add(coconut);
			FlxG.play(SndCoconut);
		}
	}
}