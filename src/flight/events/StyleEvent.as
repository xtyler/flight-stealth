/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;
	
	public class StyleEvent extends Event
	{
		public static const STYLE_CHANGE:String = "styleChange";
		
		public function StyleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
								   source:Object = null, property:String = "", oldValue:Object = null, newValue:Object = null)
		{
			super(type, bubbles, cancelable);
			_source = source;
			_property = property;
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		public function get source():Object { return _source; }
		private var _source:Object;
		
		public function get property():String { return _property; }
		private var _property:String;
		
		public function get oldValue():Object { return _oldValue; }
		private var _oldValue:Object;
		
		public function get newValue():Object { return _newValue; }
		private var _newValue:Object;
		
		override public function clone():Event
		{
			return new StyleEvent(type, bubbles, cancelable, _source, _property, _oldValue, _newValue);
		}
	}
}
