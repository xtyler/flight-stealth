/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flight.data.DataChange;
	import flight.display.LayoutPhase;
	import flight.display.SpriteDisplay;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.layouts.ILayout;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	[Style(name="padding")]
	[Style(name="background")]	// TODO: implement limited drawing feature
	
	[DefaultProperty("content")]
	public class Group extends SpriteDisplay implements IContainer
	{
		private var changing:Boolean;
		
		public function Group()
		{
			_content = new ArrayList();
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
			addEventListener(Event.ADDED, onChildAdded, true);
			addEventListener(Event.REMOVED, onChildRemoved, true);
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="weak")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			_content.removeItems();
			if (value is DisplayObject) {
				_content.addItem(value);
			} else if (value is Array) {
				_content.addItems(value);
			} else if (value is IList) {
				_content.addItems( IList(value).getItems() );
			}
			DataChange.change(this, "content", _content, _content, true);
		}
		private var _content:IList;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange", style="weak")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout == value) {
				return;
			}
			
			if (_layout) { _layout.target = null; }
			DataChange.queue(this, "layout", _layout, _layout = value);
			if (_layout) { _layout.target = this; }
			DataChange.change();
		}
		private var _layout:ILayout;
		
		override protected function measure():void
		{
			if (!layout) {
				super.measure();
			}
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (changing) {
				return;
			}
			
			changing = true;
			var child:DisplayObject;
			var location:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					for each (child in event.items) {
						addChildAt(child, location++);
					}
					break;
				case ListEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case ListEventKind.MOVE :
					addChildAt(event.items[0], location);
					break;
				case ListEventKind.REPLACE :
					removeChild(event.items[1]);
					addChildAt(event.items[0], location);
					break;
				default:	// ListEventKind.RESET
					while (numChildren) {
						removeChildAt(numChildren-1);
					}
					for (var i:int = 0; i < content.length; i++) {
						addChildAt(content.getItemAt(i) as DisplayObject, i);
					}
			}
			changing = false;
			
			invalidate(LayoutPhase.MEASURE);
			invalidate(LayoutPhase.LAYOUT);
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (changing || child.parent != this) {
				return;
			}
			
			changing = true;
			content.addItemAt(child, getChildIndex(child));
			changing = false;
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (changing || child.parent != this) {
				return;
			}
			
			changing = true;
			content.removeItem(child);
			changing = false;
		}
	}
}
