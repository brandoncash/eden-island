package org.flixel
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	/**
	 * This is a text display class which uses bitmap fonts.
	 */
	public class FlxBitmapText extends FlxObject
	{
		/**
		 * The bitmap onto which the text is rendered
		 */
		protected var _pixels:BitmapData;
		/**
		 * The coordinates to which several things are copied
		 */
		protected var _p:Point;
		/**
		 * The bounding box of the internal bitmap
		 */
		protected var _frect:Rectangle;
		/**
		 * This is used to change the color of the bitmap
		 */
		protected var _cTransform:ColorTransform = new ColorTransform;
		/**
		 * The bitmap font to use
		 */
		protected var _font:FlxBitmapFont;
		/**
		 * The text to render
		 */
		protected var _text:String;
		/**
		 * The text alignment
		 */
		protected var _alignment:String;
		/**
		 * The default font to use
		 */
		static protected var _defaultFont:FlxBitmapFont;
		
		
		/**
		 * Creates a new <code>FlxBitmapText</code> object.
		 * 
		 * @param	X					The X position of the text
		 * @param	Y					The Y position of the text
		 * @param	Font				The bitmap font to use - NOTE: Passing null uses the default font
		 * @param	Text				The default text to display
		 * @param	Alignment			"Left", "Center", or "Right"
		 * @param	Width				The width of the text box in pixels (0 means auto)
		 */
		public function FlxBitmapText(X:int, Y:int, Font:FlxBitmapFont, Text:String=" ", Alignment:String="left", Width:Number=0)
		{
			if (Font == null) // Use the default font
				Font = _defaultFont ? _defaultFont : new FlxBitmapFont; // If it doesn't exist yet, create it
			_font = Font;
			_text = Text;
			_alignment = Alignment.toLowerCase();
			super();
			fixed = true;
			x = X;
			y = Y;
			width = Width;
			calcFrame();
		}
		
		/**
		 * Updates the internal bitmap.
		 */
		public function calcFrame():void
		{
			height = 0;
			var i:uint;
			var c:uint;
			var _lines:Array = _text.split("\n"); // An array of each line to render
			var _lineWidths:Array = new Array(); // An array of the widths of each line
			// We need to get the size of the bitmap, so we'll examine the text character-by-character
			for (i = 0; i < _lines.length; i++)
			{ // Loop through each line
				_lineWidths[i] = 0;
				for (c = 0; c < _lines[i].length; c++)
				{ // Each character in the line
					if (_font.rects[_lines[i].charCodeAt(c)])
					{ // Does the character exist in the font?
						_lineWidths[i] += _font.rects[_lines[i].charCodeAt(c)].width + _font.horizontalPadding; // Add its width to the line width
					}
				}
				if (_lineWidths[i] > width) // Find out which line is the widest
					width = _lineWidths[i]; // Use that line as the bitmap's width
				height += _font.height + _font.verticalPadding; // Set the height to the font height times the number of lines
			}
			width -= _font.horizontalPadding; // Don't apply horizontal padding to the last letter
			height -= _font.verticalPadding; // Don't apply vertical padding to the last line
			if ((width < 1) || (height < 1))
			{ // If there's nothing to render
				width = height = 1; // Set the width and height to 1px
			}
			_pixels = new BitmapData(width, height, true, 0x00000000); // Create a transparent bitmap
			var xOffset:uint;
			var yOffset:uint = 0;
			// Now we can start drawing on the bitmap
			for (i = 0; i < _lines.length; i++)
			{ // Loop through each line
				switch(_alignment)
				{ // Adjust where we start drawing for alignment
					case 'left':
						xOffset = 0;
					break;
					case 'center':
						xOffset = int((width - _lineWidths[i]) / 2);
					break;
					case 'right':
						xOffset = width - _lineWidths[i];
					break;
				}
				for (c = 0; c < _lines[i].length; c++)
				{ // Each character in the line
					if (_font.rects[_lines[i].charCodeAt(c)])
					{ // Make sure the character is in the font
						_p = new Point(xOffset, yOffset);
						_pixels.copyPixels(_font.pixels, _font.rects[_lines[i].charCodeAt(c)], _p, null, null, true); // Copy it to the bitmap
						xOffset += _font.rects[_lines[i].charCodeAt(c)].width + _font.horizontalPadding; // Add the width of the character
					}
				}
				yOffset += _font.height + _font.verticalPadding;
			}
			_frect = new Rectangle(0, 0, width, height); // The boundaries of the object
			_pixels.colorTransform(_frect, _cTransform); // Change the color if need be
		}
		
		/**
		 * Draws the text to the screen.
		 */
		override public function render():void
		{
			super.render();
			getScreenXY(_point);
			_p.x = _point.x;
			_p.y = _point.y;
			FlxG.buffer.copyPixels(_pixels, _frect, _p, null, null, true);
		}
		
		/**
		 * Changes the text being displayed.
		 * 
		 * @param	Text	The new string you want to display
		 */
		public function set text(Text:String):void
		{
			_text = Text;
			calcFrame(); // Update the bitmap
		}
		
		/**
		 * Getter to retrieve the text being displayed.
		 * 
		 * @return	The text string being displayed.
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Sets the alignment of the text being displayed
		 * 
		 * @param	A string indicating the desired alignment - acceptable values are "left", "right" and "center"
		 */
		public function set alignment(Alignment:String):void
		{
			_alignment = Alignment.toLowerCase(); // It's expecting the alignment to be all lowercase
			calcFrame(); // Update the bitmap
		}
		
		/**
		 * Gets the alignment of the text being displayed
		 * 
		 * @return	A string indicating the current alignment.
		 */
		public function get alignment():String
		{
			return _alignment;
		}
		
		/**
		 * Sets the color of the text
		 * 
		 * @param	Color	The color you want the text to appear (Note: it will become fully opaque!)
		 */
		public function set color(Color:uint):void
		{
			_cTransform.color = Color;
			calcFrame(); // Update the bitmap
		}
		
		/**
		 * Sets the font for the text
		 * 
		 * @param	Font	The font to use
		 */
		public function set font(Font:FlxBitmapFont):void
		{
			if (Font == null) // Do we want to use the default font?
				Font = _defaultFont ? _defaultFont : new FlxBitmapFont; // If it doesn't exist yet, create it
			_font = Font;
			calcFrame();
		}
		
		/**
		 * Get the font used
		 * 
		 * @return	FlxBitmapFont	The current font
		 */
		public function get font():FlxBitmapFont
		{
			return _font;
		}
	}
}