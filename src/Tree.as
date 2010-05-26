package
{
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Tree extends FlxSprite
	{
		[Embed(source = "data/tree-palm.png")] private var ImgTree:Class;
		
		private var timer:Number = 0;
		private var coconutTimer:Number = 0;
		public var growing:Boolean = true; // Is the tree growing?
		public var percher:Boolean = false; // Is there a monkey in the tree?
		public var numberOfCoconuts:int = 5; // The number of coconuts in the tree
		public var canThrowCoconuts:Boolean = true; // Can the monkey throw a coconut right now?
		
		public function Tree()
		{
			super(0, 0);
			loadGraphic(ImgTree, true, true, 18, 25);
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
			play("idle");
			
			velocity.y = 100;
			acceleration.y = 10;
			health = 1;
			exists = false;
			dead = true;
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			coconutTimer += FlxG.elapsed;
			super.update();
			
			if ((health < 100) && !Assets.rainEmitter.dead)
			{ // This tree is getting some much needed water
				if (timer > 1)
				{ // Replenish the tree's health
					health += 4;
					timer = 0;
					if (growing) // If this tree is still growing
					{
						frame = _curFrame++;
						if (frame >= 22)
						{
							growing = false;
							Assets.numberOfGrownTrees++;
						}
					}
				}
			}
			
			if ((velocity.y > 0) && Assets.ground.hitTest(new Point(0, 0), 255, new Point(x, y + 25)) || (y > 134))
			{ // The tree has hit solid ground
				velocity.y = acceleration.y = 0;
				if (y > 134)
				{ // Somehow got too low
					y = 134;
					velocity.y = acceleration.y = 0;
				}
			}
			
			if (coconutTimer > 2)
			{
				canThrowCoconuts = true;
				coconutTimer = 0;
			}
		}
		
		/**
		 * This tree has died
		 */
		override public function kill():void
		{
			super.kill();
		}
	}
}