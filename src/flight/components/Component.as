/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import flight.behaviors.IBehavior;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.InitializePhase;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.display.SpriteDisplay;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.SkinEvent;
	import flight.events.StyleEvent;
	import flight.list.ArrayList;
	import flight.list.IList;
	import flight.skins.ISkin;
	import flight.skins.ISkinnable;
	
	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public class Component extends SpriteDisplay implements ISkinnable
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Component()
		{
			_behaviors = new ArrayList();
			_behaviors.addEventListener(ListEvent.LIST_CHANGE, onBehaviorsChange);
			style.addEventListener(StyleEvent.STYLE_CHANGE, onStyleChange);
			addEventListener(InitializePhase.CREATE, onSkinCreate);
		}
		
		[Bindable(event="disabledChange", style="noEvent")]
		public function get disabled():Boolean { return _disabled; }
		public function set disabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = !value;
			DataChange.change(this, "disabled", _disabled, _disabled = value);
		}
		private var _disabled:Boolean = true;

		[ArrayElementType("flight.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange", style="noEvent")]
		public function get behaviors():IList { return _behaviors; }
		public function set behaviors(value:*):void
		{
			if (value is IBehavior) {
				style[IBehavior(value).type] = value;
			} else if (value is Array || value is IList) {
				for each (var behavior:IBehavior in value) {
					style[behavior.type] = behavior;
				}
			}
		}
		private var _behaviors:IList;
		
		// ====== IDataRenderer implementation ====== //
		
		[Bindable(event="dataChange", style="noEvent")]
		public function get data():Object { return _data || (_data = {}); }
		public function set data(value:Object):void
		{
			DataChange.change(this, "data", _data, _data = value);
		}
		private var _data:Object;
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
		[Bindable(event="skinChange", style="noEvent")]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void
		{
			if (_skin != value) {
				if (_skin) {
					removeSkin();
				}
				DataChange.queue(this, "skin", _skin, _skin = value);
				RenderPhase.invalidate(this, LayoutPhase.MEASURE);
				RenderPhase.invalidate(this, InitializePhase.CREATE);
				DataChange.change();
			}
		}
		private var _skin:ISkin;
		
		protected function get skinParts():Object { return _skinParts; }
		protected function set skinParts(value:Object):void
		{
			for (var i:String in value) {
				_skinParts[i] = value[i];
			}
		}
		private var _skinParts:Object = {};
		
		
		protected function addSkin():void
		{
			_skin.target = this;
			var skinParts:Object = this.skinParts;
			for (var i:String in skinParts) {
				var part:InteractiveObject = _skin.getSkinPart(i);
				if (part) {
					this[i] = part;
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, i, null, this[i]));
				}
			}
			_skin.addEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
		}
		
		protected function removeSkin():void
		{
			var skinParts:Object = this.skinParts;
			for (var i:String in skinParts) {
				this[i] = null;
			}
			_skin.removeEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
			_skin.target = null;
		}
		
		private function onSkinPartChange(event:SkinEvent):void
		{
			this[event.skinPart] = _skin.getSkinPart(event.skinPart);
			dispatchEvent(event);
		}
		
		private function onSkinCreate(event:Event):void
		{
			addSkin();
		}
		
		private function onStyleChange(event:StyleEvent):void
		{
			var behavior:IBehavior;			
			if (event.oldValue is IBehavior) {
				behavior = IBehavior(event.oldValue);
				behaviorsChanging = true;
				_behaviors.removeItem(behavior);
				behaviorsChanging = false;
				behavior.target = null;
			}
			if (event.newValue is IBehavior) {
				behavior = IBehavior(event.newValue);
				if (behavior.type != event.property) {
					behavior.type = event.property;
				}
				behaviorsChanging = true;
				_behaviors.addItem(behavior);
				behaviorsChanging = false;
				behavior.target = this;
			}
		}
		
		private function onBehaviorsChange(event:ListEvent):void
		{
			if (behaviorsChanging) {
				return;
			}
			
			var behavior:IBehavior;
			var location:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD:
					for each (behavior in event.items) {
						style[behavior.type] = behavior;
					}
					break;
				case ListEventKind.REMOVE:
					for each (behavior in event.items) {
						delete style[behavior.type];
					}
					break;
				case ListEventKind.REPLACE:
					behavior = event.items[1];
					delete style[behavior.type];
					behavior = event.items[0];
					style[behavior.type] = behavior;
					break;
				default:	// ListEventKind.RESET
					for each (behavior in event.items) {
						delete style[behavior.type];
					}
					for each (behavior in _behaviors) {
						style[behavior.type] = behavior;
					}
			}
		}
		private var behaviorsChanging:Boolean;
	}
}
