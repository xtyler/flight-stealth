/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import flight.data.DataChange;
	import flight.display.RenderPhase;
	import flight.events.StyleEvent;

	[Event(name="styleChange", type="flight.events.StyleEvent")]
	[Event(name="stylesChanged", type="flight.events.StyleEvent")]
	
	/**
	 * A style object on which dynamic style data is stored.
	 */
	dynamic public class Style extends Proxy
	{
		/**
		 * Reference to the wrapped IEventDispatcher.
		 */
		protected var dispatcher:EventDispatcher;
		
		internal var explicitData:Object;
		internal var styleData:Object;
		
		private var changes:Object;
		
		public function Style(target:DisplayObject)
		{
			dispatcher = new EventDispatcher();
			explicitData = {};
			styleData = {};
			changes = {};
			_target = target;
		}
		
		[Bindable(event="targetChange", style="weak")]
		public function get target():DisplayObject { return _target }
		public function set target(value:DisplayObject):void
		{
			if (_target != null) _target.removeEventListener(StylePhase.STYLE, onStyle);
			DataChange.change(this, "target", _target, _target = value);
			if (_target != null) _target.addEventListener(StylePhase.STYLE, onStyle, false, -10, true);
		}
		private var _target:DisplayObject;
		
		override flash_proxy function getProperty(name:*):*
		{
			var prop:String = name.localName;
			return prop in explicitData ? explicitData[prop] : styleData[prop];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var prop:String = name.localName;
			DataChange.change(this, prop, prop in explicitData ? explicitData[prop] : styleData[prop], explicitData[name.localName] = value);
			if (hasEventListener(StyleEvent.STYLE_CHANGE)) {
				dispatchEvent(new StyleEvent(StyleEvent.STYLE_CHANGE, false, false, prop, value));
			}
			changes[prop] = value;
			RenderPhase.invalidate(_target, StylePhase.STYLE);
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var prop:String = name.localName;
			return prop in explicitData || prop in styleData;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var prop:String = name.localName;
			var deleted:Boolean = delete explicitData[prop];
			if (hasEventListener(StyleEvent.STYLE_CHANGE)) {
				dispatchEvent(new StyleEvent(StyleEvent.STYLE_CHANGE, false, false, prop, styleData[prop]));
			}
			changes[prop] = styleData[prop];
			RenderPhase.invalidate(_target, StylePhase.STYLE);
			return deleted;
		}
		
		// ========== Dispatcher Methods ========== //
		
		/**
		 * Registers an event listener object with an EventDispatcher object so
		 * that the listener receives notification of an event. You can register
		 * event listeners on all nodes in the display list for a specific type
		 * of event, phase, and priority.
		 * 
		 * @param	type				The type of event.
		 * @param	listener			The listener function that processes the
		 * 								event.
		 * @param	useCapture			Determines whether the listener works in
		 * 								the capture phase or the target and
		 * 								bubbling phases.
		 * @param	priority			The priority level of the event
		 * 								listener.
		 * @param	useWeakReference	Determines whether the reference to the
		 * 								listener is strong or weak.
		 * 
		 * @see		flash.events.EventDispatcher#addEventListener
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a listener from the Dispatcher object. If there is no
		 * matching listener registered with the Dispatcher object, a call
		 * to this method has no effect.
		 * 
		 * @param	type				The type of event.
		 * @param	listener			The listener object to remove.
		 * @param	useCapture			Specifies whether the listener was
		 * 								registered for the capture phase or the
		 * 								target and bubbling phases.
		 * 
		 * @see		flash.events.EventDispatcher#removeEventListener
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Dispatches an event into the event flow, but only if there is a
		 * registered listener. If the generic Event object is all that is 
		 * required the dispatch() method is recommended.
		 * 
		 * @param	event				The Event object that is dispatched into
		 * 								the event flow.
		 * 
		 * @return						A value of true if the event was
		 * 								successfully dispatched.
		 *  
		 * @see		flash.events.EventDispatcher#dispatchEvent
		 * @see		flight.events.Dispatcher#dispatch
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		/**
		 * Checks whether the Dispatcher object has any listeners
		 * registered for a specific type of event. This check is made before
		 * any events are dispatched.
		 * 
		 * @param	type				The type of event.
		 * 
		 * @return						A value of true if a listener of the
		 * 								specified type is registered; false
		 * 								otherwise.
		 * 
		 * @see		flight.events.EventDispatcher#hasEventListener
		 */
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * Checks whether an event listener is registered with this
		 * Dispatcher object or any of its ancestors for the specified
		 * event type. Because ancesry is only available through the display
		 * list, this method behaves identically to hasEventListener().
		 * 
		 * @param	type				The type of event.
		 * 
		 * @return						A value of true if a listener of the
		 * 								specified type will be triggered; false
		 * 								otherwise.
		 * 
		 * @see		flight.events.EventDispatcher#willTrigger
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		private function onStyle(event:Event):void
		{
			var stylesChanged:Object = changes;
			changes = {};
			if (hasEventListener(StyleEvent.STYLES_CHANGED)) {
				dispatchEvent(new StyleEvent(StyleEvent.STYLES_CHANGED, false, false, null, null, stylesChanged));
			}
		}
	}
}
