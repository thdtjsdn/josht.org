/*
Copyright (c) 2010 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package org.josht.utils.math
{
	/**
	 * Calculates the greatest common divisor for a set of numbers.
	 * 
	 * @param a			A numeric value.
	 * @param b			Another numeric value.
	 * @return			The greatest common denominator of the input numbers.
	 */
	public function greatestCommonDivisor(a:Number, b:Number, ...rest:Array):Number
	{
		//we need to require two parameters at minimum at compile time.
		//add them to the beginning of rest.
		rest.unshift(b);
		
		var divisor:Number = a;
		var count:int = rest.length;
		for(var i:int = 0; i < count; i++)
		{
			divisor = gcd(divisor, Number(rest[i]));
		}
		return divisor;
	}
}

/**
 * @private
 * The real implementation of gcd(). We call this while looping through
 * the parameters.
 */
function gcd(a:Number, b:Number):Number
{
	if(a == 0) return b;

	var remainder:Number;
	while(b != 0)
	{
		remainder = a % b;
		a = b;
		b = remainder;
	}
	
	return a;
}