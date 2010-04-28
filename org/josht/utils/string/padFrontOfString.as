package org.josht.utils.string
{
	public function padFrontOfString(input:String, totalLength:int, padCharacter:String):String
	{
		var difference:int = totalLength - input.length;
		if(difference <= 0) return input;
		
		for(var i:int = 0; i < difference; i++)
		{
			input = padCharacter + input;
		}
		return input;
	}
}