/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	[Event(name="resize", type="flash.events.Event")]
	
	public interface IMeasureable extends IEventDispatcher
	{
		/**
		 * The default bounds of this layout instance, based on the measured
		 * size of this layout's contents.
		 */
		function get measured():IBounds;
		
		/**
		 * The Flash display object associated with the layout. This
		 * reference is often self assigned to the implementing display
		 * class.
		 */
		function get display():DisplayObject;
	}
}
