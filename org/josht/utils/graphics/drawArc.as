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
//  Contains third-party source code released with the same license terms
//  that appear above with the following copyright notice:
//
//  Copyright (c) 2008 nicolas levavasseur (nicolas.levavasseur@gmail.com)
//
//  Source: http://code.google.com/p/beziercurve/
//
////////////////////////////////////////////////////////////////////////////////

package org.josht.utils.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * Draws a regular or elliptical arc segment.
	 * 
	 * @param target		The Graphics object to which to draw
	 * @param centerX		x component of the arc's center point
	 * @param centerY		y component of the arc's center point
	 * @param startDegrees	Starting angle, in degrees.
	 * @param arc			Sweep of the arc. Negative values draw clockwise.
	 * @param radius		Radius of the arc. If the optional yRadius is defined, then radius is the x-axis radius.
	 * @param yRadius		Y-axis radius for arc.
	 */
	public function drawArc(target:Graphics, centerX:Number, centerY:Number, startDegrees:Number, arcDegrees:Number, radius:Number, yRadius:Number = -1):Point
	{
		if(yRadius < 0)
		{
			yRadius = radius;
		}
		
		// no sense in drawing more than is needed :)
		if(Math.abs(arcDegrees) > 360)
		{
			arcDegrees = 360;
		}
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		var segmentCount:int = Math.ceil(Math.abs(arcDegrees) / 45);
		
		// Now calculate the sweep of each segment
		// The math requires radians rather than degrees.
		var theta:Number = (arcDegrees / segmentCount) * Math.PI / 180;
		
		// convert angle startAngle to radians
		var currentAngle:Number = startDegrees * Math.PI / 180;
		
		// find our starting points (ax,ay) relative to the secified x,y
		var startX:Number = centerX + Math.cos(currentAngle) * radius;
		var startY:Number = centerY - Math.sin(currentAngle) * yRadius;
		
		target.moveTo(startX, startY);
		
		// if our arc is larger than 45 degrees, draw as 45 degree segments
		// so that we match Flash's native circle routines.
		if(segmentCount > 0)
		{
			// Loop for drawing arc segments
			for(var i:int = 0; i < segmentCount; i++)
			{
				// increment our angle
				currentAngle += theta;
				
				// find the angle halfway between the last angle and the new
				var angleMid:Number = currentAngle - (theta / 2);
				
				// calculate our end point
				var endX:Number = centerX + Math.cos(currentAngle) * radius;
				var endY:Number = centerY - Math.sin(currentAngle) * yRadius;
				
				// calculate our control point
				var controlX:Number = centerX + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
				var controlY:Number = centerY - Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
				
				// draw the arc segment
				target.curveTo(controlX, controlY, endX, endY);
			}
		}
		// In the native draw methods the user must specify the end point
		// which means that they always know where they are ending at, but
		// here the endpoint is unknown unless the user calculates it on their 
		// own. Lets be nice and let save them the hassle by passing it back. 
		return new Point(endX, endY);
	}
}