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
		protected var dockMargin:Box = new Box();
		protected var tileRect:Rectangle = new Rectangle();
		protected var lastDock:String = null;
		protected var tiling:Boolean;
		
		protected var tileWidth:Number;
		protected var tileHeight:Number;
		
		private var validDockValues:Array = [Align.LEFT, Align.TOP, Align.RIGHT, Align.BOTTOM, Align.JUSTIFY];
		
		public function DockLayout()
		{
			registerStyle("dock");
			registerStyle("tile");
		}
		
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(child).style;
			var dock:String = style.dock;
			var tile:String = style.tile;
			if (tile) {
				if (tile == Align.LEFT || tile == Align.RIGHT) {
					if (dock != Align.BOTTOM) {
						dock = Align.TOP;
					}
				} else if (tile == Align.TOP || tile == Align.BOTTOM) {
					if (dock != Align.RIGHT) {
						dock = Align.LEFT;
					}
				} else {
					tile = null;
				}
			}
			if (!dock || validDockValues.indexOf(dock) == -1) {
				super.measureChild(child, last);
				return;
			}
			
			var measured:IBounds = target.measured;
			var space:Number;
			var m:String;
			if (!tile) {
				if (tiling) {
					if (lastDock == Align.LEFT || lastDock == Align.RIGHT) {
						measured.width += tileWidth;
						measured.minHeight -= padding.vertical;
					} else {
						measured.height += tileHeight;
						measured.minWidth -= padding.horizontal;
					}
					childMargin.merge(dockMargin.clone(contentMargin));
					tiling = false;
				}
			} else if (!tiling || dock != lastDock) {
				contentMargin.clone(dockMargin);
				tileWidth = tileHeight = 0;
				tiling = true;
			}
			
			if (dock == Align.LEFT || dock == Align.RIGHT) {
				m = dock == Align.LEFT ? Align.RIGHT : Align.LEFT;
				if (tile) {
					if (tile == Align.TOP) {
						contentMargin.top = childMargin.bottom;
						space = childMargin.top;
					} else {
						contentMargin.bottom = childMargin.top;
						space = childMargin.bottom;
					}
					tileHeight += space + childRect.height + padding.vertical;
					space = childRect.width + childMargin[dock] + padding.horizontal;
					if (tileWidth + dockMargin[dock] < space + childMargin[m]) {
						tileWidth = space;
						dockMargin[dock] = childMargin[m];
					}
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
				m = dock == Align.TOP ? Align.BOTTOM : Align.TOP;
				if (tile) {
					if (tile == Align.LEFT) {
						contentMargin.left = childMargin.right;
						space = childMargin.left;
					} else {
						contentMargin.right = childMargin.left;
						space = childMargin.right;
					}
					tileWidth += childRect.width + space + padding.horizontal;
					space = childRect.height + childMargin[dock] + padding.vertical;
					if (tileHeight + dockMargin[dock] < space + childMargin[m]) {
						tileHeight = space;
						dockMargin[dock] = childMargin[m];
					}
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
				space = measured.width + childMargin.left + childMargin.right + padding.horizontal;
				measured.minWidth = measured.constrainWidth(space + childMin.width);
				measured.maxWidth = measured.constrainWidth(space + childMax.width);
				
				space = measured.height + childMargin.top + childMargin.bottom + padding.vertical;
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
			var tile:String = style.tile;
			if (tile) {
				if (tile == Align.LEFT || tile == Align.RIGHT) {
					if (dock != Align.BOTTOM) {
						dock = Align.TOP;
					}
				} else if (tile == Align.TOP || tile == Align.BOTTOM) {
					if (dock != Align.RIGHT) {
						dock = Align.LEFT;
					}
				} else {
					tile = null;
				}
			}
			if (!dock || validDockValues.indexOf(dock) == -1) {
				super.updateChild(child, last);
				return;
			}
			
			if (!tile) {
				if (tiling) {
					childMargin.merge(dockMargin.clone(contentMargin));
					tiling = false;
				}
				dockChild(dock, contentRect, childMargin);
				updateArea(dock, contentRect, contentMargin);
			} else {
				if (!tiling || dock != lastDock) {
					tiling = true;
					contentMargin.clone(dockMargin);
					tileRect.x = contentRect.x;
					tileRect.y = contentRect.y;
					tileRect.width = contentRect.width;
					tileRect.height = contentRect.height;
				}
				
				tileChild(tile, dock, tileRect, childMargin);
				updateArea(tile, tileRect, contentMargin);
				updateArea(dock, contentRect, dockMargin);
			}
			
			if (last) {
				lastDock = null;
				tiling = false;
			} else {
				lastDock = dock;
			}
		}
		
		protected function dockChild(dock:String, area:Rectangle, margin:Box):void
		{
			switch (dock) {
				case Align.LEFT :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					childRect.height = area.height - margin.top - margin.bottom;
					break;
				case Align.TOP :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					childRect.width = area.width - margin.left - margin.right;
					break;
				case Align.RIGHT :
					childRect.x = area.x + area.width - childRect.width - margin.right;
					childRect.y = area.y + margin.top;
					childRect.height = area.height - margin.top - margin.bottom;
					break;
				case Align.BOTTOM :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + area.height - childRect.height - margin.bottom;
					childRect.width = area.width - margin.left - margin.right;
					break;
				case Align.JUSTIFY :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					childRect.height = area.height - margin.top - margin.bottom;
					childRect.width = area.width - margin.left - margin.right;
					break;
			}
		}
		
		protected function tileChild(tile:String, dock:String, area:Rectangle, margin:Box):void
		{
			switch (tile) {
				case Align.LEFT :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					if (dock == Align.BOTTOM) {
						childRect.y = area.y + area.height - childRect.height - margin.bottom;
					}
					break;
				case Align.TOP :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					if (dock == Align.RIGHT) {
						childRect.x = area.x + area.width - childRect.width - margin.right;
					}
					break;
				case Align.RIGHT :
					childRect.x = area.x + area.width - childRect.width - margin.right;
					childRect.y = area.y + margin.top;
					if (dock == Align.BOTTOM) {
						childRect.y = area.y + area.height - childRect.height - margin.bottom;
					}
					break;
				case Align.BOTTOM :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + area.height - childRect.height - margin.bottom;
					if (dock == Align.RIGHT) {
						childRect.x = area.x + area.width - childRect.width - margin.right;
					}
					break;
				case Align.JUSTIFY :
					childRect.x = area.x + margin.left;
					childRect.y = area.y + margin.top;
					break;
			}
		}
		
		protected function updateArea(align:String, area:Rectangle, margin:Box):void
		{
			var pos:Number;
			switch (align) {
				case Align.LEFT :
					if (area.left + margin.left < (pos = childRect.x + childRect.width + padding.horizontal) + childMargin.right) {
						area.left = pos;
						margin.left = childMargin.right;
					}
					break;
				case Align.TOP :
					if (area.top + margin.top < (pos = childRect.y + childRect.height + padding.vertical) + childMargin.bottom) {
						area.top = pos;
						margin.top = childMargin.bottom;
					}
					break;
				case Align.RIGHT :
					if (area.right - margin.right > (pos = childRect.x - padding.horizontal) - childMargin.left) {
						area.right = pos;
						margin.right = childMargin.left;
					}
					break;
				case Align.BOTTOM :
					if (area.bottom - margin.bottom > (pos = childRect.y - padding.vertical) - childMargin.top) {
						area.bottom = pos;
						margin.bottom = childMargin.top;
					}
					break;
			}
		}
	}
}
