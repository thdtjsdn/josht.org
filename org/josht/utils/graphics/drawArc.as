package org.josht.utils.drawing
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