/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;

	public interface IBehavior
	{
		function get type():String;
		function set type(value:String):void;
		
		function get target():InteractiveObject;
		function set target(value:InteractiveObject):void;
	}
}
