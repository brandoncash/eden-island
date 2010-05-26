package
{
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Bush extends FlxSprite
	{
		[Embed(source = "data/bush.png")] private var ImgBush:Class;
		
		private var timer:Number = 0;
		public var growing:Boolean = true; // Is the bush growing?
		public var numberOfBerries:int = 5; // The number of berries in the bush
		
		public function Bush()
		{
			super(0, 0);
			loadGraphic(ImgBush, true, true, 8, 5);
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7]);
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
			super.update();
			
			if ((health < 100) && !Assets.rainEmitter.dead)
			{ // This bush is getting some much needed water
				if (timer > 1)
				{ // Replenish the bush's health
					health += 10;
					timer = 0;
					if (growing) // If this bush is still growing
					{
						frame = _curFrame++;
						if (frame >= 8)
						{
							growing = false;
							Assets.numberOfGrownBushes++;
						}
					}
				}
			}
			
			if ((velocity.y > 0) && Assets.ground.hitTest(new Point(0, 0), 255, new Point(x, y + 5)) || (y > 154))
			{ // The bush has hit solid ground
				dead = false;
				velocity.y = acceleration.y = 0;
				if (y > 154)
				{ // Somehow got too low
					y = 154;
					velocity.y = acceleration.y = 0;
				}
			}
			
		}
		
		/**
		 * This bush has died
		 */
		override public function kill():void
		{
			super.kill();
		}
	}
}