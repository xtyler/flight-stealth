/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	/**
	 * A style object from which dynamic style data is retrieved and stored,
	 * utilizing identifiers and methods to select specific styles.
	 */
	public interface IStyle
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
		 * The elements type or class, allowing styles to target the element by
		 * its general type or inheritance.
		 */
    	function get elementType():String;
    	function set elementType(value:String):void;

		/**
		 * Retrieves style data under a specific property that has been set
		 * in this element's styling.
		 * 
		 * @param		property	The style property to retrive style data.
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
