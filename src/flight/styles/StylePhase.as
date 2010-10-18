/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	import flight.display.RenderPhase;

	public class StylePhase
	{
		public static const STYLE:String = "style";
		RenderPhase.registerPhase(STYLE, 150);
	}
}
