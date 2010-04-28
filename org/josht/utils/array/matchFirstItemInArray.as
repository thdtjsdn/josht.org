package org.josht.utils.array
{
	public function matchFirstItemInArray(target:Array, callback:Function, thisObject:* = null):*
	{
		var first:* = undefined;
		
		var count:int = target.length;
		for(var i:int = 0; i < count; i++)
		{
			var item:Object = target[i];
			var result:Boolean = callback.apply(thisObject, [item, i, target]);
			if(result)
			{
				first = item;
				break;
			}
		}
		
		return first;
	}
}