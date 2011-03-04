/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;

	public class HorizontalLayout extends BoxLayout
	{
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			var measured:IBounds = target.measured;
			
			// vertical size
			var space:Number = childMargin.top + childMargin.bottom;
			if (verticalAlign == Align.JUSTIFY || !isNaN(percentHeight)) {
				measured.minHeight = measured.constrainHeight(childMin.height + space);
				measured.maxHeight = measured.constrainHeight(childMax.height + space);
			} else {
				space += childRect.height;
				if (measured.height < space) {
					measured.height = space;
					measured.minHeight = measured.constrainHeight(measured.height);
				}
			}
			
			// horizontal size
			if (last) {
				space = childMargin.left + childMargin.right;
			} else {
				space = childMargin.left + padding.horizontal;
				contentMargin.left = childMargin.right;
			}
			if (!isNaN(percentWidth)) {
				horizontalPercent += percentWidth;
				measured.width += space;
			} else {
				measured.width += childRect.width + space;
			}
			measured.minWidth += childRect.width + space;
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
			var size:Number;
			if (!isNaN(percentWidth)) {
				size = target.contentWidth - target.measured.minWidth;
				childRect.width = constrainChildWidth(size * percentWidth * (horizontalPercent < 1 ? 1 : 1/horizontalPercent));
			}
			if (!isNaN(percentHeight)) {
				size = contentRect.height - childMargin.top - childMargin.bottom;
				childRect.height = constrainChildHeight(size * percentHeight * (verticalPercent < 1 ? 1 : 1/verticalPercent));
			}
			
			// vertical layout
			switch (verticalAlign) {
				case Align.TOP:
					childRect.y = contentRect.y + childMargin.top;
					break;
				case Align.CENTER:
					childRect.y = contentRect.y + (childMargin.top + contentRect.height - childRect.height - childMargin.bottom) / 2;
					break;
				case Align.BOTTOM:
					childRect.y = contentRect.y + (contentRect.height - childRect.height - childMargin.bottom);
					break;
				case Align.JUSTIFY:
					childRect.y = contentRect.y + childMargin.top;
					childRect.height = contentRect.height - childMargin.top - childMargin.bottom;
					break;
			}
			
			// horizontal layout
			childRect.x = contentRect.x + childMargin.left;
			if (last) {
			} else {
				contentRect.left = childRect.x + childRect.width + padding.horizontal;
				contentMargin.left = childMargin.right;
			}
			
			switch (horizontalAlign) {
				case Align.CENTER:
					childRect.x += horizontalSpace / 2;
					break;
				case Align.RIGHT:
					childRect.x += horizontalSpace;
					break;
			}
		}
		
	}
}
