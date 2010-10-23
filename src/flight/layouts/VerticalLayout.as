/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	
	public class VerticalLayout extends Layout
	{
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			var measured:IBounds = target.measured;
			
			// horizontal size
			var space:Number = childMargin.left + childMargin.right;
			if (horizontalAlign == Align.JUSTIFY || !isNaN(percentWidth)) {
				measured.minWidth = measured.constrainWidth(childMin.width + space);
				measured.maxWidth = measured.constrainWidth(childMax.width + space);
			} else {
				space += childRect.width;
				if (measured.width < space) {
					measured.width = space;
					measured.minWidth = measured.constrainWidth(measured.width);
				}
			}
			
			// vertical size
			if (last) {
				space = childMargin.top + childMargin.bottom;
			} else {
				space = childMargin.top + padding.vertical;
				contentMargin.top = childMargin.bottom;
			}
			if (!isNaN(percentHeight)) {
				percentVertical += percentHeight;
				measured.height += space;
			} else {
				measured.height += childRect.height + space;
			}
			measured.minHeight += childRect.height + space;
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!isNaN(percentWidth)) {
				childRect.width = constrainChildWidth(contentRect.width * percentWidth * (percentHorizontal < 1 ? 1 : 1/percentHorizontal));
			}
			if (!isNaN(percentHeight)) {
				childRect.height = constrainChildHeight(contentRect.height * percentHeight * (percentVertical < 1 ? 1 : 1/percentVertical));
			}
			
			// horizontal layout
			switch (horizontalAlign) {
				case Align.LEFT:
					childRect.x = contentRect.x + childMargin.left;
					break;
				case Align.CENTER:
					childRect.x = contentRect.x + (childMargin.left + contentRect.width - childRect.width - childMargin.right) / 2;
					break;
				case Align.RIGHT:
					childRect.x = contentRect.x + (contentRect.width - childRect.width - childMargin.right);
					break;
				case Align.JUSTIFY:
					childRect.x = contentRect.x + childMargin.left;
					childRect.width = contentRect.width - childMargin.left - childMargin.right;
					break;
			}
			
			// vertical layout
			childRect.y = contentRect.y + childMargin.top;
			if (last) {
			} else {
				contentRect.top = childRect.y + childRect.height + padding.vertical;
				contentMargin.top = childMargin.bottom;
			}
		}
		
	}
}
