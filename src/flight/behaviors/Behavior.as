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

	/**
	 * Behavior is a convenient base class for various behavior implementations.
	 * These classes represent added features and functionality to a target
	 * InteractiveObject. Behavior takes advantage of the skin of an ISkinnable
	 * target by syncing skin parts and setting state.
	 * 
	 * Stealth component behaviors can be broken into 3 types -
	 * 1) a components single base behavior - core implementation with which the
	 * particular component would be useless without (eg ScrollBarBehavior)
	 * 2) a components addon behaviors - additional functionality specefic to
	 * the component (eg ReorderTabBehavior)
	 * 3) common addon behaviors - general solutions for all components, or all
	 * components of a type (eg TooltipBehavior)
	 * @alpha
	 */
	public class Behavior extends EventDispatcher implements IBehavior
	{
		protected var dataBind:DataBind = new DataBind();
		
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable(event="targetChange")]
		public function get target():InteractiveObject { return _target; }
		public function set target(value:InteractiveObject):void
		{
			_target = value;
			dispatchEvent(new Event("targetChange"));
		}
		private var _target:InteractiveObject;
		
		public function Behavior(target:InteractiveObject = null)
		{
			this.target = target;
		}
	}
}
