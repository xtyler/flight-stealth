/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{

	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.data.DataChange;
	import flight.data.IRange;
	import flight.events.ButtonEvent;

	public class DragStepBehavior extends Behavior
	{
		
		private var _position:IRange;
		
		[Bindable(event="positionChange")]
		[Binding(target="target.position")]
		public function get position():IRange { return _position; }
		public function set position(value:IRange):void
		{
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public var increment:Number = 1;
		public var dragTolerance:Number = 3;
		public var dragging:Boolean = false;
		
		private var startDragPosition:Number;
		
		public function DragStepBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			ButtonEvent.initialize(target);
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onDragStart(event:MouseEvent):void
		{
			startDragPosition = position.value;
		}
		
		[EventListener(type="drag", target="target")]
		public function onDrag(event:ButtonEvent):void
		{
			if (dragging) {
				position.value = Math.round((startDragPosition + event.deltaX) / increment) * increment;
			} else if (Math.abs(startDragPosition - event.deltaX) > dragTolerance) {
				position.value = Math.round((startDragPosition + event.deltaX) / increment) * increment;
				dragging = true;
			}
		}
		
	}
}
