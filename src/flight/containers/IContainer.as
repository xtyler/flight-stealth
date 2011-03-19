/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.collections.IList;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;

	public interface IContainer extends IMeasureable
	{
		function get content():IList;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		/**
		 * The width of the layout's content in pixels relative to the local
		 * coordinates of this layout instance. The width represents a
		 * virtual size, allowing content of the layout to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get contentWidth():Number;
		
		/**
		 * The height of the layout's content in pixels relative to the local
		 * coordinates of this layout instance. The height represents a
		 * virtual size, allowing content of the layout to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get contentHeight():Number;
	}
}
