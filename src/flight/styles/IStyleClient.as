/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	/**
	 * A styleable element with identifiers and methods that allow it to collect
	 * and use attributes considered as style data.
	 */
	public interface IStyleClient extends IStyle
	{
		/**
		 * The style object where dynamic style data is stored.
		 */
		function get style():IStyle;
	}
	
}
