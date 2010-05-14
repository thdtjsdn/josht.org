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
	 * @private
	 * Draws a pie slice-shaped wedge.
	 * 
	 * @param target		The Graphics object to which to draw
	 * @param centerX		x component of the wedge's center point
	 * @param centerY		y component of the wedge's center point
	 * @param startDegrees	Starting angle, in degrees
	 * @param arc			Sweep of the wedge. Negative values draw clockwise.
	 * @param radius		Radius of the wedge. If the optional yRadius is defined, then radius is the x-axis radius.
	 * @param yRadius		The y-axis radius for wedge.
	 */
	public function drawWedge(target:Graphics, centerX:Number, centerY:Number, startDegrees:Number, arc:Number, radius:Number, yRadius:Number = NaN):void
	{
		// move to x,y position
		target.moveTo(centerX, centerY);
		
		// if yRadius is undefined, yRadius = radius
		if(isNaN(yRadius))
		{
			yRadius = radius;
		}
		
		// limit sweep to reasonable numbers
		if(Math.abs(arc) > 360)
		{
			arc = 360;
		}
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		var segs:int = Math.ceil(Math.abs(arc) / 45);
		
		// Now calculate the sweep of each segment.
		var segAngle:Number = arc / segs;
		
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians.
		var theta:Number = -(segAngle / 180) * Math.PI;
		
		// convert angle startAngle to radians
		var angle:Number = -(startDegrees / 180) * Math.PI;
		
		// draw the curve in segments no larger than 45 degrees.
		if(segs > 0)
		{
			// draw a line from the center to the start of the curve
			var ax:Number = centerX + Math.cos(startDegrees / 180 * Math.PI) * radius;
			var ay:Number = centerY + Math.sin(-startDegrees / 180 * Math.PI) * yRadius;
			target.lineTo(ax, ay);
			
			// Loop for drawing curve segments
			for(var i:int = 0; i < segs; i++)
			{
				angle += theta;
				var angleMid:Number = angle - (theta / 2);
				var bx:Number = centerX + Math.cos(angle) * radius;
				var by:Number = centerY + Math.sin(angle) * yRadius;
				var cx:Number = centerX + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
				var cy:Number = centerY + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
				target.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center
			target.lineTo(centerX, centerY);
		}
	}
}