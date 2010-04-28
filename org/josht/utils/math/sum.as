////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2009 Josh Tynjala
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

package org.josht.utils.math
{
	/**
	 * Calculates the sum of an Array of numbers.
	 * 
	 * @example The following example shows how to use <code>MathUtil.sum()</code>:
	 * <listing version="3.0">
	 * var numbers:Array = [ 1, 2, 3, 4, 5 ];
	 * var sum:Number = MathUtil.sum( 1, 2, 3, 4, 5 );
	 * trace( sum ) //output: 15
	 * </listing>
	 * 
	 * @example The following example shows a fast way to find the sum of
	 * 		an Array of Numbers.
	 * <listing version="3.0">
	 * var numbers:Array = [ 1, 2, 3, 4, 5 ];
	 * var sum:Number = MathUtil.sum.apply( null, numbers );
	 * trace( sum ) //output: 15
	 * </listing>
	 * 
	 * @author Josh Tynjala (joshblog.net)
	 */
	public function sum(a:Number, b:Number, ...rest:Array):Number
	{
		//we need to require two parameters at minimum at compile time.
		//add them to the beginning of rest.
		rest.unshift(b);
		
		var sum:Number = a;
		var count:int = rest.length;
		for(var i:int = 0; i < count; i++)
		{
			sum += Number(rest[i]);
		}
		return sum;
	}
}