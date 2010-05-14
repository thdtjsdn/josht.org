////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010 Josh Tynjala
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to 
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
//
//  Contains modified third-party source code released under the following
//  license terms:
//
//  [Functions are] free to use as you see fit. They are free of charge or
//  obligation. I have endeavored to make these methods robust and useful,
//  however I can make no guarantees about their suitability to your specific
//  needs. I similarly make no guarantees that they are bug or problem free:
//  caveat emptor. 
//
//  Author: Ric Ewing (ric@formequalsfunction.com) with thanks to Robert Penner,
//  Eric Mueller and Michael Hurwicz for their contributions.
//
//  Source: http://www.adobe.com/devnet/flash/articles/adv_draw_methods.html
//
////////////////////////////////////////////////////////////////////////////////

package org.josht.utils.graphics
{
	import flash.display.Graphics;

	/**
	 * Draws a regular polygon with the specified number of sides. Negative
	 * values for sideCount will draw the polygon in the reverse direction,
	 * which allows for creating knock-outs in masks.
	 * 
	 * @param target		The Graphics object to which to draw.
	 * @param centerX		x component of the polygon's center point.
	 * @param centerY		y component of the polygon's center point.
	 * @param sideCount		The number of sides on the polygon, must be greater than two.
	 * @param radius		The radius of the points of the polygon from the center.
	 * @param startDegrees	The starting angle from which to draw, in degrees.
	 */
	public function drawPolygon(target:Graphics, centerX:Number, centerY:Number, sideCount:int, radius:Number, startDegrees:Number = 0):void
	{
		// convert sides to positive value
		var count:int = Math.abs(sideCount);
		
		// check that count is sufficient to build polygon
		if(count <= 2)
		{
			throw new ArgumentError("Cannot draw a polygon with fewer than three sides.");
		}
		
		// calculate span of sides
		var step:Number = (Math.PI * 2) / sideCount;
		
		// calculate starting angle in radians
		var startDegrees:Number = (startDegrees / 180) * Math.PI;
		
		var startX:Number = centerX + (Math.cos(startDegrees) * radius);
		var startY:Number = centerY - (Math.sin(startDegrees) * radius);
		target.moveTo(startX, startY);
		
		// draw the polygon
		for(var i:int = 1; i <= count; i++)
		{
			var currentX:Number = centerX + Math.cos(startDegrees + (step * i)) * radius;
			var currentY:Number = centerY - Math.sin(startDegrees + (step * i)) * radius;
			target.lineTo(currentX, currentY);
		}
	}
}