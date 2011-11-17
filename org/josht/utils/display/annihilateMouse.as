package org.josht.utils.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;

	/**
	 * Traverses the display list starting at a target root node and sets
	 * mouseEnabled and mouseChildren to false on absolutely everything. For
	 * some reason, this lowers CPU usage better than setting mouseChildren
	 * on the root node alone.
	 */
	public function annihilateMouse(target:DisplayObject, childrenOnly:Boolean = false):void
	{
		//no need to go on if the target isn't interactive. the typing of target
		//as DisplayObject is for convenience.
		if(!(target is InteractiveObject))
		{
			return;
		}
		const interactiveTarget:InteractiveObject = InteractiveObject(target);
		if(!childrenOnly)
		{
			interactiveTarget.mouseEnabled = false;
		}
		if(interactiveTarget is DisplayObjectContainer)
		{
			const doc:DisplayObjectContainer = DisplayObjectContainer(interactiveTarget);
			doc.mouseChildren = false;
			const childCount:int = doc.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:DisplayObject = doc.getChildAt(i);
				annihilateMouse(child);
			}
		}
	}
}