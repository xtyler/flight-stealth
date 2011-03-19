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

	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.events.StyleEvent;
	import flight.styles.IStyleable;
	import flight.utils.Invalidation;

	public class Layout extends EventDispatcher implements ILayout
	{
		protected var layoutStyles:Array;
		
		public function Layout(target:IContainer = null)
		{
			this.target = target;
		}
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():IContainer { return _target; }
		public function set target(value:IContainer):void
		{
			if (_target == value) {
				return;
			}
			if (_target) {
				_target.display.removeEventListener(LayoutEvent.MEASURE, onMeasure);
				_target.display.removeEventListener(LayoutEvent.LAYOUT, onLayout);
				_target.content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
			}
			DataChange.change(this, "target", _target, _target = value);
			if (_target) {
				_target.display.addEventListener(LayoutEvent.MEASURE, onMeasure, false, 50, true);
				_target.display.addEventListener(LayoutEvent.LAYOUT, onLayout, false, 50, true);
				_target.content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
				Invalidation.invalidate(_target.display, LayoutEvent.MEASURE);
				Invalidation.invalidate(_target.display, LayoutEvent.LAYOUT);
			}
		}
		private var _target:IContainer;
		
		public function measure():void
		{
			if (!_target) return;
			
			var len:int = _target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(_target.content.get(i, 0));
				measureChild(child, i == len - 1);
			}
		}
		
		public function update():void
		{
			if (!_target) return;
			
			var len:int = _target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(_target.content.get(i, 0));
				updateChild(child, i == len - 1);
			}
		}
		
		protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		protected function registerStyle(property:String):void
		{
			if (!layoutStyles) {
				layoutStyles = [];
			}
			layoutStyles.push(property);
		}
		
		private function onStyleChange(event:StyleEvent):void
		{
			if (layoutStyles && layoutStyles.indexOf(event.property) != -1) {
				Invalidation.invalidate(_target.display, LayoutEvent.MEASURE);
				Invalidation.invalidate(_target.display, LayoutEvent.LAYOUT);
			}
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		private function onLayout(event:Event):void
		{
			update();
		}
		
		private function onContentChange(event:ListEvent):void
		{
			var child:DisplayObject;
			for each (child in event.removed) {
				if (child is IStyleable) {
					IStyleable(child).style.removeEventListener(StyleEvent.STYLE_CHANGE, onStyleChange);
				}
			}
			for each (child in event.items) {
				if (child is IStyleable) {
					IStyleable(child).style.addEventListener(StyleEvent.STYLE_CHANGE, onStyleChange);
				}
			}
		}
	}
}
