/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics
{
	import flash.geom.Matrix;

	import flight.display.IDrawable;
	import flight.graphics.paint.IFill;
	import flight.graphics.paint.IStroke;

	public interface IGraphicShape extends IDrawable
	{
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get stroke():IStroke;
		function get fill():IFill;
		
		// TODO: transform can change frequently without path changing, extract transform out into the draw method? (post-update)
		function update(transform:Matrix = null):void;
	}
}
