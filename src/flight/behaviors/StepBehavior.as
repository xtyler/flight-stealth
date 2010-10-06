/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	import flight.data.IRange;
	import flight.data.Range;
	import flight.events.ButtonEvent;
	
	public class StepBehavior extends Behavior
	{
		public var fwdBehavior:ButtonBehavior;
		public var bwdBehavior:ButtonBehavior;
		
		[Bindable]
		public var fwdBtn:InteractiveObject;
		[Bindable]
		public var bwdBtn:InteractiveObject;
		
		[Bindable]
		[Binding(target="target.position")]
		public var position:IRange = new Range();		// TODO: implement lazy instantiation of position
		
		public function StepBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:IEventDispatcher):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			fwdBtn = getSkinPart("fwdBtn");
			bwdBtn = getSkinPart("bwdBtn");
			fwdBehavior = new ButtonBehavior(fwdBtn);
			bwdBehavior = new ButtonBehavior(bwdBtn);
			if (fwdBtn is MovieClip) {
				dataBind.bindSetter(onFwdStateChange, fwdBehavior, "state");
			}
			if (bwdBtn is MovieClip) {
				dataBind.bindSetter(onBwdStateChange, bwdBehavior, "state");
			}
		}
		
		[EventListener(type="press", target="fwdBtn")]
		[EventListener(type="hold", target="fwdBtn")]
		public function onFwdPress(event:ButtonEvent):void
		{
			position.stepForward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="bwdBtn")]
		[EventListener(type="hold", target="bwdBtn")]
		public function onBwdPress(event:ButtonEvent):void
		{
			position.stepBackward();
			event.updateAfterEvent();
		}
		
		protected function onFwdStateChange(state:String):void
		{
			MovieClip(fwdBtn).gotoAndStop(state);
		}
		
		protected function onBwdStateChange(state:String):void
		{
			MovieClip(bwdBtn).gotoAndStop(state);
		}
	}
}
