/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	import flight.utils.RenderPhase;

	public class InvalidationEvent extends Event
	{
		public static const VALIDATE:String = "validate";
		RenderPhase.registerPhase(VALIDATE, InvalidationEvent, 0);
		
		public function InvalidationEvent(type:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type, bubbles, cancelable);
		}
	}
}
