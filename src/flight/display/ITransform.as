/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * Coordinate transformation defining position, scale and rotation, also
	 * including basic width and height values.
	 */
	public interface ITransform
	{
//		/**
//		 * A transform coordinate space that contains this transform.
//		 */
//		function get parentTransform():ITransform;
//		function set parentTransform(value:ITransform):void;
		
		/**
		 * The x coordinate of the transform relative to the local coordinates
		 * of the parent. The x coordinate represents an offset from the origin
		 * of the transform and <em>not</em> the transformX position.
		 * 
		 * @default		0
		 */
		function get x():Number;
		function set x(value:Number):void;
		
		/**
		 * The y coordinate of the transform relative to the local coordinates
		 * of the parent. The y coordinate represents an offset from the origin
		 * of the transform and <em>not</em> the transformY position.
		 * 
		 * @default		0
		 */
		function get y():Number;
		function set y(value:Number):void;
		
		/**
		 * The x coordinate of the transform center relative to the local
		 * coordinates of this transform instance. The coordinate represents
		 * the point around which scaling and rotation occur.
		 * 
		 * @default		0
		 */
		function get transformX():Number;
		function set transformX(value:Number):void;
		
		/**
		 * The y coordinate of the transform center relative to the local
		 * coordinates of this transform instance. The coordinate represents
		 * the point around which scaling and rotation occur.
		 * 
		 * @default		0
		 */
		function get transformY():Number;
		function set transformY(value:Number):void;
		
		/**
		 * The actual width of the transform in pixels relative to the local
		 * coordinates of this transform instance. The width represents a
		 * virtual size, allowing content of the transform to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * The actual height of the transform in pixels relative to the local
		 * coordinates of this transform instance. The height represents a
		 * virtual size, allowing content of the transform to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get height():Number;
		function set height(value:Number):void;
		
		/**
		 * The x scaling factor of the transform as applied from the transform
		 * point. The scaleX is a percentage from 0 to 1, where 1 equals
		 * 100% scale.
		 * 
		 * @default		1.0
		 */
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		/**
		 * The y scaling factor of the transform as applied from the transform
		 * point. The scaleY is a percentage from 0 to 1, where 1 equals
		 * 100% scale.
		 * 
		 * @default		1.0
		 */
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		/**
		 * The rotation of the transform in degrees as applied from the
		 * the transform point. The rotation is a value from 0 to 180 for
		 * clockwise rotation or from 0 to -180 for counterclockwise rotation.
		 * 
		 * @default		0
		 */
		function get rotation():Number;
		function set rotation(value:Number):void;

		/**
		 * The matrix that represents the position, scale and rotation of this
		 * transform in the the local coordinates of the parent.
		 */
		function get matrix():Matrix;
		function set matrix(value:Matrix):void;
		
		/**
		 * The Flash display object associated with this transform. This
		 * reference is often self-assigned to the implementing display class
		 * instance.
		 */
		function get display():DisplayObject;
		
	}
}
