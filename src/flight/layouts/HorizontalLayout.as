/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class HorizontalLayout extends Layout
	{
		
		public var gap:Number = 5;
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(gap / 2, 0);
			for each(var child:Object in children) {
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				point.x += width + gap;
				point.y = Math.max(point.y, height);
			}
			point.x -= gap / 2;
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			var position:Number = gap / 2;
			var length:int = children.length;
			for (var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				child.x = position;
				child.y = rectangle.height / 2 - height / 2;
				position += width + gap;
			}
		}
		
	}
}
