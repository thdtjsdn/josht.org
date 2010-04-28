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