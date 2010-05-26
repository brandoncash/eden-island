package
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class Water
	{
		private var rect:Rectangle = new Rectangle(0, 0, 480, 160);
		private var point:Point = new Point(0, 160);
		private var zeroPoint:Point = new Point(0, 0);
		private var matrix:Matrix = new Matrix();
		private var transform:ColorTransform = new ColorTransform(1, 1, 1, 0.3);
		private var displacementFilter:DisplacementMapFilter;
		private var displacementBitmap:BitmapData = new BitmapData(480, 100, false, 0);
		private var displacementIteration:int = 0;
		private var reflection:BitmapData = new BitmapData(480, 160, true, 0xff004cd6);
		private var timer:Number = 0;
		
		public function Water()
		{
			// This flips the screen for the water reflection
			matrix.scale(1, -1);
			matrix.translate(0, 160);
			
			// This is the filter that makes the reflection ripple
			displacementFilter = new DisplacementMapFilter(displacementBitmap, zeroPoint, 1, 2, 10, 1);
			displacementBitmap.perlinNoise(20, 3, 1, 0, true, true, 7, true, [1, 1]);
		}
		
		public function update():void
		{
			timer += FlxG.elapsed;
			if (timer > 0.3)
			{ // Update the water ripple
				displacementIteration++;
				displacementBitmap.perlinNoise(20, 3, 1, displacementIteration, true, true, 7, true, [1, 1]);
				timer = 0;
			}
		}
		
		public function render():void
		{
			reflection.fillRect(rect, 0xff004cd6); // Clear the reflection
			reflection.draw(FlxG.buffer, matrix, transform); // Flip the screen and copy it to the reflection
			reflection.applyFilter(reflection, rect, zeroPoint, displacementFilter); // Apply the ripple filter
			FlxG.buffer.copyPixels(reflection, rect, point, null, null, true); // Copy it onto screen
		}
	}
}