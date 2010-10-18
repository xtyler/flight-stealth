/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.IEventDispatcher;
	
	public interface IRange extends IEventDispatcher
	{
		function get min():Number;
		function set min(value:Number):void;
		
		function get max():Number;
		function set max(value:Number):void;
		
		function get value():Number;
		function set value(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function stepBackward():Number;
		
		function stepForward():Number;
	}
}
