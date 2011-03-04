/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;

	import flight.styles.IStyleable;

	public class BasicLayout extends BoxLayout
	{
		public function BasicLayout()
		{
			registerStyle("left");
			registerStyle("top");
			registerStyle("right");
			registerStyle("bottom");
			registerStyle("horizontal");
			registerStyle("vertical");
			registerStyle("offsetX");
			registerStyle("offsetY");
		}
		
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(child).style;
			var offsetX:Number = !isNaN(style.offsetX) ? style.offsetX : 0;
			var offsetY:Number = !isNaN(style.offsetY) ? style.offsetY : 0;
			var measured:IBounds = target.measured;
			var space:Number;
			
			if ( !isNaN(style.left) ) {
				if ( !isNaN(style.right) ) {
					space = style.left + style.right;
					measured.minWidth = measured.constrainWidth(space + childMin.width);
					measured.maxWidth = measured.constrainWidth(space + childMax.width);
					space = space + childMin.width;
				} else if ( !isNaN(style.horizontal) ) {
					space = style.left - offsetX;
					measured.minWidth = measured.constrainWidth((space + childMin.width)/style.horizontal);
					measured.maxWidth = measured.constrainWidth((space + childMax.width)/style.horizontal);
					space = (space + childMin.width)/style.horizontal;
				} else {
					space = style.left;
					measured.minWidth = measured.constrainWidth(space + childRect.width);
					space = space + childRect.width;
				}
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					space = style.right + offsetX;
					measured.minWidth = measured.constrainWidth((space + childMin.width)/style.horizontal);
					measured.maxWidth = measured.constrainWidth((space + childMax.width)/style.horizontal);
					space = (space + childMin.width)/style.horizontal;
				} else {
					space = style.right;
					measured.minWidth = measured.constrainWidth(offsetX + childRect.width);
					space = offsetX + childRect.width;
				}
			} else if ( !isNaN(style.horizontal) ) {
				measured.minWidth = measured.constrainWidth(Math.abs(offsetX) + childRect.width);
				space = Math.abs(offsetX) + childRect.width;
			} else {
				measured.minWidth = measured.constrainWidth(childRect.x + childRect.width);
				space = childRect.x + childRect.width;
			}
			if (measured.width < space) {
				measured.width = space;
			}
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					space = style.top + style.bottom;
					measured.minHeight = measured.constrainHeight(space + childMin.height);
					measured.maxHeight = measured.constrainHeight(space + childMax.height);
					space = space + childMin.height;
				} else if ( !isNaN(style.vertical) ) {
					space = style.top - offsetY;
					measured.minHeight = measured.constrainHeight((space + childMin.height)/style.vertical);
					measured.maxHeight = measured.constrainHeight((space + childMax.height)/style.vertical);
					space = (space + childMin.height)/style.vertical;
				} else {
					space = style.top;
					measured.minHeight = measured.constrainHeight(space + childRect.height);
					space = space + childRect.height;
				}
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					space = style.bottom + offsetY;
					measured.minHeight = measured.constrainHeight((space + childMin.height)/style.vertical);
					measured.maxHeight = measured.constrainHeight((space + childMax.height)/style.vertical);
					space = (space + childMin.height)/style.vertical;
				} else {
					space = style.bottom;
					measured.minHeight = measured.constrainHeight(space + childRect.height);
					space = space + childRect.height;
				}
			} else if ( !isNaN(style.vertical) ) {
				measured.minHeight = measured.constrainHeight(Math.abs(offsetY) + childRect.height);
				space = Math.abs(offsetY) + childRect.height;
			} else {
				measured.minHeight = measured.constrainHeight(childRect.y + childRect.height);
				space = childRect.y + childRect.height;
			}
			if (measured.height < space) {
				measured.height = space;
			}
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(child).style;
			var offsetX:Number = !isNaN(style.offsetX) ? style.offsetX : 0;
			var offsetY:Number = !isNaN(style.offsetY) ? style.offsetY : 0;
			if ( !isNaN(style.left) ) {
				if ( !isNaN(style.right) ) {
					childRect.width = target.contentWidth - style.left - style.right;
				} else if ( !isNaN(style.horizontal) ) {
					childRect.width = (style.horizontal * target.contentWidth) - style.left + offsetX;
				} else if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * (target.contentWidth - style.left);
				}
				
				childRect.x = style.left;
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					childRect.width = (style.horizontal * target.contentWidth) - style.right - offsetX;
				} else if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * (target.contentWidth - style.right);
				}
				
				childRect.x = target.contentWidth - childRect.width - style.right;
			} else if ( !isNaN(style.horizontal) ) {
				if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * target.contentWidth;
				}
				
				childRect.x = style.horizontal * (target.contentWidth - childRect.width) + offsetX;
			}
			
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					childRect.height = target.contentHeight - style.top - style.bottom;
				} else if ( !isNaN(style.vertical) ) {
					childRect.height = (style.vertical * target.contentHeight) - style.top + offsetY;
				} else if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * (target.contentHeight - style.top);
				}
				
				childRect.y = style.top;
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					childRect.height = (style.vertical * target.contentHeight) - style.bottom - offsetY;
				} else if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * (target.contentHeight - style.bottom);
				}
				
				childRect.y = target.contentHeight - childRect.height - style.bottom;
			} else if ( !isNaN(style.vertical) ) {
				if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * target.contentHeight;
				}
				
				childRect.y = style.vertical * (target.contentHeight - childRect.height) + offsetY;
			}
		}
		
	}
}
