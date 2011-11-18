﻿package org.josht.media{	import flash.errors.IllegalOperationError;	import flash.events.Event;	import flash.events.IEventDispatcher;	import flash.media.Sound;	import flash.media.SoundTransform;	import flash.utils.Dictionary;
	/**	 * Provides a simple interface for adding event listeners that play sounds.	 * 	 * @author Josh Tynjala (joshblog.net) 	 */	public class SoundEventManager	{		private static const TARGET_TO_TYPES:Dictionary = new Dictionary(true);				public static var mute:Boolean = false;		public static var soundTransform:SoundTransform = new SoundTransform(1);				public static function attachSoundToEvent(target:IEventDispatcher, eventType:String, sound:Sound):void		{			if(TARGET_TO_TYPES[target] === undefined)			{				TARGET_TO_TYPES[target] = {};			}			const eventTypeToSoundClass:Object = TARGET_TO_TYPES[target];			if(eventTypeToSoundClass.hasOwnProperty(eventType))			{				//if it's the same sound, let's just ignore it				if(eventTypeToSoundClass[eventType] == sound)				{					return;				}				throw new IllegalOperationError("A sound is already registered to play when the specified target dispatches an event of type " + eventType); 			}						eventTypeToSoundClass[eventType] = sound;			//priority is int.MAX_VALUE so that another event handler for the			//same eventType won't clear the sounds before it plays.			target.addEventListener(eventType, eventHandler, false, int.MAX_VALUE, true);		}				public static function hasSoundForEvent(target:IEventDispatcher, eventType:String, sound:Sound = null):Boolean		{			if(TARGET_TO_TYPES[target] === undefined)			{				return false;			}			const eventTypeToSoundClass:Object = TARGET_TO_TYPES[target];			if(eventTypeToSoundClass.hasOwnProperty(eventType))			{				//if "sound" is null, then any attached sound will return true.				if(!sound)				{					return true;				}				//if not null, then the sound must match exactly (same object reference)				const existingSound:Sound = eventTypeToSoundClass[eventType];				return existingSound == sound;			}			return false;		}				public static function clearSoundForEvent(target:IEventDispatcher, eventType:String):void		{			if(TARGET_TO_TYPES[target] === undefined)			{				return;			}			const eventTypeToSoundClass:Object = TARGET_TO_TYPES[target];			if(!eventTypeToSoundClass.hasOwnProperty(eventType))			{				return;			}						delete eventTypeToSoundClass[eventType];			target.removeEventListener(eventType, eventHandler);						var stillHasEvents:Boolean = false;			for(var eventType:String in eventTypeToSoundClass)			{				stillHasEvents = true;				break;			}						if(!stillHasEvents)			{				delete TARGET_TO_TYPES[target];			}		}				public static function clearAllSoundsForTarget(target:IEventDispatcher):void		{			const eventTypeToSoundClass:Object = TARGET_TO_TYPES[target];			if(!eventTypeToSoundClass)			{				return;			}			for(var eventType:String in eventTypeToSoundClass)			{				target.removeEventListener(eventType, eventHandler);				delete eventTypeToSoundClass[eventType];			}						//no sounds, so let's get rid of the reference			delete TARGET_TO_TYPES[target];		}				private static function eventHandler(event:Event):void		{			if(mute)			{				return;			}						const eventTypeToSoundClass:Object = TARGET_TO_TYPES[event.currentTarget];			if(!eventTypeToSoundClass)			{				//may have been cleared in a high priority event handler				return;			}			const sound:Sound = Sound(eventTypeToSoundClass[event.type]);			sound.play(0, 0, soundTransform);		}	}}