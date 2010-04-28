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
	 * The <code>DisplayQuery</code> class allows developers to traverse and
	 * manipulate display objects in the same way that E4X can be used to work
	 * with XML data.
	 * 
	 * <p>Includes support for several language operators and keywords:</p>
	 * <ul>
	 * 	<li><p>To access children of a display object by name, use the <code>@</code> operator.</p></li>
	 * 	<li><p>To access children by index, use the <code>[]</code> operator</p></li>
	 * 	<li><p>To access any descendant by name (children, grandchildren, etc.), use the <code>..</code> operator.</p></li>
	 * 	<li><p>To remove children (but not descendants), use the <code>delete</code> keyword.</p></li>
	 * </ul>
	 * 
	 * <p>Each of the following examples builds upon the previous. The code can
	 * be placed on the timeline in the Flash authoring tool, or in a document
	 * class of any ActionScript-based project..</p> 
	 * 
	 * @example To create a new DisplayQuery object, pass any display object to the constructor:
	 * <listing version="3.0">
	 * // Note: In the following example, the display objects named "container"
	 * // and "square" could be created visually in the Flash authoring tool
	 * var container:Sprite = new Sprite();
	 * container.graphics.beginFill( 0xff0000 );
	 * container.graphics.drawRect( 0, 0, 200, 200 );
	 * container.graphics.endFill();
	 * this.addChild( container );
	 * 
	 * var square:Shape = new Shape();
	 * square.name = "square";
	 * square.graphics.beginFill( 0x0000ff );
	 * square.graphics.drawRect( 0, 0, 100, 100 );
	 * square.graphics.endFill();
	 * square.x = 50;
	 * square.y = 50;
	 * container.addChild( square );
	 * 
	 * // "this" is the parent of container
	 * var query:DisplayQuery = new DisplayQuery( this );
	 * </listing>
	 * 
	 * @example To access a child of a display object by name, use the <code>@</code> operator. The <code>toDisplayObject()</code> method returns the original display object from the query chain:
	 * var container2:Sprite = query.@container.toDisplayObject();
	 * trace( container == container2 ) //output: true
	 * 
	 * var square2:Shape = query.@container.@square.toDisplayObject();
	 * trace( square == square2 ); // output: true
	 * </listing>
	 * 
	 * @example To access a child of a display object by index, use the <code>[]</code> operator:
	 * <listing version="3.0">
	 * var container3:Shape = query[0].toDisplayObject();
	 * trace( container == container3 ); // output: true
	 * </listing>
	 * 
	 * @example To remove a child of a display object by name, use the <code>delete</code> keyword combined with the <code>@</code> operator:
	 * <listing version="3.0">
	 * delete query.@container.@square;
	 * trace( query.@container.@square.length() ); // output: 0
	 * 
	 * delete query.@container;
	 * trace( query.@container.length() ); // output: 0
	 * </listing>
	 * 
	 * @see DisplayQueryList
	 * @see XML
	 * @see XMLList
	 * @author Josh Tynjala (joshblog.net)
	 */
	public dynamic class DisplayQuery extends Proxy
	{
		use namespace flash_proxy;
		
	//--------------------------------------
	//  Internal Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		internal static const CONVERSION_ERROR:String = "The convert input parameter to DisplayObject or Vector.<DisplayObject>."
		
		/**
		 * @private
		 */
		internal static const DISPLAY_OBJECT_CONVERSION_ERROR:String = "Cannot convert input parameter to DisplayObject.";
		
	//--------------------------------------
	//  Internal Static Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Converts a value to a DisplayObject. If the value is a DisplayQuery,
		 * uses toDisplayObject() to extract the query target. If not a
		 * DisplayQuery, tries to cast to a DisplayObject.
		 */
		internal static function valueToDisplayObject(value:Object):DisplayObject
		{
			var displayObject:DisplayObject
			if(value is DisplayQuery)
			{
				displayObject = DisplayQuery(value).toDisplayObject();
			}
			else if(value is DisplayQueryList)
			{
				displayObject = DisplayQueryList(value).toDisplayObject();
			}
			else
			{
				displayObject = DisplayObject(value);
			}
			
			return displayObject;
		}
		
		/**
		 * @private
		 * Converts a value to a Vector.<DisplayObject>. If the value is a
		 * DisplayQueryList, uses toVector() to extract the query target. If not
		 * a DisplayQueryList, tries to cast to a Vector.<DisplayObject>.
		 */
		internal static function valueToVector(value:Object):Vector.<DisplayObject>
		{
			var vector:Vector.<DisplayObject>;
			if(value is DisplayQueryList)
			{
				vector = DisplayQueryList(value).toVector();
			}
			else if(value is DisplayQuery)
			{
				vector = DisplayQuery(value).toVector();
			}
			else
			{
				vector = Vector.<DisplayObject>(value);
			}
			
			return vector;
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Creates a new <code>DisplayQuery</code> object.
		 * 
		 * <p>Use the <code>toDisplayObject()</code> method to return a native
		 * display list representation of the display object.</p>
		 * 
		 * @param value		A <code>DisplayQuery</code> object or a <code>DisplayObject</code>.
		 */
		public function DisplayQuery(value:Object = null)
		{
			this._target = DisplayQuery.valueToDisplayObject(value);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The display object instance that is being manipulated.
		 */
		private var _target:DisplayObject;
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * Appends the given child to the end of the display object's list of
		 * children. The <code>appendChild()</code> method takes a <code>DisplayQuery</code>
		 * object, a <code>DisplayQueryList</code> object, a <code>DisplayObject</code>,
		 * or something that can be cast to <code>Vector.&lt;DisplayObject&gt;</code>
		 * as the <code>value</code> parameter.
		 * 
		 * <p>Use the <code>delete</code> operator to remove children.</p>
		 * 
		 * @param value		The display object to append.
		 * @return			The resulting DisplayQuery object.
		 * @throws ArgumentError	The value cannot be converted to a DisplayObject or a Vector of DisplayObject instances.
		 */
		public function appendChild(value:Object):DisplayQuery
		{
			if(!value)
			{
				return this;
			}
			
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				//if this isn't a container, then do nothing
				return this;
			}
			
			//first check if the value is a DisplayObject or a DisplayQuery instance.
			var child:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(child)
			{
				doc.addChild(child);
				return this;
			}
			
			//next check if it can be cast to Vector.<DisplayObject>
			var children:Vector.<DisplayObject> = DisplayQuery.valueToVector(value);
			if(children)
			{
				var childCount:int = children.length;
				for(var i:int = 0; i < childCount; i++)
				{
					doc.addChild(children[i]);
				}
				return this;
			}
			
			throw new ArgumentError(CONVERSION_ERROR);
		}
		
		/**
		 * Lists the children of a display object.
		 * 
		 * <p>Use the <code>name</code> parameter to return a specific child.
		 * For example, to return a child with the name <code>"first"</code>, 
		 * use <code>child("first")</code>. You can generate the same result by
		 * using the child's index number. For example, <code>child(0)</code>
		 * returns the first child in a list.</p>
		 * 
		 * <p>Use an asterisk (*) to output all the children in an display
		 * object. For example, <code>child("*")</code>.
		 * 
		 * @param name		The name of the child or an integer representing its index.
		 * @return	A DisplayQueryList of children that match the input parameter
		 */
		public function child(name:Object):DisplayQueryList
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				//if this display object can't have children, return an empty list
				return new DisplayQueryList();
			}
			
			//special case: returns all children
			if(name == "*")
			{
				return this.children();
			}
			
			var child:DisplayObject;
			
			//first check if we're looking at an index. must be in range.
			if(Number(name) is int)
			{
				var index:Number = int(name);
				if(index >= 0 && index < doc.numChildren)
				{
					child = doc.getChildAt(index);
				}
			}
			else
			{
				//otherwise, look for a child with the specified name
				child = DisplayObjectContainer(this._target).getChildByName(name.toString());
			}
		
			//if child is null, this will be an empty list
			return new DisplayQueryList(child);
		}
		
		/**
		 * Identifies the zero-indexed position of this display object within
		 * the context of its parent.
		 * 
		 * @return The position of the object. Returns -1 as well as positive integers. 
		 */
		public function childIndex():int
		{
			try
			{
				return this._target.parent.getChildIndex(this._target);
			}
			catch(error:Error)
			{
				//throws an error if the DisplayObject doesn't have a parent
				//we'll ignore the error and return -1
			}
			
			return -1;
		}
		
		/**
		 * Lists the children of the display object in the sequence in which
		 * they appear. If the display object cannot have children, this
		 * function returns an empty DisplayQueryList.
		 * 
		 * @return A DisplayQueryList object of the display object's children. 
		 */
		public function children():DisplayQueryList
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				//can't have children, so return an empty DisplayQueryList
				return new DisplayQueryList();
			}
			
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			var childCount:int = doc.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				children.push(doc.getChildAt(i));
			}
			
			return new DisplayQueryList(children);
		}
		
		/**
		 * Checks if the display object contains another display object. If the
		 * display object cannot have children, returns <code>false</code>.
		 * 
		 * @param value		A DisplayObject or DisplayQuery instance.
		 * @return <code>true</code> if the specified child is a descendant of the display object, or <code>false</code> if it is not a descendant.
		 * 
		 * @see flash.display.DisplayObjectContainer#contains()
		 */
		public function contains(value:Object):Boolean
		{
			var doc:DisplayObjectContainer = DisplayObjectContainer(this._target);
			if(!doc)
			{
				return false;
			}
			
			//try to convert to a display object
			var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			return doc.contains(displayObject);
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
		 * @return A DisplayQueryList object of matching descendants. If there are no descendants, returns an empty DisplayQueryList object.
		 */
		public function descendants(name:String = "*"):DisplayQueryList
		{
			if(!name)
			{
				name = "*";
			}
			
			var descendants:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			
			var dq:DisplayQuery = new DisplayQuery();
			var children:Vector.<DisplayObject> = this.children().toVector();
			var childCount:int = children.length;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:DisplayObject = children[i];
				dq.fromDisplayObject(child);
				if(name == "*" || dq.name() == name)
				{
					descendants.push(child);
				}
				descendants = descendants.concat(dq.descendants(name).toVector());
			}
			
			return new DisplayQueryList(descendants);
		}
		
		/**
		 * <p>Inserts the given <code>child2</code> parameter after the <code>child1</code>
		 * parameter in this display object and returns the resulting object. If
		 * the <code>child1</code> parameter is <code>null</code>, the method
		 * inserts the contents of <code>child2</code> before all children of
		 * the display object object (in other words, after <em>none</em>). If
		 * <code>child1</code> is provided, but it does not exist in the display
		 * object, the display object is not modified and <code>undefined</code>
		 * is returned.
		 * 
		 * <p>If you call this method on an display object that is not a
		 * container (cannot have children), <code>undefined</code> is returned.</p>
		 * 
		 * <p>Use the <code>delete</code> operator to remove children.</p>
		 * 
		 * @param child1	The object after which child2 is inserted.
		 * @param child2	The display object to insert.
		 * @return The resulting DisplayQuery object or <code>undefined</code>. 
		 */
		public function insertChildAfter(child1:Object, child2:Object):*
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return undefined;
			}
			
			var c1:DisplayObject = DisplayQuery.valueToDisplayObject(child1);
			if(c1 && c1.parent != doc)
			{
				//c1's parent isn't this object, so we can't insert anything
				//in relation to it!
				return undefined;
			}
			
			var c2:DisplayObject = DisplayQuery.valueToDisplayObject(child2);
			if(!c2)
			{
				//TODO: should this return undefined?
				throw new ArgumentError("child2 must be either a DisplayQuery or a DisplayObject instance.");
			}
			
			if(!c1)
			{
				//if c1 is null, insert at the beginning
				doc.addChildAt(c2, 0);
			}
			else
			{
				var index:int = doc.getChildIndex(c1);
				doc.addChildAt(c2, index + 1);
			}
			return this;
		}
		
		/**
		 * Inserts the given <code>child2</code> parameter before the <code>child1</code>
		 * parameter in this display object and returns the resulting object. If
		 * the <code>child1</code> parameter is <code>null</code>, the method
		 * inserts the contents of <code>child2</code> after all children of the
		 * display object (in other words, before <em>none</em>). If <code>child1</code>
		 * is provided, but it does not exist in the display object, the display
		 * object is not modified and <code>undefined</code> is returned.
		 * 
		 * <p>If you call this method on an display object that is not an
		 * container (it cannot hold children) <code>undefined</code> is
		 * returned.</p>
		 * 
		 * <p>Use the <code>delete</code> operator to remove children.</p>
		 * 
		 * @param child1	The object before which child2 is inserted.
		 * @param child2	The display object to insert.
		 * @return The resulting DisplayQuery object or <code>undefined</code>. 
		 */
		public function insertChildBefore(child1:Object, child2:Object):*
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return undefined;
			}
			
			var c1:DisplayObject = DisplayQuery.valueToDisplayObject(child1);
			if(c1 && c1.parent != doc)
			{
				//c1's parent isn't this object, so we can't insert anything
				//in relation to it!
				return undefined;
			}
			
			var c2:DisplayObject = DisplayQuery.valueToDisplayObject(child2);
			if(!c2)
			{
				//TODO: should this return undefined?
				throw new ArgumentError("child2 must be either a DisplayQuery or a DisplayObject instance.");
			}
			
			if(!c1)
			{
				//if c1 is null, insert at the end
				doc.addChild(c2);
			}
			{
				var index:int = doc.getChildIndex(c1);
				doc.addChildAt(c2, index);
			}
			return this;
		}
		
		/**
		 * For containers, returns the value of <code>numChildren</code>. For non-containers,
		 * returns <code>0</code>.
		 * 
		 * @return	The number of children this display object contains.
		 * 
		 * @see flash.display.DisplayObjectContainer#numChildren
		 */
		public function length():int
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return 0;
			}
			
			return doc.numChildren;
		}
		
		/**
		 * Gives the name of the display object.
		 * 
		 * @return	The name of the display object or <code>null</code>.
		 * @see flash.display.DisplayObject#name
		 */
		public function name():String
		{
			return this._target.name;
		}
		
		/**
		 * Returns the parent of the display object. If the display object has
		 * no parent, the method returns <code>undefined</code>.
		 * 
		 * @return Either a DisplayQuery reference of the parent, or <code>undefined</code> if the display object has no parent.
		 * @see flash.display.DisplayObject#parent 
		 */
		public function parent():*
		{
			if(!this._target.parent)
			{
				return undefined;
			}
			return new DisplayQuery(this._target.parent);
		}
		
		/**
		 * Prepends the given child to the beginning of the display object's
		 * list of children. The <code>prependChild()</code> method takes a <code>DisplayQuery</code>
		 * object, a </code>DisplayQueryList</code> object, a <code>DisplayObject</code>,
		 * or something that can be cast to a <code>Vector.&lt;DisplayObject&gt;</code>
		 * as the <code>value</code> parameter.
		 * 
		 * <p>Use the <code>delete</code> operator to remove children.</p>
		 * 
		 * @param value		The display object to prepend.
		 * @return			The resulting DisplayQuery object.
		 * @throws ArgumentError	The value cannot be converted to a <code>DisplayObject</code> or something that can be cast <code>Vector.&lt;DisplayObject&gt;</code>.
		 */
		public function prependChild(value:Object):DisplayQuery
		{
			if(!value)
			{
				return this;
			}
			
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				//if this isn't a container, then do nothing
				return this;
			}
			
			//first check if the value is a DisplayObject or a DisplayQuery instance.
			var child:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(child)
			{
				doc.addChildAt(child, 0);
				return this;
			}
			
			//next check if it is something that can be converted to Vector.<DisplayObject>.
			var children:Vector.<DisplayObject> = DisplayQuery.valueToVector(value);
			if(children)
			{
				var childCount:int = children.length;
				for(var i:int = 0; i < childCount; i++)
				{
					doc.addChildAt(children[i], i);
				}
				return this;
			}
			
			throw new ArgumentError(CONVERSION_ERROR);
		}
		
		/**
		 * Replaces the children specified by the <code>name</code> parameter
		 * with the given <code>value</code> parameter. If no child names match
		 * the <code>name</code> parameter, the display object is left
		 * unmodified.
		 * 
		 * @param name		Can be a numeric value, an name of a display object, or the asterisk wildcard ("*").
		 * @param value		The replacement value. This can be a <code>DisplayQuery</code> object, a <code>DisplayQueryList</code> object, a <code>DisplayObject</code>, or something that can be cast to <code>Vector.&lt;DisplayObject&gt;.
		 * @return			The resulting DisplayQuery object.
		 */
		public function replace(name:Object, value:Object):DisplayQuery
		{	
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return this;
			}
			
			var childToReplace:DisplayObject
			var index:Number = Number(name);
			//first check if we're looking at an index. must be in range.
			if(index == int(index) && index >= 0 && index < doc.numChildren)
			{
				childToReplace = doc.getChildAt(index);
			}
			else
			{
				childToReplace = doc.getChildByName(name.toString());
			}
			
			if(childToReplace)
			{
				index = doc.getChildIndex(childToReplace);
				doc.removeChild(childToReplace);
			}
			else
			{
				return this;
			}
			
			if(!value)
			{
				return this;
			}
			
			var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(displayObject)
			{
				doc.addChildAt(displayObject, index);
				return this;
			}
			
			var children:Vector.<DisplayObject> = DisplayQuery.valueToVector(value);
			if(children)
			{
				var childCount:int = children.length;
				for(var i:int = 0; i < childCount; i++)
				{
					doc.addChildAt(children[i], index);
					index++;
				}
				return this;
			}
			
			throw new ArgumentError(CONVERSION_ERROR);
		}
		
		/**
		 * Replaces the children of the display object with the specified set of
		 * children, provided in the <code>value</code> parameter.
		 * 
		 * @param value		The replacement children. Can be a single <code>DisplayQuery</code> object, a <code>DisplayQueryList</code> object, a <code>DisplayObject</code> or something that can be cast to <code>Vector.&lt;DisplayObject&gt;</code>.
		 * @return			The resulting DisplayQuery object. 
		 */
		public function setChildren(value:Object):DisplayQuery
		{
			if(!value)
			{
				return this;
			}
			
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return this;
			}
			
			var childCount:int = doc.numChildren;
			for(var i:int = 0; i < childCount; i++)
			{
				doc.removeChildAt(0);
			}
			
			var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
			if(displayObject)
			{
				doc.addChild(displayObject);
				return this;
			}
			
			var children:Vector.<DisplayObject> = DisplayQuery.valueToVector(value);
			if(children)
			{
				childCount = children.length;
				for(i = 0; i < childCount; i++)
				{
					doc.addChild(children[i]);
				}
				return this;
			}
			
			throw new ArgumentError(CONVERSION_ERROR);
		}
		
		/**
		 * Sets the name of the display object.
		 * 
		 * @param value		The new name value.
		 * @see flash.display.DisplayObject#name
		 */
		public function setName(value:String):void
		{
			this._target.name = value;
		}
		
		/**
		 * @private
		 */
		public function toString():String
		{
			return "[object DisplayQuery " + this._target.name + "]";
		}

		/**
		 * @private
		 */
		public function fromDisplayObject(value:DisplayObject):DisplayQuery
		{
			this._target = value;
			return this;
		}
		
		/**
		 * Returns the wrapped display object. Typed as <code>*</code> so that
		 * it can easily be placed into <code>DisplayObject</code> subclasses.
		 * 
		 * @return	a <code>DisplayObject</code> instance
		 */
		public function toDisplayObject():*
		{
			return this._target;
		}
		
		/**
		 * Returns a <code>Vector.&lt;DisplayObject&gt;</code> containing the
		 * wrapped display object.
		 */
		public function toVector():Vector.<DisplayObject>
		{
			var vector:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			vector.push(this._target);
			return vector;
		}
		
		/**
		 * @private
		 */
		public function valueOf():DisplayQuery
		{
			return this;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
		
	//--------------------------------------
	//  flash_proxy Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Checks if the display object has a child with the specified name
		 * or a child at the specified index.
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var doc:DisplayObjectContainer = this._target as DisplayObjectContainer;
			if(!doc)
			{
				return false;
			}
			
			if(this.isAttribute(name))
			{
				return this.child(QName(name).localName).length() > 0;
			}
			
			if(Number(name) is int)
			{
				return this.child(int(name)).length() > 0;
			}
			
			return false;
		}
		
		/**
		 * @private
		 * Returns a child by name or by index.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			if(this.isAttribute(name))
			{
				return this.child(QName(name).localName);
			}
			
			if(Number(name) is int)
			{
				return this.child(int(name));
			}
			
			throw new ReferenceError("Property " + name + " not found on " + getQualifiedClassName(this) + " and there is no default value.");
		}
		
		/**
		 * @private
		 * Returns a list of descendants of the display object.
		 */
		override flash_proxy function getDescendants(name:*):*
		{
			if(this.isAttribute(name))
			{
				return this.descendants(QName(name).localName);
			}
			
			throw new ReferenceError("Descendants operator (..) must be combined with @ operator when used with class " + getQualifiedClassName(this) + ". Did you mean @" + name + "?");
		}
		
		/**
		 * @private
		 * Adds a child with the specified name or at the specified index.
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			if(this.isAttribute(name))
			{
				var displayObject:DisplayObject = DisplayQuery.valueToDisplayObject(value);
				if(!displayObject)
				{
					throw new ArgumentError(DISPLAY_OBJECT_CONVERSION_ERROR);
				}
				displayObject.name = QName(name).localName;
				DisplayObjectContainer(this._target).addChild(displayObject);
				return;
			}
			
			if(Number(name) is int)
			{
				displayObject = DisplayQuery.valueToDisplayObject(value);
				if(!displayObject)
				{
					throw new ArgumentError(DISPLAY_OBJECT_CONVERSION_ERROR);
				}
				DisplayObjectContainer(this._target).addChildAt(displayObject, int(name));
				return;
			}
			
			throw new ReferenceError("Cannot create property " + name + " on " + getQualifiedClassName(this) + ".");
		}
		
		/**
		 * @private
		 * Removes a child with the specified name or at the specified index.
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var doc:DisplayObjectContainer = DisplayObjectContainer(this._target);
			if(this.isAttribute(name))
			{
				var displayObject:DisplayObject = doc.getChildByName(QName(name).localName);
				if(displayObject)
				{
					doc.removeChild(displayObject);
					return true;
				}
				return false;
			}
			
			if(Number(name) is int)
			{
				var index:int = int(name);
				if(index >= 0 && index < doc.numChildren)
				{
					doc.removeChildAt(index);
					return true;
				}
				return false;
			}
			
			return false;
		}
		
		/**
		 * @private
		 * Allows iteration through children.
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			var doc:DisplayObjectContainer = DisplayObjectContainer(this._target);
			if(index < doc.numChildren)
			{
				return index + 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 * Allows iteration through children.
		 */
		override flash_proxy function nextName(index:int):String
		{
			var doc:DisplayObjectContainer = DisplayObjectContainer(this._target);
			var child:DisplayObject = doc.getChildAt(index - 1);
			return "@" + child.name;
		}
		
		/**
		 * @private
		 * Allows iteration through children.
		 */
		override flash_proxy function nextValue(index:int):*
		{
			var doc:DisplayObjectContainer = DisplayObjectContainer(this._target);
			return new DisplayQuery(doc.getChildAt(index - 1));
		}

	}
}