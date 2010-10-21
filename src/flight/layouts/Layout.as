/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;

	public class Layout extends EventDispatcher implements ILayout
	{
		protected var dataBind:DataBind = new DataBind();
		
		protected var childRect:Rectangle;
		protected var childMin:Rectangle = new Rectangle();
		protected var childMax:Rectangle = new Rectangle();
		protected var childMargin:Box = new Box();
		protected var contentMargin:Box = new Box();
		protected var contentRect:Rectangle = new Rectangle();
		protected var percentWidth:Number;
		protected var percentHeight:Number;
		protected var percentHorizontal:Number;
		protected var percentVertical:Number;
		
		public function Layout(target:IContainer = null)
		{
			this.target = target;
		}
		
		[Bindable(event="targetChange", style="weak")]
		public function get target():IContainer { return _target; }
		public function set target(value:IContainer):void
		{
			if (_target == value) {
				return;
			}
			if (_target) {
				_target.display.removeEventListener(LayoutPhase.MEASURE, onMeasure);
				_target.display.removeEventListener(LayoutPhase.LAYOUT, onLayout);
			}
			DataChange.change(this, "target", _target, _target = value);
			if (_target) {
				_target.display.addEventListener(LayoutPhase.MEASURE, onMeasure, false, 50, true);
				_target.display.addEventListener(LayoutPhase.LAYOUT, onLayout, false, 50, true);
				RenderPhase.invalidate(_target.display, LayoutPhase.LAYOUT);
			}
		}
		private var _target:IContainer;
		
		[Bindable(event="paddingChange", style="weak")]
		public function get padding():Box { return _padding || (_padding = new Box()); }
		public function set padding(value:*):void
		{
			value = (value is String ? Box.fromString(value) : value) as Box;
			if (_target) RenderPhase.invalidate(_target.display, LayoutPhase.LAYOUT);
			DataChange.change(this, "padding", _padding, _padding = value);
		}
		private var _padding:Box = new Box();
		
		[Bindable(event="horizontalAlignChange", style="weak")]
		public function get horizontalAlign():String { return _horizontalAlign }
		public function set horizontalAlign(value:String):void
		{
			if (_target) RenderPhase.invalidate(_target.display, LayoutPhase.LAYOUT);
			DataChange.change(this, "horizontalAlign", _horizontalAlign, _horizontalAlign = value);
		}
		private var _horizontalAlign:String = Align.LEFT;
		
		[Bindable(event="verticalAlignChange", style="weak")]
		public function get verticalAlign():String { return _verticalAlign }
		public function set verticalAlign(value:String):void
		{
			if (_target) RenderPhase.invalidate(_target.display, LayoutPhase.LAYOUT);
			DataChange.change(this, "verticalAlign", _verticalAlign, _verticalAlign = value);
		}
		private var _verticalAlign:String = Align.TOP;
				
		public function measure():void
		{
			if (!_target) return;
			
			var measured:IBounds = _target.measured;
			measured.width = measured.height = 0;
			measured.minWidth = measured.minHeight = 0;
			measured.maxWidth = measured.maxHeight = 0xFFFFFF;
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			percentHorizontal = percentVertical = 0;
			
			var len:int = _target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(_target.content.getItemAt(i));
				
				if (child is ILayoutBounds) {
					var layoutChild:ILayoutBounds = ILayoutBounds(child);
					if (layoutChild.freeform) {
						continue;
					}
					
					// update contentMargin to be the greater of this child's margin and the previous child's margin
					contentMargin.clone(childMargin).merge(layoutChild.margin);
					
					childRect = layoutChild.getLayoutRect(layoutChild.minWidth, layoutChild.minHeight);
					childMin.width = childRect.width;
					childMin.height = childRect.height;
					childRect = layoutChild.getLayoutRect(layoutChild.maxWidth, layoutChild.maxHeight);
					childMax.width = childRect.width;
					childMax.height = childRect.height;
					childRect = layoutChild.getLayoutRect(layoutChild.preferredWidth, layoutChild.preferredHeight);
					
					if (!isNaN(percentWidth = layoutChild.percentWidth)) {
						childRect.width = childMin.width;
					}
					if (!isNaN(percentHeight = layoutChild.percentHeight)) {
						childRect.height = childMin.height;
					}
				} else {
					childMargin = contentMargin.clone(childMargin);
					childMin.width = childMin.height = 0;
					childMax.width = childMax.height = 0xFFFFFF;
					childRect = child.getRect(child.parent);
					percentWidth = percentHeight = NaN;
				}
				
				measureChild(child, i == len - 1);
			}
			
			var space:Number = _padding.left + _padding.right;
			measured.width += space;
			measured.minWidth += space;
			measured.maxWidth += space;
			space = _padding.top + _padding.bottom;
			measured.height += space;
			measured.minHeight += space;
			measured.maxHeight += space;
		}
		
		public function update():void
		{
			if (!_target) return;
			
			var measured:IBounds = _target.measured;
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			contentRect.x = _padding.left;
			contentRect.y = _padding.top;
			contentRect.width = _target.width;
			contentRect.height = _target.height
			
			if (contentRect.width != measured.width && _horizontalAlign != Align.JUSTIFY) {
				var measuredWidth:Number = measured.width + percentHorizontal * contentRect.width;
				if (measuredWidth < contentRect.width) {
					switch (_horizontalAlign) {
						case Align.CENTER: contentRect.x += (contentRect.width - measuredWidth) / 2; break;
						case Align.RIGHT: contentRect.x += (contentRect.width - measuredWidth); break;
					}
					contentRect.width = measuredWidth;
				}
			}
			contentRect.width -= _padding.left + _padding.right;
			
			if (contentRect.height != measured.height && _verticalAlign != Align.JUSTIFY) {
				var measuredHeight:Number = measured.height + percentVertical * contentRect.height;
				if (measuredHeight < contentRect.height) {
					switch (_verticalAlign) {
						case Align.CENTER: contentRect.y += (contentRect.height - measuredHeight) / 2; break;
						case Align.BOTTOM: contentRect.y += (contentRect.height - measuredHeight); break;
					}
					contentRect.height = measuredHeight;
				}
			}
			contentRect.height -= _padding.top + _padding.bottom;
			
			if (percentHorizontal < 1) {
				percentHorizontal = 1;
			}
			if (percentVertical < 1) {
				percentVertical = 1;
			}
			
			var len:int = _target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(_target.content.getItemAt(i));
				
				childMargin = contentMargin.clone(childMargin);
				if (child is ILayoutBounds) {
					var layoutChild:ILayoutBounds = ILayoutBounds(child);
					if (layoutChild.freeform) {
						continue;
					}
					
					// update contentMargin to be the greater of this child's margin and the previous child's margin
					contentMargin.clone(childMargin).merge(layoutChild.margin);
					
					childRect = layoutChild.getLayoutRect(layoutChild.minWidth, layoutChild.minHeight);
					childMin.width = childRect.width;
					childMin.height = childRect.height;
					childRect = layoutChild.getLayoutRect(layoutChild.maxWidth, layoutChild.maxHeight);
					childMax.width = childRect.width;
					childMax.height = childRect.height;
					childRect = layoutChild.getLayoutRect(layoutChild.preferredWidth, layoutChild.preferredHeight);
					
					if (!isNaN(percentWidth = layoutChild.percentWidth)) {
						childRect.width = childMin.width;
					}
					if (!isNaN(percentHeight = layoutChild.percentHeight)) {
						childRect.height = childMin.height;
					}
				} else {
					childMargin = contentMargin.clone(childMargin);
					childRect = child.getRect(child.parent);
					percentWidth = percentHeight = NaN;
				}
				
				updateChild(child, i == len - 1);
				
				if (child is ILayoutBounds) {
					ILayoutBounds(child).setLayoutSize(childRect.width, childRect.height);
					ILayoutBounds(child).setLayoutPosition(childRect.x, childRect.y);
				} else {
					child.x = childRect.x;
					child.y = childRect.y;
					child.width = childRect.width;
					child.height = childRect.height;
				}
			}
		}
		
		protected function constrainChildWidth(width:Number):Number
		{
			return (width <= childMin.width) ?  childMin.width :
				(width >=  childMax.width) ? childMax.width : width;
		}
		
		protected function constrainChildHeight(height:Number):Number
		{
			return (height <= childMin.height) ?  childMin.height :
				(height >=  childMax.height) ? childMax.height : height;
		}
		
		protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		private function onLayout(event:Event):void
		{
			update();
		}
	}
}
