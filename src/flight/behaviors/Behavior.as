/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.SkinEvent;
	import flight.skins.ISkinnable;
	import flight.utils.getClassName;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public class Behavior extends EventDispatcher implements IBehavior
	{
		protected var dataBind:DataBind = new DataBind();
		
		[Bindable(event="typeChange", style="noEvent")]
		public function get type():String
		{
			if (!_type) {
				_type = getClassName(this).toLowerCase();
				_type = _type.replace("behavior", "");
			}
			return _type;
		}
		public function set type(value:String):void
		{
			DataChange.change(this, "type", _type, _type = value);
		}
		private var _type:String;
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():InteractiveObject { return _target }
		public function set target(value:InteractiveObject):void
		{
			if (_target != value) {
				if (_target) {
					detachSkin();
				}
				DataChange.queue(this, "target", _target, _target = value);
				if ("hostComponent" in this) {
					this["hostComponent"] = _target;
				}
				if (_target) {
					attachSkin();
				}
				DataChange.change();
			}
		}
		private var _target:InteractiveObject;
		
		protected function get skinParts():Object { return _skinParts; }
		protected function set skinParts(value:Object):void
		{
			for (var i:String in value) {
				_skinParts[i] = value[i];
			}
		}
		private var _skinParts:Object = {};
		
		protected function getSkinPart(partName:String):InteractiveObject
		{
			if (_target) {
				if (_target is ISkinnable && ISkinnable(_target).skin) {
					return ISkinnable(_target).skin.getSkinPart(partName);
				} else if (partName in _target) {
					return _target[partName];
				}
			}
			return null;
		}
		
		protected function attachSkin():void
		{
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = getSkinPart(partName);
				if (skinPart && partName in this) {
					this[partName] = skinPart;
					partAdded(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, null, skinPart));
				}
			}
			_target.addEventListener("skinChange", onSkinChange);
			_target.addEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
		}
		
		protected function detachSkin():void
		{
			_target.removeEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
			_target.removeEventListener("skinChange", onSkinChange);
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = this[partName];
				if (skinPart) {
					this[partName] = null;
					partRemoved(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, skinPart, null));
				}
			}
		}
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		private function onSkinPartChange(event:SkinEvent):void
		{
			var partName:String = event.partName;
			if (partName in this) {
				if (event.oldValue) {
					partRemoved(partName, event.oldValue);
				}
				this[partName] = event.newValue;
				if (event.newValue) {
					partAdded(partName, event.newValue);
				}
				dispatchEvent(event);
			}
		}
		
		private function onSkinChange(event:Event):void
		{
			detachSkin();
			attachSkin();
		}
	}
}
