package flight.list
{
	import flight.events.CentralDispatcher;
	import flight.events.ListEvent;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	[Event(name="listChange", type="flight.events.ListEvent")]
	
	dynamic public class ArrayPlus extends Array implements IEventDispatcher
	{
		public function ArrayPlus(source:Array = null)
		{
			if (source) {
				super.push.apply(this, source);
			}
		}
		
		[Bindable(event="listChange")]
		override public function get length():uint { return super.length; }
		
		public function set(index:int, item:Object):Object
		{
			if (index < 0) {
				index = length - index <= 0 ? 0 : length - index;
			}
			var value:* = this[index];
			this[index] = item;
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					[item], [value], index, index));
			}
			return item;
		}
		
		override AS3 function push(...args):uint
		{
			var loc:int = length;
			var len:int = super.AS3::push.apply(this, args);
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					args, null, loc, len-1));
			}
			return len;
		}
		
		override AS3 function pop():*
		{
			var len:int = length-1;
			var value:* = super.AS3::pop();
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					null, [value], len, len));
			}
			return value;
		}

		override AS3 function shift():*
		{
			var value:* = super.AS3::shift();
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					null, [value], 0, 0));
			}
			return value;
		}

		override AS3 function unshift(...args):uint
		{
			var len:int = super.AS3::unshift.apply(this, args);
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					args, null, 0, args.length-1));
			}
			return len;
		}
		
		override AS3 function reverse():Array
		{
			super.AS3::reverse();
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					null, null, 0, length-1));
			}
			return this;
		}

		override AS3 function splice(...args):*
		{
			var len:int = length;
			var startIndex:int = args[0];
			if (startIndex < 0) {
				startIndex = args[0] = len - startIndex <= 0 ? 0 : len - startIndex;
			} else if (startIndex > len) {
				startIndex = len;
			}
			var deleteValues:Array = super.AS3::splice.apply(this, args);
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				var deleteCount:Number = args[1];
				var values:Array = args[2] as Array;
				var max:int = isNaN(deleteCount) ? len-1-startIndex : deleteCount;
				if (values && values.length-1 > max) {
					max = values.length-1;
				}
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					values, deleteValues, startIndex, max));
			}
			return deleteValues;
		}

		override AS3 function sort(...args):*
		{
			var value:* = super.AS3::sort.apply(this, args);
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					null, null, 0, length));
			}
			return value;
		}
		
		override AS3 function sortOn(names:*, options:* = 0, ...args):*
		{
			args.unshift(names, options);
			var value:* = super.AS3::sortOn.apply(this, args);
			if (CentralDispatcher.hasEventListener(ListEvent.LIST_CHANGE, this)) {
				CentralDispatcher.dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false,
					null, null, 0, length));
			}
			return value;
		}
		
		override AS3 function concat(...args):Array
		{
			var value:ArrayPlus = new this['constructor']();
			value._push.apply(value, this);
			for each (var o:Object in args) {
				if (o is Array) {
					value._push.apply(value, o);
				} else {
					value._push(o);
				}
			}
			return value;
		}
		
		override AS3 function slice(startIndex:* = 0, endIndex:* = 16777215):Array
		{
			var value:ArrayPlus = new this['constructor']();
			value._push.apply(value, super.AS3::slice(startIndex, endIndex));
			return value;
		}

		override AS3 function filter(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayPlus = new this['constructor']();
			value._push.apply(value, super.AS3::filter(callback, thisObject));
			return value;
		}

		override AS3 function map(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayPlus = new this['constructor']();
			value._push.apply(value, super.AS3::map(callback, thisObject));
			return value;
		}
		
		internal function _push(...args):uint
		{
			return super.AS3::push.apply(this, args);
		}
		
		internal function _pop():*
		{
			return super.AS3::pop();
		}

		internal function _shift():*
		{
			return super.AS3::shift();
		}

		internal function _unshift(...args):uint
		{
			return super.AS3::unshift.apply(this, args);
		}
		
		internal function _reverse():Array
		{
			return super.AS3::reverse();
		}

		internal function _splice(...args):*
		{
			return super.AS3::splice.apply(this, args);
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
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			CentralDispatcher.addEventListener(type, this, listener, useCapture, priority, useWeakReference);
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
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			CentralDispatcher.removeEventListener(type, this, listener, useCapture);
		}
		
		/**
		 * Dispatches an event into the event flow, but only if there is a
		 * registered listener. If a generic Event object is all that is 
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
			return CentralDispatcher.dispatchEvent(event);
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
			return CentralDispatcher.hasEventListener(type, this);
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
			return CentralDispatcher.willTrigger(type, this);
		}
	}
}
