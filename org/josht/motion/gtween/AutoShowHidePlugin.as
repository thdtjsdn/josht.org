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
package org.josht.motion.gtween
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	
	public class AutoShowHidePlugin implements IGTweenPlugin
	{
		public static var enabled:Boolean = true;
		
		protected static var instance:AutoShowHidePlugin;
		
		protected static var tweenProperties:Array = ["alpha"];
		
		/**
		 * Installs this plugin for use with all GTween instances.
		 **/
		public static function install():void {
			if(instance)
			{
				return;
			}
			instance = new AutoShowHidePlugin();
			GTween.installPlugin(instance,tweenProperties);
		}
		
		public function AutoShowHidePlugin()
		{
		}
		
		public function init(tween:GTween, name:String, value:Number):Number
		{
			return value;
		}
		
		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number
		{
			if((tween.pluginData.AutoHideEnabled == null && enabled) || tween.pluginData.AutoShowHideEnabled)
			{
				var targetVisible:Boolean = value > 0;
				if(tween.target.visible != targetVisible)
				{
					tween.target.visible = targetVisible;
				}
			}
			return value;
		}
	}
}