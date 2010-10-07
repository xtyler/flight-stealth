/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flight.styles.IStateful;

	import mx.core.IDataRenderer;

	/**
	 * @alpha
	 **/
	public interface ISkinnable extends IStateful, IDataRenderer
	{
		/*
		function get data():Object;
		function set data(value:Object):void;
		*/
		
		/**
		 * The component's current state.
		 **/
		
//		function get currentState():String;
//		function set currentState(value:String):void;
		
		/**
		 * An Object to be used for the component's visual display.
		 * This is commonly an MXML class extending flight.skins.Skin or a custom MovieClip.
		 * However, any DisplayObject or ISkin implementation may be used.
		 */
		function get skin():Object;
		function set skin(value:Object):void;
	}
}
