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
	
	/**
	 * Skin is a convenient base class for many skins, a swappable graphical
	 * definition. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	[DefaultProperty("content")]
	public class Skin extends EventDispatcher implements ISkin, IContainer//, IStateful, IStyleable, IInvalidating
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Skin()
		{
			_measured = new Bounds();
		}
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return _target }
		public function set target(value:Sprite):void
		{
			DataChange.queue(this, "display", _target, value);
			DataChange.change(this, "target", _target, _target = value);
		}
		private var _target:Sprite;
		
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return (part in this) ? this[part] : (part in _target ? _target[part] : null);
		}
		
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
		 * @private
		 */
		[Inspectable(category="General")]
		[Bindable(event="Change", style="noEvent")]
		public function get freeform():Boolean { return false; }
		public function set freeform(value:Boolean):void { }
		
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
