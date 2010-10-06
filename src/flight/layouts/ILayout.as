/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * This interface is used to Integrate custom layouts into the Stealth layout and measurement system.
	 * You must implement this interface when creating a custom layout.
	 * 
	 * @alpha
	 */
	public interface ILayout
	{
		
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
		
		function measure(children:Array):Point;
		
		function update(children:Array, rectangle:Rectangle):void;
	}
}
