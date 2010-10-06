/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	
	/**
	 * @alpha
	 */
	public interface IStateful
	{
		function get states():Array;
		function set states(value:Array):void;
		
		/*
		function get transitions():Array;
		function set transitions(value:Array):void;
		*/
		function get currentState():String;
		function set currentState(value:String):void;
		
		//function hasState(state:String):Boolean;
		
	}
}
