/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.styles.resolveStyle;
	
	public class DockLayout extends Layout
	{
		
		static public const NONE:String = null;
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		static public const TOP:String = "top";
		static public const BOTTOM:String = "bottom";
		static public const FILL:String = "fill";
		static public const CENTER:String = "center";
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var gap:Number = 5;
			var point:Point = new Point(gap, 0);
			for each(var child:Object in children) {
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				point.x += width + gap;
				point.y = Math.max(point.y, height);
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			var length:int = children.length;
			for (var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				var dock:String = resolveStyle(child, "dock", null, NONE) as String;
				var align:String = resolveStyle(child, "align", null, NONE) as String;
				switch (dock) {
					case LEFT :
						child.x = rectangle.x;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(width, rectangle.height);
						} else if (align == BOTTOM) {
							child.y = rectangle.y + rectangle.height - height;
						}
						break;
					case TOP :
						child.x = rectangle.x;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(rectangle.width, height)
						} else if (align == RIGHT) {
							child.x = rectangle.x + rectangle.width - width;
						}
						break;
					case RIGHT :
						child.x = rectangle.x + rectangle.width - width;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(width, rectangle.height);
						} else if (align == BOTTOM) {
							child.y = rectangle.y + rectangle.height - height;
						}
						break;
					case BOTTOM :
						child.x = rectangle.x;
						child.y = rectangle.y + rectangle.height - height;
						if (align == NONE) {
							child.setSize(rectangle.width, height);
						} else if (align == RIGHT) {
							child.x = rectangle.x + rectangle.width - width;
						}
						break;
					case FILL :
						child.x = rectangle.x;
						child.y = rectangle.y;
						child.setSize(rectangle.width, rectangle.height)
						break;
					case CENTER :
					default:
						child.x = rectangle.width / 2 - width / 2;
						child.y = rectangle.height / 2 - height / 2;
						break;
				}
			}
		}
		
	}
}
