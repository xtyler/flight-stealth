/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.LayoutPhase;
	
	public class Layout extends EventDispatcher implements ILayout
	{
		public var paddingLeft:Number = 0;
		public var paddingTop:Number = 0;
		public var paddingRight:Number = 0;
		public var paddingBottom:Number = 0;
		public var paddingHorizontal:Number = 0;
		public var paddingVertical:Number = 0;
		
		protected var dataBind:DataBind = new DataBind();
		
		public function Layout(target:IContainer = null)
		{
			this.target = target;
		}
		
		[Bindable(event="targetChange", style="weak")]
		public function get target():IContainer { return _target; }
		public function set target(value:IContainer):void
		{
			if (_target == value) {
				return;
			}
			if (_target) {
				_target.display.removeEventListener(LayoutPhase.MEASURE, onMeasure);
				_target.display.removeEventListener(LayoutPhase.LAYOUT, onLayout);
			}
			DataChange.change(this, "target", _target, _target = value);
			if (_target) {
				_target.display.addEventListener(LayoutPhase.MEASURE, onMeasure, false, 50, true);
				_target.display.addEventListener(LayoutPhase.LAYOUT, onLayout, false, 50, true);
			}
		}
		private var _target:IContainer;
		
		
		public function measure():void
		{
			if (!target) return;
		}
		
		public function update():void
		{
			if (!target) return;
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		private function onLayout(event:Event):void
		{
			update();
		}
	}
}
