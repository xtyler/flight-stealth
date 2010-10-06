/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	public interface IScroll extends IRange
	{
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
		function pageBackward():Number;
		
		function pageForward():Number;
	}
}
