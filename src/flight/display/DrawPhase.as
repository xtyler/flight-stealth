/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	public class DrawPhase
	{
		public static const DRAW:String = "draw";
		RenderPhase.registerPhase(DRAW, 50);
	}
}
