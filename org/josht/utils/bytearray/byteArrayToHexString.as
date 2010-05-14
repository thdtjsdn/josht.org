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

package org.josht.utils.bytearray
{
	import flash.utils.ByteArray;

	/**
	 * Converts a ByteArray to a hexadecimal-encoded String.
	 * 
	 * @param hexData		A ByteArray.
	 * @return				The same data converted to a hexadecimal-encoded String.
	 */
	public function byteArrayToHexString(data:ByteArray):String
	{
		var oldPosition:int = data.position;
		data.position = 0;
		
		var joinedBytes:String = "";
		while(data.bytesAvailable)
		{
			var byte:int = data.readByte();
			if(byte < 0) //keep it positive and between 0x00 and 0xff
			{
				byte = 0x100 + byte;
			}
			
			var byteText:String = byte.toString(16);
			
			if(byteText.length == 1) //add a leading 0 if needed
			{
				byteText = "0" + byteText;
			}
			
			joinedBytes += byteText;
		}
		
		data.position = oldPosition;
		
		return joinedBytes;
	}
}