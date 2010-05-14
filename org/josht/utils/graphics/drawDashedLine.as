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
	 * Draws a dashed line between two points.
	 * 
	 * @param target	The Graphics object to which to draw
	 * @param xStart	The x position of the start of the line
	 * @param yStart	The y position of the start of the line
	 * @param xEnd		The x position of the end of the line
	 * @param yEnd		The y position of the end of the line
	 * @param dashSize	the size of dashes, in pixels
	 * @param gapSize	the size of gaps between dashes, in pixels
	 */
	public function drawDashedLine(target:Graphics, xStart:Number, yStart:Number, xEnd:Number, yEnd:Number, dashSize:Number = 10, gapSize:Number = 10):void
	{
		// calculate the length of a segment
		var segmentLength:Number = dashSize + gapSize;
		
		// calculate the length of the dashed line
		var xDelta:Number = xEnd - xStart;
		var yDelta:Number = yEnd - yStart;
		var delta:Number = Math.sqrt(Math.pow(xDelta, 2) + Math.pow(yDelta, 2));
		
		// calculate the number of segments needed
		var segmentCount:int = Math.floor(Math.abs(delta / segmentLength));
		
		// get the angle of the line in radians
		var radians:Number = Math.atan2(yDelta, xDelta);
		
		// start the line here
		var xCurrent:Number = xStart;
		var yCurrent:Number = yStart;
		
		// add these to cx, cy to get next seg start
		xDelta = Math.cos(radians) * segmentLength;
		yDelta = Math.sin(radians) * segmentLength;
		
		// loop through each segment
		for(var i:int = 0; i < segmentCount; i++)
		{
			target.moveTo(xCurrent, yCurrent);
			target.lineTo(xCurrent + Math.cos(radians) * dashSize, yCurrent + Math.sin(radians) * dashSize);
			xCurrent += xDelta;
			yCurrent += yDelta;
		}
		
		// handle last segment as it is likely to be partial
		target.moveTo(xCurrent, yCurrent);
		delta = Math.sqrt((xEnd - xCurrent) * (xEnd - xCurrent) + (yEnd - yCurrent) * (yEnd - yCurrent));
		
		if(delta > dashSize)
		{
			// segment ends in the gap, so draw a full dash
			target.lineTo(xCurrent + Math.cos(radians) * dashSize, yCurrent + Math.sin(radians) * dashSize);
		}
		else if(delta > 0)
		{
			// segment is shorter than dash so only draw what is needed
			target.lineTo(xCurrent + Math.cos(radians) * delta, yCurrent + Math.sin(radians) * delta);
		}
		
		// move the pen to the end position
		target.moveTo(xEnd, yEnd);
	}
}