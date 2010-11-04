/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	public class SkinEvent extends Event
	{
		public static const SKIN_PART_CHANGE:String = "skinPartChange";
		
		public function SkinEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
								  skinPart:String = "", oldValue:InteractiveObject = null, newValue:InteractiveObject = null)
		{
			super(type, bubbles, cancelable);
			_skinPart = skinPart;
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		public function get partName():String { return _skinPart; }
		private var _skinPart:String;
		
		public function get oldValue():InteractiveObject { return _oldValue; }
		private var _oldValue:InteractiveObject;
		
		public function get newValue():InteractiveObject { return _newValue; }
		private var _newValue:InteractiveObject;
		
		override public function clone():Event
		{
			return new SkinEvent(type, bubbles, cancelable, _skinPart, _oldValue, _newValue);
		}
	}
}
