/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.IEventDispatcher;

	[Event(name="change", type="flash.events.Event")]
	
	public interface IRange extends IEventDispatcher
	{
		function get minimum():Number;
		function set minimum(value:Number):void;
		
		function get maximum():Number;
		function set maximum(value:Number):void;
		
		function get size():Number;
		function set size(value:Number):void;
	}
}
