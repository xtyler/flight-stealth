/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.events.IEventDispatcher;
	
	import flight.data.IDataRenderer;
	import flight.styles.IStateful;
	
	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public interface ISkinnable extends IEventDispatcher, IDataRenderer, IStateful
	{
		function get skin():ISkin;
		function set skin(value:ISkin):void;
	}
}
