package org.josht.utils.array
{
	public function matchLastItemInArray(target:Array, callback:Function, thisObject:* = null):*
	{
		var last:* = undefined;
		
		var count:int = target.length;
		for(var i:int = count - 1; i >= 0; i--)
		{
			var item:Object = target[i];
			var result:Boolean = callback.apply(thisObject, [item, i, target]);
			if(result)
			{
				last = item;
				break;
			}
		}
		
		return last;
	}
}