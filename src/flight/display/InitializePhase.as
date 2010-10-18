/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	public class InitializePhase
	{
		public static const READY:String = "ready";
		RenderPhase.registerPhase(READY, -10);
		
		public static const INITIALIZE:String = "initialize";
		RenderPhase.registerPhase(INITIALIZE, 200);
		
		public static const CREATE:String = "create";
		RenderPhase.registerPhase(CREATE, 250);
		
	}
}
