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
	import flight.data.ITrack;
	import flight.data.Track;
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
			for (var i:int = 0; i < numChildren; i ++) {
				_content.add(getChildAt(i));
			}
			addEventListener(Event.ADDED, onChildAdded, true);
			addEventListener(Event.REMOVED, onChildRemoved, true);
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			_content.removeAt();
			if (value is IList) {
				_content.add( IList(value).get() );
			} else if (value is Array) {
				_content.add(value);
			} else if (value === null) {
				_content.removeAt();
			} else {
				_content.add(value);
			}
			DataChange.change(this, "content", _content, _content, true);
		}
		private var _content:IList = new ArrayList();
		
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
		public function get contentWidth():Number
		{
			var preferredWidth:Number = !isNaN(_contentWidth) ? measured.constrainWidth(_contentWidth) : measured.width;
			return (!contained && preferredWidth > width) ? preferredWidth : width;
		}
		public function set contentWidth(value:Number):void
		{
			if (!contained) {
				DataChange.queue(this, "contentWidth", _contentWidth, _contentWidth = value);
			} else {
				width = value;
			}
		}
		private var _contentWidth:Number = 0;
		
		[Bindable(event="contentHeightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			var preferredHeight:Number = !isNaN(_contentHeight) ? measured.constrainHeight(_contentHeight) : measured.height;
			return (!contained && preferredHeight > height) ? preferredHeight : height;
		}
		public function set contentHeight(value:Number):void
		{
			if (!contained) {
				DataChange.change(this, "contentHeight", _contentHeight, _contentHeight = value);
			} else {
				height = value;
			}
		}
		private var _contentHeight:Number = 0;
		
		[Bindable(event="hPositionChange", style="noEvent")]
		public function get hPosition():ITrack { return _hPosition || (hPosition = new Track()); }
		public function set hPosition(value:ITrack):void
		{
			if (_hPosition) {
				_hPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "hPosition", _hPosition, _hPosition = value);
			if (_hPosition) {
				_hPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _hPosition:ITrack;
		
		[Bindable(event="vPositionChange", style="noEvent")]
		public function get vPosition():ITrack { return _vPosition || (vPosition = new Track()); }
		public function set vPosition(value:ITrack):void
		{
			if (_vPosition) {
				_vPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "vPosition", _vPosition, _vPosition = value);
			if (_vPosition) {
				_vPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _vPosition:ITrack;
		
		[Bindable(event="clippedChange", style="noEvent")]
		public function get clipped():Boolean { return _clipped }
		public function set clipped(value:Boolean):void
		{
			if (_clipped != value) {
				if (value) {
					addEventListener(LayoutPhase.RESIZE, onResize);
					contained = false;
					RenderPhase.invalidate(this, LayoutPhase.RESIZE);
				} else {
					removeEventListener(LayoutPhase.RESIZE, onResize);
					contained = true;
				}
				DataChange.change(this, "clipped", _clipped, _clipped = value);
			}
		}
		private var _clipped:Boolean = false;
		
		override protected function measure():void
		{
			if (!layout) {
				super.measure();
			}
			if (!contained) {
				scrollRectSize();
			}
		}
		
		protected function scrollRectPosition():void
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
		
		protected function scrollRectSize():void
		{
			if (_hPosition) {
				_hPosition.minimum = 0;
				_hPosition.maximum = contentWidth - width;
				_hPosition.pageSize = width;
			}
			if (_vPosition) {
				_vPosition.minimum = 0;
				_vPosition.maximum = contentHeight - height;
				_vPosition.pageSize = height;
			}
			
			if (width < contentWidth || height < contentHeight) {
				var rect:Rectangle = scrollRect || new Rectangle();
				rect.width = width;
				rect.height = height;
				if (_hPosition) {
					rect.x = hPosition.value;
				}
				if (_vPosition) {
					rect.y = vPosition.value;
				}
				scrollRect = rect;
			} else if (scrollRect) {
				scrollRect = null;
			}
		}
		
		private function onResize(event:Event):void
		{
			scrollRectSize();
		}
		
		private function onPositionChange(event:Event):void
		{
			scrollRectPosition();
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.add(child, getChildIndex(child));
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.remove(child);
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (contentChanging) {
				return;
			}
			
			contentChanging = true;
			var child:DisplayObject;
			var location:int = event.from;
			switch (event.kind) {
				case ListEventKind.ADD:
					for each (child in event.added) {
						addChildAt(child, location++);
					}
					break;
				case ListEventKind.REMOVE:
					for each (child in event.added) {
						removeChild(child);
					}
					break;
				case ListEventKind.MOVE:
					addChildAt(event.added[0], location);
					if (event.added.length == 2) {
						addChildAt(event.added[1], event.to);
					}
					break;
				case ListEventKind.REPLACE:
					removeChild(event.added[1]);
					addChildAt(event.added[0], location);
					break;
				default:	// ListEventKind.RESET
					for each (child in event.added) {
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
