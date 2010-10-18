/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	/**
	 * A styleable element with identifiers and methods that allow it to collect
	 * and use style data.
	 */
	public interface IStyleable
	{
		/**
		 * The instance name of the element, allowing styles to target the
		 * element by its unique ID.
		 */
		function get id():String;
		function set id(value:String):void;
		
		/**
		 * The style-defining tags of the element, allowing styles to target
		 * the element by one of its style tag names.
		 */
		function get styleName():String;
		function set styleName(value:String):void;
		
		/**
		 * The style object where dynamic style data is stored.
		 */
		function get style():Object;

		/**
		 * Retrieves style data under a specific property that has been set
		 * in this element's styling.
		 * 
		 * @param		property	The style property to retrieve style data.
		 * @return					The style data stored under the property.
		 */
		function getStyle(property:String):*;

		/**
		 * Sets style data under a specific property for this element,
		 * overriding data that has been previously set.
		 * 
		 * @param		property	The style property to set style data.
		 * @param		value		The style data to store under the property.
		 */
		function setStyle(property:String, value:*):void;
	}
	
}
