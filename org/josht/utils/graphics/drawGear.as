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
	 * Draws a gear, a cog with teeth and a hole in the middle where an axle
	 * may be placed.
	 * 
	 * @param target		The Graphics object to which to draw.
	 * @param centerX		x component of the gear's center point.
	 * @param centerY		y component of the gear's center point.
	 * @param sideCount		The number of "teeth" on the gear, must be greater than two.
	 * @param innerRadius	The radius of the indent of the points from the center.
	 * @param outerRadius	The radius of the tips of the points from the center.
	 * @param startDegrees	The starting angle from which to draw, in degrees.
	 * @param holeSides		The number of sides to the polygonal hole in the middle of the gear. Must be greater than two.
	 */
	public function drawGear(target:Graphics, centerX:Number, centerY:Number, sideCount:int, innerRadius:Number, outerRadius:Number, startDegrees:Number, holeSideCount:int = 0, holeRadius:Number = NaN):void
	{
		if(sideCount <= 2)
		{
			throw new ArgumentError("Cannot draw a gear with fewer than three teeth.");
		}
		
		// calculate length of sides
		var step:Number = (2 * Math.PI) / sideCount;
		var quarterStep:Number = step / 4;
		
		// calculate starting angle in radians
		var startRadians:Number = startDegrees / 180 * Math.PI;
		
		var startX:Number = centerX + (Math.cos(startRadians) * outerRadius);
		var startY:Number = centerY - (Math.sin(startRadians) * outerRadius); 
		target.moveTo(startX, startY);
		
		// draw lines
		for(var i:int = 1; i <= sideCount; i++)
		{
			var currentX:Number = centerX + Math.cos(startRadians + (step * i) - (quarterStep * 3)) * innerRadius;
			var currentY:Number = centerY - Math.sin(startRadians + (step * i) - (quarterStep * 3)) * innerRadius;
			target.lineTo(currentX, currentY);
			
			currentX = centerX + Math.cos(startRadians + (step * i) - (quarterStep * 2)) * innerRadius;
			currentY = centerY - Math.sin(startRadians + (step * i) - (quarterStep * 2)) * innerRadius;
			target.lineTo(currentX, currentY);
			
			currentX = centerX + Math.cos(startRadians + (step * i) - quarterStep) * outerRadius;
			currentY = centerY - Math.sin(startRadians + (step * i) - quarterStep) * outerRadius;
			target.lineTo(currentX, currentY);
			
			currentX = centerX + Math.cos(startRadians + (step * i)) * outerRadius;
			currentY = centerY - Math.sin(startRadians + (step * i)) * outerRadius;
			target.lineTo(currentX, currentY);
		}
		
		if(holeSideCount > 2)
		{
			if(isNaN(holeRadius))
			{
				holeRadius = innerRadius / 3;
			}
			
			drawPolygon(target, centerX, centerY, holeSideCount, holeRadius, startDegrees);
		}
	}
}