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

package org.josht.utils.bytearray
{
	import flash.utils.ByteArray;

	/**
	 * Converts a hexadecimal-encoded String to a ByteArray.
	 * 
	 * @param hexData		A hexadecimal-encoded String.
	 * @return				The same data converted to a ByteArray.
	 */
	public function hexStringToByteArray(hexData:String):ByteArray
	{
		var binaryData:ByteArray = new ByteArray();
		var charCount:int = hexData.length;
		for(var i:int = 0; i < charCount; i += 2)
		{
			var hexByte:String = hexData.substr(i, 2);
			var byte:int = parseInt(hexByte, 16);
			binaryData.writeByte(byte);
		}
		binaryData.position = 0;
		return binaryData;
	}
}