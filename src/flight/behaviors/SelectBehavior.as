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
	
	/**
	 * @description Adds selection toggling functionality to the target. When clicked, the target's selected property will be flipped.
	 * @alpha
	 */
	public class SelectBehavior extends Behavior implements IBehavior
	{
		
		private var _selected:Boolean;
		
		[Bindable(event="selectedChange")]
		[Binding(target="target.selected")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			DataChange.change(this, "selected", _selected, _selected = value);
		}
		
		public function SelectBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		/**
		 * @private
		 */
		[EventListener(type="click", target="target")]
		public function onClick(event:MouseEvent):void
		{
			selected = !selected;
			event.updateAfterEvent();
		}
		
	}
}
