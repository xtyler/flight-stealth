/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.utils.RenderPhase;

	public class DrawEvent extends InvalidationEvent
	{
		public static const DRAW:String = "draw";
		RenderPhase.registerPhase(DRAW, DrawEvent, 50);
		
		public function DrawEvent(type:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type, bubbles, cancelable);
		}
	}
}
