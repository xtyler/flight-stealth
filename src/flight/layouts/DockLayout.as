/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import flight.styles.IStyleable;

	public class DockLayout extends BasicLayout
	{
		protected var tileMargin:Box = new Box();
		protected var tileRect:Rectangle = new Rectangle();
		protected var lastDock:String = null;
		protected var tiling:Boolean;
		
		protected var tileWidth:Number;
		protected var tileHeight:Number;
		
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(child).style;
			var dock:String = style.dock;
			if (style.tile && !dock) {
				dock = (style.tile == Align.LEFT || style.tile == Align.RIGHT) ? Align.TOP : dock = Align.RIGHT;
			}
			if (!dock) {
				super.measureChild(child, last);
				return;
			}
			
			var measured:IBounds = target.measured;
			var space:Number;
			if (!style.tile) {
				if (tiling) {
					if (lastDock == Align.LEFT || lastDock == Align.RIGHT) {
						measured.width += tileWidth;
						measured.minHeight -= padding.vertical;
					} else {
						measured.height += tileHeight;
						measured.minWidth -= padding.horizontal;
					}
					tiling = false;
				}
			} else if (!tiling || dock != lastDock) {
				contentMargin.clone(tileMargin);
				tileWidth = tileHeight = 0;
				tiling = true;
			}
			
			if (dock == Align.LEFT || dock == Align.RIGHT) {
				if (style.tile) {
					if (style.tile == Align.TOP) {
						tileMargin.top = childMargin.bottom;
						space = childMargin.top;
					} else {
						tileMargin.bottom = childMargin.top;
						space = childMargin.bottom;
					}
					tileHeight += space + childRect.height + padding.vertical;
					space = childRect.width + (dock == Align.LEFT ? childMargin.left : childMargin.right) + padding.horizontal;
					tileWidth = tileWidth >= space ? tileWidth : space;
					measured.minWidth = measured.constrainWidth(measured.width + tileWidth);
					measured.minHeight = measured.constrainHeight(measured.height + tileHeight);
				} else {
					if (dock == Align.LEFT) {
						contentMargin.left = childMargin.right;
						space = childMargin.left;
					} else {
						contentMargin.right = childMargin.left;
						space = childMargin.right;
					}
					measured.width += childRect.width + space + padding.horizontal;
					space = measured.height + childMargin.top + childMargin.bottom;
					measured.minWidth = measured.constrainWidth(measured.width);
					measured.minHeight = measured.constrainHeight(space + childMin.height);
					measured.maxHeight = measured.constrainHeight(space + childMax.height);
				}
			} else if (dock == Align.TOP || dock == Align.BOTTOM) {
				if (style.tile) {
					if (style.tile == Align.LEFT) {
						tileMargin.left = childMargin.right;
						space = childMargin.left;
					} else {
						tileMargin.right = childMargin.left;
						space = childMargin.right;
					}
					tileWidth += childRect.width + space + padding.horizontal;
					space = childRect.height + (dock == Align.TOP ? childMargin.top : childMargin.bottom) + padding.vertical;
					tileHeight = tileHeight >= space ? tileHeight : space;
					measured.minWidth = measured.constrainWidth(measured.width + tileWidth);
					measured.minHeight = measured.constrainHeight(measured.height + tileHeight);
				} else {
					if (dock == Align.TOP) {
						contentMargin.top = childMargin.bottom;
						space = childMargin.top;
					} else {
						contentMargin.bottom = childMargin.top;
						space = childMargin.bottom;
					}
					measured.height += childRect.height + space + padding.vertical;
					space = measured.width + childMargin.left + childMargin.right;
					measured.minHeight = measured.constrainHeight(measured.height);
					measured.minWidth = measured.constrainWidth(space + childMin.width);
					measured.maxWidth = measured.constrainWidth(space + childMax.width);
				}
			} else {	// if (dock == JUSTIFY) {
				space = measured.width + childMargin.left + childMargin.right;
				measured.minWidth = measured.constrainWidth(space + childMin.width);
				measured.maxWidth = measured.constrainWidth(space + childMax.width);
				
				space = measured.height + childMargin.top + childMargin.bottom;
				measured.minHeight = measured.constrainHeight(space + childMin.height);
				measured.maxHeight = measured.constrainHeight(space + childMax.height);
			}
			
			if (last) {
				// remove the last pad and add the last margin
				switch (lastDock) {
					case Align.LEFT : measured.minWidth += childMargin.right - padding.horizontal; break;
					case Align.TOP : measured.minHeight += childMargin.bottom - padding.vertical; break;
					case Align.RIGHT : measured.minWidth += childMargin.left - padding.horizontal; break;
					case Align.BOTTOM : measured.minHeight += childMargin.top - padding.vertical; break;
				}
				lastDock = null;
				tiling = false;
			} else {
				lastDock = dock;
			}
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(child).style;
			var dock:String = style.dock;
			if (style.tile && !dock) {
				dock = (style.tile == Align.LEFT || style.tile == Align.RIGHT) ? Align.TOP : dock = Align.RIGHT;
			}
			if (!dock) {
				super.updateChild(child, last);
				return;
			}
			
			if (!style.tile) {
				tiling = false;
				dockChild(style, dock, contentRect, childMargin);
				updateArea(style, dock, contentRect, contentMargin);
			} else {
				if (!tiling || dock != lastDock) {
					tiling = true;
					contentMargin.clone(tileMargin);
					tileRect.x = contentRect.x;
					tileRect.y = contentRect.y;
					tileRect.width = contentRect.width;
					tileRect.height = contentRect.height;
				}
				
				dockChild(style, style.tile, tileRect, childMargin);
				updateArea(style, style.tile, tileRect, tileMargin);
				updateArea(style, dock, contentRect, contentMargin);
			}
			
			if (last) {
				lastDock = null;
				tiling = false;
			} else {
				lastDock = dock;
			}
		}
		
		protected function dockChild(style:Object, dock:String, area:Rectangle, margin:Box):void
		{
			switch (dock) {
				case Align.LEFT :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					if (!style.tile) {
						childRect.height = area.height - margin.top - margin.bottom;
					} else if (dock == Align.BOTTOM) {
						childRect.y = area.y + area.height - childRect.height - margin.bottom;
					}
					break;
				case Align.TOP :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					if (!style.tile) {
						childRect.width = area.width - margin.left - margin.right;
					} else if (dock == Align.RIGHT) {
						childRect.x = area.x + area.width - childRect.width - margin.right;
					}
					break;
				case Align.RIGHT :
					childRect.x = area.x + area.width - childRect.width - margin.right;
					childRect.y = area.y + margin.top;
					if (!style.tile) {
						childRect.height = area.height - margin.top - margin.bottom;
					} else if (dock == Align.BOTTOM) {
						childRect.y = area.y + area.height - childRect.height - margin.bottom;
					}
					break;
				case Align.BOTTOM :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + area.height - childRect.height - margin.bottom;
					if (!style.tile) {
						childRect.width = area.width - margin.left - margin.right;
					} else if (dock == Align.RIGHT) {
						childRect.x = area.x + area.width - childRect.width - margin.right;
					}
					break;
				case Align.JUSTIFY :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					if (!style.tile) {
						childRect.height = area.height - margin.top - margin.bottom;
						childRect.width = area.width - margin.left - margin.right;
					}
					break;
			}
		}
		
		protected function updateArea(style:Object, dock:String, area:Rectangle, margin:Box):void
		{
			var pos:Number;
			switch (dock) {
				case Align.LEFT :
					if (area.left < (pos = childRect.x + childRect.width + padding.horizontal) ) {
						area.left = pos;
					}
					margin.left = childMargin.right;
					break;
				case Align.TOP :
					if (area.top < (pos = childRect.y + childRect.height + padding.vertical) ) {
						area.top = pos;
					}
					margin.top = childMargin.bottom;
					break;
				case Align.RIGHT :
					if (area.right > (pos = childRect.x - padding.horizontal) ) {
						area.right = pos;
					}
					margin.right = childMargin.left;
					break;
				case Align.BOTTOM :
					if (area.bottom > (pos = childRect.y - padding.vertical) ) {
						area.bottom = pos;
					}
					margin.bottom = childMargin.top;
					break;
			}
		}
	}
}
