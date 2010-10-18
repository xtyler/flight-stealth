/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class XYLayout extends Layout
	{
		
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(0, 0);
			for each(var item:Object in children) {
				var xp:Number = item.x + resolveWidth(item);
				var yp:Number = item.y + resolveHeight(item);
				point.x = Math.max(point.x, xp);
				point.y = Math.max(point.y, yp);
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
		}
		
	}
}
