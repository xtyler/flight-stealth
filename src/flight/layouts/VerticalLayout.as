/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class VerticalLayout extends Layout
	{
		override public function measure():void
		{
			if (!target) return;
			
			target.measured.minWidth = paddingLeft + paddingRight;
			target.measured.minHeight = paddingTop + paddingBottom;
			target.measured.maxWidth = target.measured.maxHeight = 0xFFFFFF;
			
			for each (var child:DisplayObject in target.content) {
				var rect:Rectangle = child is ILayoutBounds ? ILayoutBounds(child).getLayoutRect() : child.getRect(child.parent);
				
				target.measured.minHeight += rect.height;
			}
		}
		
		override public function update():void
		{
		}
		
	}
}
