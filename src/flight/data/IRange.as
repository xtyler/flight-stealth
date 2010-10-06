/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	public interface IRange
	{
		function get min():Number;
		function set min(value:Number):void;
		
		function get max():Number;
		function set max(value:Number):void;
		
		function get position():Number;
		function set position(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function stepBackward():Number;
		
		function stepForward():Number;
		
	}
}
