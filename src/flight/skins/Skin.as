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
	import flash.events.EventDispatcher;
	
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;
	import flight.list.IList;
	import flight.styles.IStateful;
	
	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	/**
	 * Skin is a convenient base class for many skins, swappable graphic
	 * definitions. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	[DefaultProperty("content")]
	public class Skin extends EventDispatcher implements ISkin, IContainer, IStateful
	{
		protected var skinnableComponent:ISkinnable;
		protected var dataBind:DataBind = new DataBind();
		
		public function Skin()
		{
			_measured = new Bounds();
			dataBind.bind(this, "currentState", this, "target.currentState");
		}
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			DataChange.queue(this, "display", _target, value);
			DataChange.queue(this, "target", _target, _target = value);
			if (_target is ISkinnable) {
				skinnableComponent = ISkinnable(_target);
			}
			if ("hostComponent" in this) {
				this["hostComponent"] = _target;
			}
			DataChange.change();
		}
		private var _target:Sprite;
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return part in this ? this[part] : null;
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
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="noEvent")]
		public function get contentWidth():Number
		{
			return _target != null ? _target.height : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="heightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			return _target != null ? _target.width : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds
		{
			return _target is IMeasureable ? IMeasureable(_target).measured : _measured;
		}
		private var _measured:IBounds;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="displayChange", style="noEvent")]
		public function get display():DisplayObject { return _target; }
		
	}
}
