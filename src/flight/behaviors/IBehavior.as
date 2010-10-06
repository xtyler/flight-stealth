/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	
	import flash.events.IEventDispatcher;
	
	/**
	 * @beta
	 */
	public interface IBehavior
	{
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
	}
}
