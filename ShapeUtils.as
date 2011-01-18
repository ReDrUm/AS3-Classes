/**
 * ShapeUtils by Tim Keir, Feb 04 2010 - http://www.timkeir.co.nz
 *
 * Copyright (c) 2009 Tim Keir
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.timkeir.utils
{
	import flash.display.Sprite;
	import flash.geom.Matrix; 
    import flash.display.GradientType;
	
	public class ShapeUtils
	{
		/**
		 * 	Set the depth of a DisplayObject to be placed at the top most level.
		 *
		 *	@param onTop A reference to the DisplayObject you wish to place at the top level
		 */
		public static function swapDepths(onTop:Object):void
		{
			onTop.parent.setChildIndex(onTop, onTop.parent.numChildren-1);
		}
		
		/**
		 * 	Creates a semi-opaque rectangular mask.
		 *
		 *	@param Width The desired width of the mask
		 *	@param Height The desired height of the mask
		 *
		 * @return The mask object as a sprite
		 */
		public static function makeMask(Width:Number, Height:Number):Sprite
		{
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x00FF00, 0.5);
			bg.graphics.drawRect(0, 0, Width, Height);
			bg.graphics.endFill();
			return bg;
		}
		
		/**
		 * 	Creates a rectangular Sprite.
		 *
		 *	@param Width The width of the mask
		 *	@param Height The height of the mask
		 *	@param Colour The colour of the mask
		 *	@param Alpha The alpha of the mask
		 *	@param BorderThickness The thickness of the border
		 *	@param BorderColour The colour of the border
		 *	@param BorderAlpha the alpha of the border
		 *
		 * @return The rectangular Sprite
		 */
		public static function makeRectangle(Width:Number, Height:Number, Colour:uint, Alpha:Number = 1, BorderThickness:Number = 0, BorderColour:uint = 0x000000, BorderAlpha:Number = 1):Sprite
		{
			var bg:Sprite = new Sprite();
			if(BorderThickness > 0) bg.graphics.lineStyle(BorderThickness, BorderColour, BorderAlpha);
			bg.graphics.beginFill(Colour, Alpha);
			bg.graphics.drawRect(0, 0, Width, Height);
			return bg;
		}
		
		/**
		 * 	Creates a rounded corner rectangular Sprite.
		 *
		 *	@param Width The width of the mask
		 *	@param Height The height of the mask
		 *	@param Radius The radius of the rectangles rounded corners
		 *	@param Colour The colour of the mask
		 *	@param Alpha The alpha of the mask
		 *	@param BorderThickness The thickness of the border
		 *	@param BorderColour The colour of the border
		 *	@param BorderAlpha the alpha of the border
		 *
		 * @return The rounded rectangular Sprite
		 */
		public static function makeRoundRectangle(Width:Number, Height:Number, Radius:Number, Colour:uint = 0x000000, Alpha:Number = 1, BorderThickness:Number = 0, BorderColour:uint = 0x000000, BorderAlpha:Number = 1):Sprite
		{
			var bg:Sprite = new Sprite();
			if(BorderThickness > 0) bg.graphics.lineStyle(BorderThickness, BorderColour, BorderAlpha);
			bg.graphics.beginFill(Colour, Alpha);
			bg.graphics.drawRoundRect(0, 0, Width, Height, Radius, Radius);
			bg.graphics.endFill();
			return bg;
		}
		
		/**
		 * 	Creates a gradient rectangular Sprite.
		 *
		 *	@param Width The width of the mask
		 *	@param Height The height of the mask
		 *	@param colours An array of the gradient colours e.g. [0xFFFFFF, 0x000000]
		 *	@param alphas An array of the alpha for each gradient colour e.g. [0, 100]
		 *	@param ratios An array of the colour spacing e.g. [0, 255]
		 *	@param type The type of gradient e.g. "radial" or "linear"
		 *	@param degress The angle of the gradient e.g. 0-359
		 *	@param tx The matrix translation X
		 *	@param ty The matrix translation Y
		 *
		 * @return The gradient rectangular Sprite
		 */
		public static function makeGradientRectangle(Width:Number, Height:Number, colours:Array, alphas:Array, ratios:Array, type:String = "linear", degrees:Number = 0, tx:Number = 0, ty:Number = 0):Sprite
		{
			var gradient:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			var radians = degrees * Math.PI / 180;
			trace("Radians: "+radians);
			matrix.createGradientBox(Width, Height, radians, tx, ty);
			gradient.graphics.beginGradientFill(type, colours, alphas, ratios, matrix, "pad", "RGB", 0);
			gradient.graphics.moveTo(0, 0);
			gradient.graphics.lineTo(Width, 0);
			gradient.graphics.lineTo(Width, Height);
			gradient.graphics.lineTo(0, Height);
			gradient.graphics.lineTo(0, 0);
			gradient.graphics.endFill();
			return gradient;
		}
	}
}