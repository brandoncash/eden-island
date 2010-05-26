package org.flixel
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * This is a text display class which uses bitmap fonts.
	 */
	public class FlxBitmapFont
	{
		[Embed(source = "data/font.png")] private var imgDefaultFont:Class;
		
		/**
		 * The bounding boxes of each character
		 */
		public var rects:Array;
		/**
		 * The amount of space between characters in pixels
		 */
		public var horizontalPadding:uint;
		/**
		 * The amount of space between lines in pixels
		 */
		public var verticalPadding:uint;
		/**
		 * The bitmap onto which the font is loaded
		 */
		public var pixels:BitmapData;
		/**
		 * The height of the font in pixels
		 */
		public var height:uint;
		/**
		 * The alphabet represented by this font.
		 */
		private var _alphabet:String;

		
		/**
		 * Sets the font face to use.
		 * 
		 * @param	Image				The font image to use
		 * @param	Height				The height of the font in pixels
		 * @param	HorizontalPadding	Padding between characters in pixels
		 * @param	VerticalPadding		Padding between lines in pixels
		 * @param	Alphabet			The alphabet represented by this font
		 */
		public function FlxBitmapFont(Image:Class=null, Height:uint=5, HorizontalPadding:uint=1, VerticalPadding:uint=5, Alphabet:String=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
		{
			if (Image == null)
				Image = imgDefaultFont;
			pixels = FlxG.addBitmap(Image);
			height = Height;
			verticalPadding = VerticalPadding;
			horizontalPadding = HorizontalPadding;
			_alphabet = Alphabet;
			rects = new Array(); // Clear the rectangles array
			var _delimiter:uint = pixels.getPixel(0, 0); // The pixel which marks the end of a character
			var yOffset:uint = 1; // Skip the first line since it just marks the delimiters
			var xOffset:uint = 0;
			var currentChar:Number = 0;
			for (var y:uint = 0; y < int(pixels.height / height); y++)
			{ // Each line in the font bitmap
				for (var x:uint = 0; x < pixels.width; x++)
				{ // Each pixel in on the X axis
				if (pixels.getPixel(x, yOffset - 1) == _delimiter)
					{ // Is this the end of a character?
						rects[_alphabet.charCodeAt(currentChar - 1)] = new Rectangle(xOffset, yOffset, x - xOffset, height); // The bounding box of the character
						currentChar++;
						xOffset = x + 1; // Set the offset to the start of the next character
					}
					if (currentChar > _alphabet.length) // There are no more characters
						return; // So don't waste time trying to add them
				}
				yOffset += height + 1;
				xOffset = 0;
			}
		}

	}
}
