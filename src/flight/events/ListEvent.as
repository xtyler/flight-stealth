/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	public class ListEvent extends CentralEvent
	{
		public static const LIST_CHANGE:String = "listChange";
		
		
		public function ListEvent(type:String, target:Object = null, bubbles:Boolean = false, cancelable:Boolean = false,
								  added:* = null, removed:* = null, from:int = -1, to:int = -1)
		{
			super(type, target, bubbles, cancelable);
			
			_added = added;
			_removed = removed;
			_from = from;
			_to = to;
		}
		
		public function get added():* { return _added; }
		private var _added:*;
		
		public function get removed():* { return _removed; }
		private var _removed:*;
		
		public function get from():int { return _from; }
		private var _from:int;
		
		public function get to():int { return _to; }
		private var _to:int;
		
		override public function clone():Event
		{
			return new ListEvent(type, target, bubbles, cancelable, _added, _removed, _from, _to);
		}
	}
}
