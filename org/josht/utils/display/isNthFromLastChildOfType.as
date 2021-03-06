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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * Determines if a DisplayObject is the nth from last instance of its class
	 * among the children of its parent.
	 */
	public function isNthFromLastChildOfType(child:DisplayObject, index:int):Boolean
	{
		var type:Class = Class(Object(child).constructor);
		
		var parent:DisplayObjectContainer = child.parent;
		if(!parent)
		{
			throw new ArgumentError(NO_PARENT_ERROR_TEXT);
		}
		
		var childrenOfTypeCount:int = 0;
		var childCount:int = parent.numChildren; 
		for(var i:int = childCount - 1; i >= 0; i--)
		{
			var currentChild:DisplayObject = parent.getChildAt(i);
			if(currentChild is type)
			{
				childrenOfTypeCount++;
			}
			
			if(currentChild == child)
			{
				return childrenOfTypeCount == index;
			}
		}
		return false;
	}
}