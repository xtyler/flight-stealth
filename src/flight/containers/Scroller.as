/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.data.IScroll;
	import flight.data.Scroll;
	
	public class Scroller extends Group
	{
		protected var dataBind:DataBind = new DataBind();
		
		private var _horizontal:IScroll;
		private var _vertical:IScroll;
		private var _container:DisplayObject
		
		private var shape:Shape; // temporary
		
		[Bindable(event="horizontalChange")]
		public function get horizontal():IScroll { return _horizontal; }
		public function set horizontal(value:IScroll):void
		{
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		
		[Bindable(event="verticalChange")]
		public function get vertical():IScroll { return _vertical; }
		public function set vertical(value:IScroll):void
		{
			DataChange.change(this, "vertical", _vertical, _vertical = value);
		}
		
		[Bindable(event="containerChange")]
		public function get container():DisplayObject { return _container; }
		public function set container(value:DisplayObject):void
		{
			if (_container) { this.removeChild(_container); }
			DataChange.queue(this, "container", _container, _container = value);
			if (_container) { this.addChild(_container); }
			DataChange.change();
		}
		
		public function Scroller()
		{
			horizontal = new Scroll();
			vertical = new Scroll();
			dataBind.bindSetter(onHorizontalScroll, this, "horizontal.position");
			dataBind.bindSetter(onVerticalScroll, this, "vertical.position");
		}
		
		/**
		 * @private
		 **/
		// TODO: base position off of value and not percent (for container size-change)
		[CommitProperties(target="container, vertical, horizontal, container.height, container.width")]
		public function onContainerChange(event:Event):void
		{
			horizontal.min = vertical.min = 0;
			measured.width = horizontal.max = container.width;
			measured.height = vertical.max = container.height;
			if (horizontal is IScroll) {
				(horizontal as IScroll).pageSize = width;
			}
			if (vertical is IScroll) {
				(vertical as IScroll).pageSize = height;
			}
			shape = new Shape();
			shape.graphics.beginFill(0, 0);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			this.addChild(shape);
			this.mask = shape;
		}
		
		private function onVerticalScroll(value:Object):void
		{
			if (vertical && container) {
				var height:Number = container.height;
				var potential:Number = height - height;
				var percent:Number = (vertical.value - vertical.min) / (vertical.max - vertical.min);
				container.y = potential * percent * -1; // ui specific calcs are here, where the ui specific code is.
			}
		}
		
		private function onHorizontalScroll(value:Object):void
		{
			if (horizontal && container) {
				var width:Number = container.width;
				var potential:Number = width - width;
				var percent:Number = (horizontal.value - horizontal.min) / (horizontal.max - horizontal.min);
				container.x = potential * percent * -1; // ui specific calcs are here, where the ui specific code is.
			}
		}
	}
}
