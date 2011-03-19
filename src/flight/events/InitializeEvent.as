/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.utils.Invalidation;

	public class InitializeEvent extends InvalidationEvent
	{
		public static const READY:String = "ready";
		Invalidation.registerPhase(READY, InitializeEvent, -10);
		
		public static const CREATE:String = "create";
		Invalidation.registerPhase(CREATE, InitializeEvent, 250);
		
		public static const INITIALIZE:String = "initialize";
		Invalidation.registerPhase(INITIALIZE, InitializeEvent, 300);
		
		public function InitializeEvent(type:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type, bubbles, cancelable);
		}
	}
}
