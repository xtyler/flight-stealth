/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * A simple box-model layout element containing size and bounds logic,
	 * including measured and explicit sizing.
	 */
	public interface ILayoutBounds extends IBounds
	{
		
		/**
		 * Specifies whether this instance will participate in layout or will
		 * remain freeform. If false its size and position may be controlled
		 * by the layout, otherwise it determines its own size and position.
		 * 
		 * @default		false
		 */
		function get freeform():Boolean;
		function set freeform(value:Boolean):void;
		
		/**
		 * The actual x position of the bounds relative to the local coordinates
		 * of the parent. Explicitly set values may be overridden by layout.
		 * 
		 * @default		0
		 */
		function get x():Number;
		function set x(value:Number):void;
		
		/**
		 * The actual y position of the bounds relative to the local coordinates
		 * of the parent. Explicitly set values may be overridden by layout.
		 * 
		 * @default		0
		 */
		function get y():Number;
		function set y(value:Number):void;
		
//		/**
//		 * The width of the bounds as a percentage of the parent's total size,
//		 * relative to the local coordinates of the parent. The percentWidth
//		 * is a value from 0 to 100, where 100 equals 100% of the parent's
//		 * total size.
//		 * 
//		 * @default		NaN
//		 */
//		function get percentWidth():Number;
//		function set percentWidth(value:Number):void;
		
//		/**
//		 * The height of the bounds as a percentage of the parent's total size,
//		 * relative to the local coordinates of the parent. The percentHeight
//		 * is a value from 0 to 100, where 100 equals 100% of the parent's
//		 * total size.
//		 * 
//		 * @default		NaN
//		 */
//		function get percentHeight():Number;
//		function set percentHeight(value:Number):void;
		
		/**
		 * The preferred width of the bounds relative to the local coordinates
		 * of this bounds instance. The preferredWidth represents the measured
		 * width or, if set, the explicit width.
		 */
		function get preferredWidth():Number;
		
		/**
		 * The preferred height of the bounds relative to the local coordinates
		 * of this bounds instance. The preferredHeight represents the measured
		 * height or, if set, the explicit height.
		 */
		function get preferredHeight():Number;
		
		
		/**
		 * The explicitly set bounds of this bounds instance. Actual values
		 * may differ from those explicitly set based on layout adjustments.
		 */
		function get explicit():IBounds;
		
		/**
		 * The default bounds of this bounds instance, primarily based on
		 * the measured size of this bounds contents.
		 */
		function get measured():IBounds;
		
		/**
		 * Allows layout positioning to be set, overriding explicit position.
		 * 
		 * @param		x			The bounds layout x coordinate.
		 * @param		y			The bounds layout y coordinate.
		 */
		function setLayoutPosition(x:Number, y:Number):void;
		
		/**
		 * Allows layout sizing to be set, overriding explicit size.
		 * 
		 * @param		width		The bounds layout width.
		 * @param		height		The bounds layout height.
		 */
		function setLayoutSize(width:Number, height:Number):void;
		
		/**
		 * Calculates a bounding rectangle surrounding the layout based on the
		 * supplied width and height, relative to the local coordinates of the
		 * parent. The width and height can be any dimensions desired, such as
		 * min or preferred, defaulting to the actual width and height of the
		 * layout if no values are supplied.
		 * 
		 * @param		width		The layout width around which to calculate
		 * 							a bounding rectangle.
		 * @param		height		The layout width around which to calculate
		 * 							a bounding rectangle.
		 * @return					The bounding rectangle in the parent's
		 * 							coordinates. Note that the rectangle
		 * 							instance returned may be singular to this
		 * 							layout for purposes of reuse.
		 */
		function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		
		// TODO: implement baseline and anchor features
		
//		/**
//		 * The y coordinate of the baseline of this bounds instance, primarily
//		 * based on the first line of text of this bounds contents.
//		 */
//		function get baseline():Number;
//		function set baseline(value:Number):void;
		
//		/**
//		 * A horizontal anchor in pixels from the left edge of this bounds
//		 * instance to the parent's left edge.
//		 * 
//		 * @default		NaN
//		 */
//		function get left():Number;
//		
//		/**
//		 * A vertical anchor in pixels from the top edge of this bounds
//		 * instance to the parent's top edge.
//		 * 
//		 * @default		NaN
//		 */
//		function get top():Number;
//		
//		/**
//		 * A horizontal anchor in pixels from the right edge of this bounds
//		 * instance to the parent's right edge.
//		 * 
//		 * @default		NaN
//		 */
//		function get right():Number;
//		
//		/**
//		 * A vertical anchor in pixels from the bottom edge of this bounds
//		 * instance to the parent's bottom edge.
//		 * 
//		 * @default		NaN
//		 */
//		function get bottom():Number;
//		
//		/**
//		 * A horizontal anchor as a percentage from the percent-width of this
//		 * bounds instance to the percent-width of the parent. The horizontal
//		 * anchor is a percentage from 0 to 1, where 1 equals 100% width, or
//		 * fully anchored to the right.
//		 * 
//		 * @default		NaN
//		 */
//		function get horizontal():Number;
//		
//		/**
//		 * A vertical anchor as a percentage from the percent-height of this
//		 * bounds instance to the percent-height of the parent. The vertical
//		 * anchor is a percentage from 0 to 1, where 1 equals 100% height, or
//		 * fully anchored to the bottom.
//		 * 
//		 * @default		NaN
//		 */
//		function get veritical():Number;
		
		/**
		 * The Flash display object associated with these layout properties.
		 * This reference is often self assigned to the implementing display
		 * class instance.
		 */
		function get display():DisplayObject;
	}
}
