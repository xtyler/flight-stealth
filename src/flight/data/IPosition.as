/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	public interface IPosition extends IRange
	{
		function get value():Number;
		function set value(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
	}
}
