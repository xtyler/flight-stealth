/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;

	import flight.styles.IStyleable;

	public class BasicLayout extends Layout
	{
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
				} else if ( !isNaN(style.horizontal) ) {
					space = style.left - offsetX;
					measured.minWidth = measured.constrainWidth((space + childMin.width)/style.horizontal);
					measured.maxWidth = measured.constrainWidth((space + childMax.width)/style.horizontal);
				} else {
					space = style.left;
					measured.minWidth = measured.constrainWidth(space + childRect.width);
				}
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					space = style.right + offsetX;
					measured.minWidth = measured.constrainWidth((space + childMin.width)/style.horizontal);
					measured.maxWidth = measured.constrainWidth((space + childMax.width)/style.horizontal);
				} else {
					space = style.right;
					measured.minWidth = measured.constrainWidth(offsetX + childRect.width);
				}
			} else if ( !isNaN(style.horizontal) ) {
				measured.minWidth = measured.constrainWidth(Math.abs(offsetX) + childRect.width);
			} else {
				measured.minWidth = measured.constrainWidth(childRect.x + childRect.width);
			}
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					space = style.top + style.bottom;
					measured.minHeight = measured.constrainHeight(space + childMin.height);
					measured.maxHeight = measured.constrainHeight(space + childMax.height);
				} else if ( !isNaN(style.vertical) ) {
					space = style.top - offsetY;
					measured.minHeight = measured.constrainHeight((space + childMin.height)/style.vertical);
					measured.maxHeight = measured.constrainHeight((space + childMax.height)/style.vertical);
				} else {
					space = style.top;
					measured.minHeight = measured.constrainHeight(space + childRect.height);
				}
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					space = style.bottom + offsetY;
					measured.minHeight = measured.constrainHeight((space + childMin.height)/style.vertical);
					measured.maxHeight = measured.constrainHeight((space + childMax.height)/style.vertical);
				} else {
					space = style.bottom;
					measured.minHeight = measured.constrainHeight(space + childRect.height);
				}
			} else if ( !isNaN(style.vertical) ) {
				measured.minHeight = measured.constrainHeight(Math.abs(offsetY) + childRect.height);
			} else {
				measured.minHeight = measured.constrainHeight(childRect.y + childRect.height);
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
					childRect.width = target.width - style.left - style.right;
				} else if ( !isNaN(style.horizontal) ) {
					childRect.width = (style.horizontal * target.width) - style.left + offsetX;
				} else if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * (target.width - style.left);
				}
				
				childRect.x = style.left;
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					childRect.width = (style.horizontal * target.width) - style.right - offsetX;
				} else if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * (target.width - style.right);
				}
				
				childRect.x = target.width - childRect.width - style.right;
			} else if ( !isNaN(style.horizontal) ) {
				if (!isNaN(percentWidth)) {
					childRect.width = percentWidth * target.width;
				}
				
				childRect.x = style.horizontal * (target.width - childRect.width) + offsetX;
			}
			
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					childRect.height = target.height - style.top - style.bottom;
				} else if ( !isNaN(style.vertical) ) {
					childRect.height = (style.vertical * target.height) - style.top + offsetY;
				} else if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * (target.height - style.top);
				}
				
				childRect.y = style.top;
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					childRect.height = (style.vertical * target.height) - style.bottom - offsetY;
				} else if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * (target.height - style.bottom);
				}
				
				childRect.y = target.height - childRect.height - style.bottom;
			} else if ( !isNaN(style.vertical) ) {
				if (!isNaN(percentHeight)) {
					childRect.height = percentHeight * target.height;
				}
				
				childRect.y = style.vertical * (target.height - childRect.height) + offsetY;
			}
		}
		
	}
}
