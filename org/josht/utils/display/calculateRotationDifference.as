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

package org.josht.utils.display
{
	import org.josht.utils.math.clamp;

	/**
	 * Calculates the difference between two <code>DisplayObject.rotation</code>
	 * values. The <code>rotation</code> property of a DisplayObject is always a
	 * value between -180 and 180. If the difference is larger than the
	 * value of the <code>wrapThreshold</code> argument, then it is assumed
	 * that the rotation value has wrapped.
	 * 
	 * @example The following example shows how to use <code>calculateRotationDifference</code>:
	 * <listing version="3.0">
	 * displayObject.rotation = 125;
	 * var oldValue:Number = displayObject.rotation;
	 * var newValue:Number = displayObject.rotation = 140;
	 * 
	 * var difference:Number = DisplayObjectUtil.calculateRotationDifference(newValue, oldValue, 300);
	 * trace(difference); //output: 15
	 * </listing>
	 * 
	 * TODO: add an example that includes wrapping
	 */
	public function calculateRotationDifference(newValue:Number, oldValue:Number, wrapThreshold:Number):Number
	{
		wrapThreshold = clamp(wrapThreshold, 0, 360);
		
		var difference:Number = newValue - oldValue;
		if(Math.abs(difference) > wrapThreshold)
		{
			if(oldValue > 0)
			{
				difference += 360;
			}
			else
			{
				difference -= 360;
			}
		}
		return difference;
	}
}