package
{
	import org.flixel.*;
	
	public class Pirate extends FlxSprite
	{
		[Embed(source = "data/pirates.png")] private var ImgPirates:Class;
		[Embed(source = "data/sfx/pirate-stab.mp3")] private var SndStab:Class;
		
		public var number:String = "one";
		private var numbers:Array = ["one", "two", "three", "four"];
		public var anim:String = "idle";
		private var timer:Number = 0;
		
		public function Pirate()
		{
			super(0, 0);
			loadGraphic(ImgPirates, true, true, 12, 12);
			y = 147;
			
			addAnimation("one-idle", [0], 0, false);
			addAnimation("one-walk", [0, 1], 5, true);
			addAnimation("one-stab", [2, 3, 4, 3, 2], 5, false);
			addAnimation("one-die", [5, 6, 7], 5, false);
			addAnimation("one-decompose", [7, 8, 9], 0.1, false);
			
			addAnimation("two-idle", [10], 0, false);
			addAnimation("two-walk", [10, 11], 5, true);
			addAnimation("two-stab", [12, 13, 14, 13, 12], 5, false);
			addAnimation("two-die", [15, 16, 17], 5, false);
			addAnimation("two-decompose", [17, 18, 19], 0.1, false);
			
			addAnimation("three-idle", [20], 0, false);
			addAnimation("three-walk", [20, 21], 5, true);
			addAnimation("three-stab", [22, 23, 24, 23, 22], 5, false);
			addAnimation("three-die", [25, 26, 27], 5, false);
			addAnimation("three-decompose", [27, 28, 29], 0.1, false);
			
			addAnimation("four-idle", [30], 0, false);
			addAnimation("four-walk", [30, 31], 5, true);
			addAnimation("four-stab", [32, 33, 34, 33, 32], 5, false);
			addAnimation("four-die", [35, 36, 37], 5, false);
			addAnimation("four-decompose", [37, 38, 39], 0.1, false);
			
			number = numbers[Math.round(Math.random() * 3)]; // Pick a random pirate
			exists = false;
			health = 100;
			Assets.humans.add(this);
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			play(number + "-" + anim);
			
			switch (anim)
			{
				case "walk":
					velocity.x = (facing == RIGHT)?15:-15;
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
					FlxU.overlap(this, Assets.monkeys, overlapMonkey);
				break;
				case "stab":
					velocity.x = acceleration.x = 0;
					if (timer > 1)
					{
						anim = "walk";
						timer = 0;
					}
				break;
				case "die": // If the pirate is dead
					if (timer > 2)
					{ // This pirate has been dead for 2 seconds
						anim = "decompose";
						timer = 0;
					}
				break;
				case "decompose":
					if (timer > 10)
					{ // This pirate has rotted enough, let's get rid of him
						dead = true;
						timer = 0;
					}
				break;
			}
			
			super.update();
		}
		
		/**
		 * This pirate is dead
		 */
		override public function kill():void
		{
			velocity.x = acceleration.x = 0;
			anim = "die";
		}
		
		/**
		 * The pirate walked past a tree, so check if a monkey wants to throw coconuts at him
		 * @param	pirate	The pirate
		 * @param	tree	The tree
		 * @return
		 */
		public function overlapTree(pirate:Pirate, tree:Tree):Boolean
		{
			if (!tree.percher)
				return true;
			if (tree.numberOfCoconuts > 0)
			{
				if (tree.canThrowCoconuts)
				{
					Monkey.throwCoconut(tree.x + 9, tree.y + 3);
					tree.numberOfCoconuts--;
					tree.canThrowCoconuts = false;
					pirate.hurt(50);
				}
			}
			return true;
		}
		
		/**
		 * The pirate enters into a death battle with a monkey
		 * @param	pirate	The pirate
		 * @param	monkey	The monkey
		 * @return
		 */
		public function overlapMonkey(pirate:Pirate, monkey:Monkey):Boolean
		{
			if (monkey.dead || (monkey.anim == "die"))
				return true;
			FlxG.play(SndStab);
			pirate.anim = "stab";
			monkey.kill();
			monkey.velocity.x = monkey.acceleration.x = 0;
			return true;
		}
	}
}