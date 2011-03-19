/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;
	import flight.styles.IStateful;
	import flight.utils.Invalidation;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	/**
	 * Skin is a convenient base class for many skins, swappable graphic
	 * definitions. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	[DefaultProperty("content")]
	public class Skin extends EventDispatcher implements ISkin, IContainer, IStateful
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Skin()
		{
			dataBind.bind(this, "currentState", this, "target.currentState");
		}
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target != value) {
				if (_target) {
					detachSkin();
				}
				DataChange.queue(this, "display", _target, value);
				DataChange.queue(this, "target", _target, _target = value);
				if ("hostComponent" in this) {
					this["hostComponent"] = _target;
				}
				if (_target) {
					attachSkin();
				}
				if (_layout && _target) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _target:Sprite;
		
		public function getSkinPart(partName:String):InteractiveObject
		{
			return partName in this ? this[partName] : null;
		}
		
		protected function attachSkin():void
		{
			for (var i:int = 0; i < _target.numChildren; i ++) {
				_content.add(_target.getChildAt(i), i);
			}
			for (i; i < _content.length; i++) {
				_target.addChildAt(DisplayObject(_content.get(i, 0)), i);
			}
			_target.addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10, true);
			_target.addEventListener(Event.ADDED, onChildAdded, true);
			_target.addEventListener(Event.REMOVED, onChildRemoved, true);
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
		}
		
		protected function detachSkin():void
		{
			_target.removeEventListener(Event.ADDED, onChildAdded, true);
			_target.removeEventListener(Event.REMOVED, onChildRemoved, true);
			_content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
			
			while (_target.numChildren) {
				_target.removeChildAt(0);
			}
		}
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
		// ====== IContainer implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			_content.queueChanges = true;
			_content.removeAt();
			if (value is IList) {
				_content.add( IList(value).get() );
			} else if (value is Array) {
				_content.add(value);
			} else if (value === null) {
				_content.removeAt();						// TODO: determine if List change AND propertychange should both fire
			} else {
				_content.add(value);
			}
			_content.queueChanges = false;					// TODO: determine if List change AND propertychange should both fire
			DataChange.change(this, "content", _content, _content, true);
		}
		private var _content:ArrayList = new ArrayList();
		
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
				if (_layout && _target) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="noEvent")]
		public function get contentWidth():Number
		{
			return _target != null ? _target.width : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="heightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			return _target != null ? _target.height : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:IBounds = new Bounds();
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="displayChange", style="noEvent")]
		public function get display():DisplayObject { return _target; }
		
		protected function measure():void
		{
			if (_target) {
				var rect:Rectangle = _target.getRect(_target);
				_measured.width = rect.width;
				_measured.height = rect.height;
			}
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
			if (_target is IMeasureable) {
				var targetMeasured:IBounds = IMeasureable(_target).measured;
				targetMeasured.minWidth = _measured.minWidth;
				targetMeasured.minHeight = _measured.minHeight;
				targetMeasured.maxWidth = _measured.maxWidth;
				targetMeasured.maxHeight = _measured.maxHeight;
				targetMeasured.width = _measured.width;
				targetMeasured.height = _measured.height;
			}
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != _target) {
				return;
			}
			
			contentChanging = true;
			content.add(child, _target.getChildIndex(child));
			contentChanging = false;
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != _target) {
				return;
			}
			
			contentChanging = true;
			content.remove(child);
			contentChanging = false;
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (contentChanging) {
				return;
			}
			
			contentChanging = true;
			var child:DisplayObject;
			for each (child in event.removed) {
				_target.removeChild(child);
			}
			for each (child in event.items) {
				_target.addChildAt(child, _content.getIndex(child));
			}
			contentChanging = false;
			
			Invalidation.invalidate(_target, LayoutEvent.MEASURE);
			Invalidation.invalidate(_target, LayoutEvent.LAYOUT);
		}
		private var contentChanging:Boolean;
	}
}
