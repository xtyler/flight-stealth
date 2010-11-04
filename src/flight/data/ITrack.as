/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	public interface ITrack extends IPosition
	{
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
		function stepBackward():Number;
		
		function stepForward():Number;
		
		function pageBackward():Number;
		
		function pageForward():Number;
	}
}
