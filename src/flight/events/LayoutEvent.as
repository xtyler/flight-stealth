/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.utils.Invalidation;

	public class LayoutEvent extends InvalidationEvent
	{
		public static const RESIZE:String = "resize";
		Invalidation.registerPhase(RESIZE, LayoutEvent, 70);
		
		public static const MOVE:String = "move";
		Invalidation.registerPhase(MOVE, LayoutEvent, 80);
		
		public static const LAYOUT:String = "layout";
		Invalidation.registerPhase(LAYOUT, LayoutEvent, 90, false);
		
		public static const MEASURE:String = "measure";
		Invalidation.registerPhase(MEASURE, LayoutEvent, 100);
		
		public function LayoutEvent(type:String, bubbles:Boolean, cancelable:Boolean)
		{
			super(type, bubbles, cancelable);
		}
	}
}
