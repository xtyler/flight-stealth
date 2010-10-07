/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	public class LayoutPhase
	{
		public static const LAYOUT:String = "layout";
		RenderPhase.registerPhase(LAYOUT, 80);
		
		public static const MEASURE:String = "measure";
		RenderPhase.registerPhase(MEASURE, 100);
		
		public static const RESIZE:String = "resize";
		RenderPhase.registerPhase(RESIZE, 110);
		
		public static const MOVE:String = "move";
		RenderPhase.registerPhase(MOVE, 120);
	}
}
