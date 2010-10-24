/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import flash.geom.Rectangle;

	import flight.data.DataChange;
	import flight.data.IScroll;
	import flight.data.Scroll;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.display.SpriteDisplay;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.layouts.ILayout;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	[Style(name="background")]	// TODO: implement limited drawing feature
	
	[DefaultProperty("content")]
	public class Group extends SpriteDisplay implements IContainer
	{
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
		[Bindable(event="contentChange", style="noEvent")]
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
		[Bindable(event="layoutChange", style="noEvent")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				if (_layout) {
					_layout.target = null;
				}
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_layout) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		[Bindable(event="contentWidthChange", style="noEvent")]
		public function get contentWidth():Number { return !constrainMeasured ? _contentWidth : width}
		public function set contentWidth(value:Number):void
		{
			if (!constrainMeasured) {
				value = measured.constrainWidth(value);
				DataChange.change(this, "contentWidth", _contentWidth, _contentWidth = value);
			} else {
				width = value;
			}
		}
		private var _contentWidth:Number = 0;
		
		[Bindable(event="contentHeightChange", style="noEvent")]
		public function get contentHeight():Number { return !constrainMeasured ? _contentHeight : height}
		public function set contentHeight(value:Number):void
		{
			if (!constrainMeasured) {
				value = measured.constrainHeight(value);
				DataChange.change(this, "contentHeight", _contentHeight, _contentHeight = value);
			} else {
				height = value;
			}
		}
		private var _contentHeight:Number = 0;
		
		[Bindable(event="hPositionChange", style="noEvent")]
		public function get hPosition():IScroll { return _hPosition || (hPosition = new Scroll()); }
		public function set hPosition(value:IScroll):void
		{
			if (_hPosition) {
				_hPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "hPosition", _hPosition, _hPosition = value);
			if (_hPosition) {
				_hPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _hPosition:IScroll;
		
		[Bindable(event="vPositionChange", style="noEvent")]
		public function get vPosition():IScroll { return _vPosition || (vPosition = new Scroll()); }
		public function set vPosition(value:IScroll):void
		{
			if (_vPosition) {
				_vPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "vPosition", _vPosition, _vPosition = value);
			if (_vPosition) {
				_vPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _vPosition:IScroll;
		
		[Bindable(event="clipChange", style="noEvent")]
		public function get clip():Boolean { return _clip }
		public function set clip(value:Boolean):void
		{
			if (_clip != value) {
				if (value) {
					addEventListener(LayoutPhase.RESIZE, onResize);
					constrainMeasured = false;
				} else {
					removeEventListener(LayoutPhase.RESIZE, onResize);
					constrainMeasured = true;
				}
				DataChange.change(this, "clip", _clip, _clip = value);
			}
		}
		private var _clip:Boolean = false;
		
		override protected function measure():void
		{
			if (!layout) {
				super.measure();
			}
			if (!constrainMeasured) {
				contentWidth = _contentWidth;
				contentHeight = _contentHeight;
			}
		}
		
		private function onResize(event:Event):void
		{
			var rect:Rectangle;
			rect = scrollRect || new Rectangle();
			rect.width = width;
			rect.height = height;
			if (_hPosition) {
				_hPosition.min = 0;
				_hPosition.max = contentWidth - width;
				_hPosition.pageSize = rect.width;
				rect.x = hPosition.value;
			}
			if (_vPosition) {
				_vPosition.min = 0;
				_vPosition.max = contentHeight - height;
				_vPosition.pageSize = rect.height;
				rect.y = vPosition.value;
			}
			
			if (width < contentWidth || height < contentHeight) {
				scrollRect = rect;
			} else if (scrollRect) {
				scrollRect = null;
			}
		}
		
		private function onPositionChange(event:Event):void
		{
			if (width < contentWidth || height < contentHeight) {
				var rect:Rectangle = scrollRect || new Rectangle();
				if (_hPosition) {
					rect.x = hPosition.value;
				}
				if (_vPosition) {
					rect.y = vPosition.value;
				}
				scrollRect = rect;
			}
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.addItemAt(child, getChildIndex(child));
			contentChanging = false;
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.removeItem(child);
			contentChanging = false;
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (contentChanging) {
				return;
			}
			
			contentChanging = true;
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
					for each (child in event.items) {
						removeChild(child);
					}
					for each (child in _content) {
						addChildAt(child, location++);
					}
			}
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		private var contentChanging:Boolean;
	}
}
