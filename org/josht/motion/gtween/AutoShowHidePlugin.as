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