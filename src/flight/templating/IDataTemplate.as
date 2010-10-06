/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.templating
{
	public interface IDataTemplate
	{
		// typing to object again to test with PV3D
		// and other non-DisplayObject libraries
		function createDisplayObject(data:*):Object;
		
	}
}
