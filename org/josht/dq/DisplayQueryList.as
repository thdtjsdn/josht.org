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
package org.josht.dq
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;

	/**
	 * The <code>DisplayQueryList</code> class (and the related <code>DisplayQuery</code> class)
	 * contain methods for traversing and manipulating display objects that
	 * work similarly to the methods in the <code>XML</code> and <code>XMLList</code>
	 * classes that allow developers to work with XML data. Includes support for
	 * E4X-like operators including <code>@</code> for child names and <code>..</code>
	 * for descendants.
	 * 
	 * @see DisplayQuery
	 * @see XML
	 * @see XMLList
	 * @author Josh Tynjala (joshblog.net)
	 */
	public class DisplayQueryList extends Proxy
	{
		use namespace flash_proxy;
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Creates a new <code>DisplayQueryList</code> object.
		 * 
		 * @param value		A <code>DisplayQuery</code> object, a <code>DisplayQueryList</code> object, a <code>DisplayObject</code>, or something that can be cast to <code>Vector.&lt;DisplayObject&gt;</code>.
		 */
		public function DisplayQueryList(value:Object = null)
		{
			if(!value)
			{
				this._doVector = new Vector.<DisplayObject>;
			}
			else if(value is DisplayQuery || value is DisplayObject)
			{
				this._doVector = new Vector.<DisplayObject>;
				var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
				
				//may be null if value is null.
				//we want an empty list in that case.
				if(displayObject) 
				{
					this._doVector.push(displayObject);
				}
			}
			else
			{
				this._doVector = DisplayQuery.valueToVector(value);
			}
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The internal list of display objects.
		 */
		private var _doVector:Vector.<DisplayObject>;
		
		/**
		 * @private
		 * A stored DisplayQuery instance used to avoid too many allocations
		 * with the new keyword. Performance benefit, especially in the loops
		 * required in operations below.
		 */
		private var _dq:DisplayQuery = new DisplayQuery();
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * Adds a display object to the end of the <code>DisplayQueryList</code>.
		 * 
		 * <p>Note: The <code>XMLList</code> class on which <code>DisplayQueryList</code>
		 * is based supports the <code>+=</code> operator to append objects, but
		 * ActionScript 3.0 does not support overriding this operator. I've
		 * created this method as a replacement.</p>
		 * 
		 * @param value	A DisplayQuery object, a <code>DisplayQueryList</code> object
		 * @return		The resulting DisplayQueryList
		 */
		public function append(value:Object):DisplayQueryList
		{
			if(!value)
			{
				return this;
			}
			
			var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(value)
			{
				this._doVector.push(value);
				return this;
			}
			
			var children:Vector.<DisplayObject> = DisplayQuery.valueToVector(value);
			if(children)
			{
				var childCount:int = children.length;
				for(var i:int = 0; i < childCount; i++)
				{
					this._doVector.push(children[i]);
				}
				return this;
			}
			
			throw new ArgumentError("Cannot convert value to DisplayObject or Vector.<DisplayObject>.");
		}
		
		
		/**
		 * Executes a test function on each item in the <code>DisplayQueryList</code>
		 * and constructs a new <code>DisplayQueryList</code> for all items that
		 * return <code>true</code> for the specified function. If an item
		 * returns <code>false</code>, it is not included in the new
		 * <code>DisplayQueryList</code>.
		 * 
		 * <p>Note: The <code>XMLList</code> class on which <code>DisplayQueryList</code>
		 * is based supports the <code>()</code> filter operator, but
		 * ActionScript 3.0 does not offer any way to override this operator. I've
		 * created this method as a replacement.</p>
		 * 
		 * @param value	The function to run on each item in the <code>DisplayQueryList</code>. This function can contain a simple comparison or a more complex operation, and is invoked with three arguments; the value of an item (a DisplayObject), the index of an item, and the <code>DisplayQueryList</code> object:
		 * <p><code>function callback(item:*, index:int, list:DisplayQueryList):Boolean;</code></p>
		 * @return		A new <code>DisplayQueryList</code> that contains all items from the original <code>DisplayQueryList</code> that returned <code>true</code>. 
		 */
		 public function filter(callback:Function, thisObject:* = null):DisplayQueryList
		 {
		 	var filtered:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		 	for each(var displayObject:DisplayObject in this._doVector)
		 	{
		 		var result:Boolean = callback.apply(thisObject, [displayObject, this._doVector.indexOf(displayObject), this]);
		 		if(result)
		 		{
		 			filtered.push(displayObject);
		 		}
		 	}
		 	
		 	return new DisplayQueryList(filtered);
		 }
		
		/**
		 * Calls the <code>child()</code> method of each <code>DisplayQuery</code> object
		 * and returns a <code>DisplayQueryList</code> object that contains the results in
		 * order.
		 * 
		 * @param name		The child name or an integer value.
		 * @return			A DisplayQueryList of child nodes that match the input parameter
		 */
		public function child(name:Object):DisplayQueryList
		{	
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			var doVectorCount:int = this._doVector.length;
			for(var i:int = 0; i < doVectorCount; i++)
			{
				this._dq.fromDisplayObject(this._doVector[i]);
				var list:Vector.<DisplayObject> = this._dq.child(name).toVector();
				
				var listCount:int = list.length;
				for(var j:int = 0; j < listCount; j++)
				{
					children.push(list[j]);
				}
			}
			this._dq.fromDisplayObject(null);
			return new DisplayQueryList(children);
		}
		
		/**
		 * Calls the <code>children()</code> method of each <code>DisplayQuery</code>
		 * object and returns a <code>DisplayQueryList</code> object that contains the
		 * results. 
		 * 
		 * @return 		A <code>DisplayQueryList</code> object of the children in the DisplayQuery objects. 
		 */
		public function children():DisplayQueryList
		{
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			var doVectorCount:int = this._doVector.length;
			for(var i:int = 0; i < doVectorCount; i++)
			{
				this._dq.fromDisplayObject(this._doVector[i]);
				var doList:DisplayQueryList = this._dq.children();
				children = children.concat(doList.toVector());
			}
			this._dq.fromDisplayObject(null);
			
			return new DisplayQueryList(children);
		}
		
		/**
		 * Checks whether the <code>DisplayQueryList</code> object contains a 
		 * <code>DisplayObject</code> that is equal to the given <code>value</code> parameter.
		 * 
		 * @param value		A DisplayObject or DisplayQuery object to compare against the current DisplayQueryList object.
		 * @return			If the DisplayQueryList contains the DisplayObject declared in the value parameter, then true; otherwise false. 
		 */
		public function contains(value:Object):Boolean
		{
			var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(!displayObject)
			{
				return false;
			}
			
			return this._doVector.indexOf(displayObject) >= 0;
		}
		/**
		 * Returns all descendants (children, grandchildren,
		 * great-grandchildren, and so on) of the display object that have the
		 * given <code>name</code> parameter. The <code>name</code> parameter is optional.
		 * 
		 * <p>To return all descendants, use the "*" parameter. If no parameter
		 * is passed, the string "*" is passed and returns all descendants of
		 * the display object.</p>
		 * 
		 * @param name		The name of the element to match.
		 * @return A DisplayQueryList object of the matching descendants (children, grandchildren, and so on) of the DisplayObject instances in the original list. If there are no descendants, returns an empty DisplayQueryList object. 
		 */
		public function descendants(name:String = "*"):DisplayQueryList
		{
			if(!name)
			{
				name = "*";
			}
			var descendants:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			var doVectorLength:int = this._doVector.length;
			for(var i:int = 0; i < doVectorLength; i++)
			{
				var displayObject:DisplayObject = this._doVector[i];
				if(name == "*" || displayObject.name == name)
				{
					descendants.push(displayObject);
				}
				this._dq.fromDisplayObject(displayObject);
				descendants = descendants.concat(this._dq.descendants(name).toVector());
			}
			this._dq.fromDisplayObject(null);
			
			return new DisplayQueryList(descendants);
		}
		
		/**
		 * Returns the number of display objects in the DisplayQueryList.
		 * 
		 * @return the number of display objects in the list
		 */
		public function length():int
		{
			return this._doVector.length;
		}
		
		/**
		 * Returns the parent of the DisplayQueryList object if all items in the
		 * DisplayQueryList object have the same parent. If the DisplayQueryList
		 * object has no parent or different parents, the method returns
		 * <code>undefined</code>.
		 * 
		 * @return			A DisplayQuery object for the parent of this DisplayQueryList 
		 */
		public function parent():DisplayQuery
		{
			var childCount:int = this._doVector.length;
			if(childCount == 0)
			{
				return undefined;
			}
			
			var parent:DisplayObjectContainer = this._doVector[0].parent;
			if(childCount > 1)
			{
				//we already checked the first child, so start at 1
				for(var i:int = 1; i < childCount; i++)
				{
					if(parent != this._doVector[i].parent)
					{
						return undefined;
					}
				}
			} 
			return new DisplayQuery(parent);
		}
		
		/**
		 * Returns a <code>Vector.&lt;DisplayObject&gt;</code> containing all
		 * the DisplayObject instances in the list.
		 */
		public function toVector():Vector.<DisplayObject>
		{
			return this._doVector.concat();
		}
		
		/**
		 * @private
		 */
		public function toString():String
		{
			return "[object DisplayQueryList length=" + this._doVector.length + "]";
		}
		
	//-- functions that only work when vector length is one
		
		/**
		 * @private
		 * @see DisplayQuery#name()
		 */
		public function name():String
		{
			if(this._doVector.length == 1)
			{
				var name:String = this._dq.fromDisplayObject(this._doVector[0]).name();
				this._dq.fromDisplayObject(null);
				return name;
			}
			
			throw new TypeError("The name() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#appendChild()
		 */
		public function appendChild(value:Object):DisplayQuery
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).appendChild(value);
			}
			
			throw new TypeError("The appendChild() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#childIndex()
		 */
		public function childIndex():int
		{
			if(this._doVector.length == 1)
			{
				var childIndex:int = this._dq.fromDisplayObject(this._doVector[0]).childIndex();
				this._dq.fromDisplayObject(null);
				return childIndex;
			}
			
			throw new TypeError("The childIndex() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#insertChildAfter()
		 */
		public function insertChildAfter(child1:Object, child2:Object):*
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).insertChildAfter(child1, child2);
			}
			
			throw new TypeError("The insertChildAfter() method only works on lists containing one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#insertChildBefore()
		 */
		public function insertChildBefore(child1:Object, child2:Object):*
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).insertChildBefore(child1, child2);
			}
			
			throw new TypeError("The insertChildBefore() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#prependChild()
		 */
		public function prependChild(value:Object):DisplayQuery
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).prependChild(value);
			}
			
			throw new TypeError("The prependChild() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#replace()
		 */
		public function replace(name:Object, value:Object):DisplayQuery
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).replace(name, value);
			}
			
			throw new TypeError("The replace() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#setChildren()
		 */
		public function setChildren(value:Object):DisplayQuery
		{
			if(this._doVector.length == 1)
			{
				return new DisplayQuery(this._doVector[0]).setChildren(value);
			}
			
			throw new TypeError("The setChildren() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#setName()
		 */
		public function setName(value:String):void
		{
			if(this._doVector.length == 1)
			{
				this._dq.fromDisplayObject(this._doVector[0]).setName(value);
				this._dq.fromDisplayObject(null);
			}
			
			throw new TypeError("The setName() method only works on lists containing exactly one item.");
		}
		
		/**
		 * @private
		 * @see DisplayQuery#toDisplayObject()
		 */
		public function toDisplayObject():*
		{
			var length:int = this._doVector.length;
			if(length == 1)
			{
				return this._doVector[0];
			}
			
			throw new TypeError("The toDisplayObject() method only works on lists containing exactly one item.");
		}
		
	//--------------------------------------
	//  flash_proxy Methods
	//--------------------------------------
		
		/**
		 * @private
		 * If the length of the list is 1, behaves like a DisplayQuery. If the
		 * name is an attribute, check if child(name) returns any values. If the
		 * name is an integer, check if it falls within the range of the list.
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			if(this._doVector.length == 1)
			{
				var result:* = this._dq.fromDisplayObject(this._doVector[0]).hasOwnProperty(name);
				this._dq.fromDisplayObject(null);
				return result;
			}
			else if(this.isAttribute(name))
			{
				return this.child(QName(name).localName).length() > 0;
			}
			else if(Number(name) is int)
			{
				var index:int = int(name);
				return index >= 0 && index < this._doVector.length;
			}
			return false;
		}
		
		/**
		 * @private
		 * If the list's length is 1, then behaves like a DisplayQuery,
		 * otherwise calls child() if the name is an attribute or returns a
		 * DisplayQuery for the item at the specified index. If not an attribute
		 * or an integer, throws a ReferenceError.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			if(this._doVector.length == 1)
			{
				var result:* = this._dq.fromDisplayObject(this._doVector[0])[name];
				this._dq.fromDisplayObject(null);
				return result;
			}
			else if(this.isAttribute(name))
			{
				return this.child(QName(name).localName);
			}
			else if(Number(name) is int)
			{
				return new DisplayQuery(this._doVector[int(name)]);
			}
			
			throw new ReferenceError("Property " + name + " not found on " + getQualifiedClassName(this) + " and there is no default value.");
		}
		
		/**
		 * @private
		 * @see #descendants()
		 */
		override flash_proxy function getDescendants(name:*):*
		{
			return this.descendants(name);
		}
		
		/**
		 * @private
		 * If the length of the list is 1, behaves like a DisplayQuery.
		 * Otherwise, throws errors.
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			if(this._doVector.length == 1)
			{
				this._dq.fromDisplayObject(this._doVector[0])[name] = value;
				this._dq.fromDisplayObject(null);
				return;
			}
			else if(this.isAttribute(name))
			{
				throw new TypeError("@ operator only works on lists containing exactly one item.");
			}
			else if(Number(name) is int)
			{
				throw new TypeError("[] operator only works on lists containing exactly one item.");
			}
			
			throw new ReferenceError("Cannot create property " + name + " on " + getQualifiedClassName(this) + ".");
		}
		
		
		/**
		 * @private
		 * If the length of the list is 1, behaves like a DisplayQuery.
		 * 
		 * @see DisplayQuery#deleteProperty()
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if(this._doVector.length == 1)
			{
				var result:Boolean = delete this._dq.fromDisplayObject(this._doVector[0])[name];
				this._dq.fromDisplayObject(null);
				return result;
			}
			return false;
		}
	}
}