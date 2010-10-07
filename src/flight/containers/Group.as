/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.collections.SimpleCollection;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.display.SpriteDisplay;
	import flight.layouts.ILayout;
	import flight.templating.addItemsAt;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[DefaultProperty("content")]
	
	/**
	 * Used to contain and layout children.
	 * 
	 * @alpha
	 */
	public class Group extends SpriteDisplay implements IContainer
	{
		private var _layout:ILayout;
		private var _template:Object;
		private var _content:IList;
		private var renderers:Array;
		
		public function Group()
		{
			addEventListener(LayoutPhase.MEASURE, onMeasure, false, 0, true);
			addEventListener(LayoutPhase.LAYOUT, onLayout, false, 0, true);
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="contentChange")]
		public function get content():IList
		{
			if (_content == null) _content = new SimpleCollection();
			return _content;
		}
		
		public function set content(value:*):void
		{
			if (_content == value) {
				return;
			}
			
			if (_content) {
				_content.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			
			if (value == null) {
				_content = null;
			} else if (value is IList) {
				_content = value as IList;
			} else if (value is Array || value is Vector) {
				_content = new SimpleCollection(value);
			} else {
				_content = new SimpleCollection([value]);
			}
			
			if (_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _content.length; i++) {
					items.push(_content.getItemAt(i));
				}
				reset(items);
			}
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
			dispatchEvent(new Event("contentChange"));
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout == value) {
				return;
			}
			var oldLayout:ILayout = _layout;
			if (_layout) { _layout.target = null; }
			_layout = value;
			if (_layout) { _layout.target = this; }
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
			dispatchEvent(new Event("layoutChange"));
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void
		{
			if (_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			if (_content != null) {
				var items:Array = [];
				var length:int = _content.length;
				for (var i:int = 0; i < length; i++) {
					var child:Object = _content.getItemAt(i);
					items.push(child);
				}
				reset(items);
			}
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
			dispatchEvent(new Event("templateChange"));
		}
		
		private function onMeasure(event:Event):void
		{
			if ((isNaN(explicit.width) || isNaN(explicit.height)) && layout) {
				var point:Point = layout.measure(renderers);
				measured.width = point.x;
				measured.height = point.y;
			}
		}
		
		private function onLayout(event:Event):void
		{
			if (layout) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				layout.update(renderers, rectangle);
			}
		}
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location;
			switch (event.kind) {
				//case ListEventKind.ADD :
				case CollectionEventKind.ADD :
					add(event.items, loc);
					break;
				case CollectionEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case CollectionEventKind.REPLACE :
					removeChild(event.items[1]);
					//addChildAt(event.items[0], loc);
					break;
				case CollectionEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		private function add(items:Array, index:int):void
		{
			var children:Array = addItemsAt(this, items, index, _template);
			renderers.concat(children); // todo: correct ordering
		}
		
		private function reset(items:Array):void
		{
			while (numChildren) {
				removeChildAt(numChildren - 1);
			}
			renderers = addItemsAt(this, items, 0, _template); // todo: correct ordering
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		
	}
}
