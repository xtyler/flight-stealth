/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class CentralEvent extends Event
	{
		public function CentralEvent(type:String, target:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_type = type;
			if (!(_target is IEventDispatcher) || _target is CentralDispatcher) {
				_target = target;
				type = CentralDispatcher.getTargetType(type, target);
			}
			super(type, bubbles, cancelable);
		}

		override public function get type():String { return _type; }
		private var _type:String;

		override public function get target():Object { return super.target ? _target || super.target : null; }
		private var _target:Object;
		
		override public function clone():Event
		{
			var constructor:Class = Object(this).constructor;
			return new constructor(type, bubbles, cancelable);
		}
	}
}
