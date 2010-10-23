/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.list
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import flight.data.DataChange;
	import flight.data.IListSelection;
	import flight.data.ListSelection;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	
	use namespace flash_proxy;
	use namespace list_internal;
	
	/**
	 * Dispatched when the ArrayList has been updated in some way.
	 * 
	 * @eventType	flight.events.ListEvent.LIST_CHANGE
	 */
	[Event(name="listChange", type="flight.events.ListEvent")]
	
	/**
	 * A simple implementation of Flight's IList that wraps an Array, Vector or
	 * XMLList.
	 * 
	 * @see		flight.list.IList
	 */
	dynamic public class ArrayList extends Proxy implements IList, IExternalizable
	{
		/**
		 * Reference to the wrapped IEventDispatcher.
		 */
		protected var dispatcher:EventDispatcher;
		
		// the array, vector or XMLListAdapter
		private var adapter:*;
		
		public function ArrayList(source:* = null)
		{
			dispatcher = new EventDispatcher();
			this.source = source || [];
		}
		
		[Bindable(event="idFieldChange", style="noEvent")]
		public function get idField():String { return _idField }
		public function set idField(value:String):void
		{
			DataChange.change(this, "idField", _idField, _idField = value);
		}
		private var _idField:String = "id";		// TODO: replace with dataMap
		
		[Bindable(event="listChange", style="noEvent")]
		public function get length():int { return adapter.length; }
		
		[Bindable(event="selectionChange", style="noEvent")]
		public function get selection():IListSelection { return _selection || (_selection = new ListSelection(this)); }
		private var _selection:ListSelection;
		
		/**
		 * The source Array, Vector or XMLList for this ArrayList. Changes made
		 * through the IList interface will be reflected by the source. If no  
		 * source is supplied the ArrayList will create an Array internally.
		 * 
		 * <p>Changes made directly to the underlying source (e.g., calling
		 * <code>myList.source.pop()</code> will not cause
		 * <code>ListEvents</code> to be dispatched.</p>
		 */
		[Bindable(event="sourceChange", style="noEvent")]		
		public function get source():* { return _source; }
		public function set source(value:*):void
		{
			if (value == null) {
				value = [];
			} else if (_source == value) {
				return;
			}
			
			if (value is XMLList) {
				adapter = new XMLListAdapter(this);
			} else {
				if (!("splice" in value)) {		// wrap if not a vector or array
					value = [value];
				}
				adapter = value;
			}
			var items:* = _source;
			DataChange.change(this, "source", _source, _source = value);
			dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.RESET, items, 0));
		}
		list_internal var _source:*;	// internally available to XMLListAdapter
		
		/**
		 * Add the specified item to the end of the list.
		 * 
		 * @param	item			The item to be added.
		 */
		public function addItem(item:Object):Object
		{
			var oldValue:int = adapter.length;
			adapter.push(item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD,
										 adapter.slice(oldValue, oldValue+1), oldValue) );
			return item;
		}
		
		/**
		 * Add the item at the specified index. Items on or following the index
		 * will be moved down by one.  
		 *   
		 * 
		 * @param	item			The item to be added.
		 * @param	index			The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			adapter.splice(index, 0, item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD,
										 adapter.slice(index, index+1), index) );
			return item;
		}
		
		public function addItems(items:*, index:int = 0x7FFFFFFF):*
		{
			// empty list
			if (items[0] === undefined) {
				return items;
			}
			
			var oldValue:int = adapter.length;
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			} else if (index > oldValue) {
				index = oldValue;
			}
			adapter.splice.apply(adapter, [index, 0].concat(items));
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD, items, index) );
			return items;
		}
		
		public function containsItem(item:Object):Boolean
		{
			return Boolean(adapter.indexOf(item) != -1);
		}
		
		/**
		 * Get the item at the specified index.
		 * 
		 * @param	index			The index from which to retrieve the item.
		 * @param	prefetch		Unused in this implementation of IList.
		 * 
		 * @return					The item at the specified index.
		 */
		public function getItemAt(index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			return _source[index];
		}
		
		public function getItemById(id:String):Object
		{
			for each (var item:Object in _source) {
				if (idField in item && item[idField] == id) {
					return item;
				}
			}
			return null;
		}
		
		/**
		 * Returns the index of the item in the collection.
		 * 
		 * @param	item			The item to locate.
		 * 
		 * @return					The index of the item, or -1 if the item is
		 * 							not found.
		 */
		public function getItemIndex(item:Object):int
		{
			return adapter.indexOf(item);
		}
		
		public function getItems(index:int=0, length:int = 0x7FFFFFFF):*
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			length = Math.max(length, 0);
			return adapter.slice(index, length+index);
		}
		
		/**
		 * Removes the specified item from this list.
		 * 
		 * @param	item			The item to remove.
		 * 
		 * @return					The item that was removed.
		 */
		public function removeItem(item:Object):Object
		{
			var index:int = adapter.indexOf(item);
			return (index != -1) ? removeItemAt(index) : null;
		}
		
		/**
		 * Remove the item at the specified index. Items following the index
		 * will be moved up by one.  
		 * 
		 * @param	index			The index from which to remove the item.
		 * @return					The item that was removed.
		 */
		public function removeItemAt(index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			var items:* = adapter.splice(index, 1);
			// empty list
			if (items[0] !== undefined) {
				dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REMOVE, items, index) );
			}
			return items[0];
		}
		
		public function removeItems(index:int=0, length:int = 0x7FFFFFFF):*
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			var items:* = adapter.splice(index, length);
			// empty list
			if (items[0] !== undefined) {
				dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REMOVE, items, index) );
			}
			return items;
		}
		
		/**
		 * Place the item at the specified index. If an item already exists at
		 * the specified location it will be replaced by the new item.
		 * 
		 * @param	item			The new item to set.
		 * @param	index			The index at which to place the item.
		 * 
		 * @return					The item that was replaced, or null.
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			adapter.splice(index, 0, item);
			var items:* = adapter.slice(index, index + 2);
			adapter.splice(index + 1, 1);
			
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REPLACE, items, index) );
			return item;
		}
		
		public function setItemIndex(item:Object, index:int):Object
		{
			var oldIndex:int = adapter.indexOf(item);
			if (oldIndex == -1) {
				return addItemAt(item, index);
			} else if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			
			var items:* = adapter.splice(oldIndex, 1);
			adapter.splice(index, 0, item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.MOVE, items, index, oldIndex) );
			return item;
		}
		
		public function swapItems(item1:Object, item2:Object):void
		{
			var index1:int = adapter.indexOf(item1);
			var index2:int = adapter.indexOf(item2);
			swapItemsAt(index1, index2);
		}
		
		public function swapItemsAt(index1:int, index2:int):void
		{
			if (index1 > index2) {
				var temp:int = index1;
				index1 = index2;
				index2 = temp;
			}
			
			var item1:Object = _source[index1];
			var item2:Object = _source[index2];
			
			var items:* = adapter.splice(index2, 1);
			if (items is XMLList) {
				items += adapter.splice(index1, 1, item2);
			} else {
				items.push( adapter.splice(index1, 1, item2) );
			}
			adapter.splice(index2, 0, item1);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.MOVE, items, index1, index2) );
		}
		
		public function equals(value:Object):Boolean
		{
			if ("source" in value) {
				value = value["source"];
			}
			
			for (var i:int = 0; i < adapter.length; i++) {
				if (_source[i] != value[i]) {
					return false;
				}
			}
			return true;
		}
		
		public function clone():Object
		{
			return new ArrayList( adapter.concat() );
		}
		
		/**
		 *  Ensures that only the source property is seralized.
		 *  @private
		 */
		public function readExternal(input:IDataInput):void
		{
			source = input.readObject();
		}
		
		/**
		 *  Ensures that only the source property is serialized.
		 *  @private
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_source);
		}
		
		// ========== Proxy Methods ========== //
		
		override flash_proxy function getProperty(name:*):*
		{
			return _source[name];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_source[name] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			return delete _source[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return (name in _source);
		}
		
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			return _source[name].apply(_source, rest);
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return _source[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return (index + 1) % (adapter.length + 1);
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
	}
}

import flight.list.ArrayList;

namespace list_internal;

class XMLListAdapter
{
	use namespace list_internal;
	
	public var source:XMLList;
	public var list:ArrayList;
	
	public function get length():uint
	{
		return source.length();
	}
	
	public function XMLListAdapter(list:ArrayList)
	{
		this.list = list;
		source = list.source;
	}
	
	public function indexOf(searchElement:*, fromIndex:int = 0):int
	{
		for (var i:int = fromIndex; i < source.length(); i++) {
			if (source[i] == searchElement) {
				return i;
			}
		}
		return -1;
	}
	
	public function concat(... args):XMLList
	{
		var items:XMLList = source.copy();
		for each (var xml:Object in args) {
			items += xml;
		}
		return items;
	}
	
	public function push(... args):uint
	{
		for each (var node:XML in args) {
			source += node;
		}
		list._source = source;
		return source.length();
	}
	
	public function slice(startIndex:int = 0, endIndex:int = 0x7FFFFFFF):XMLList
	{
		if (startIndex < 0) {
			startIndex = Math.max(source.length() + startIndex, 0);
		}
		if (endIndex < 0) {
			endIndex = Math.max(source.length() + endIndex, 0);
		}
		
		// remove trailing items
		var items:XMLList = source.copy();
		while (endIndex < items.length()) {
			delete items[endIndex];
		}
		
		// now remove from the front
		endIndex = items.length() - startIndex;
		while (endIndex < items.length()) {
			delete items[0];
		}
		
		return items;
	}
		
	public function splice(startIndex:int, deleteCount:uint, ... values):XMLList
	{
		startIndex = Math.min(startIndex, source.length());
		if (startIndex < 0) {
			startIndex = Math.max(source.length() + startIndex, 0);
		}
		
		// remove deleted items
		var deletedItems:XMLList = new XMLList();
		for (var i:int = 0; i < deleteCount; i++) {
			deletedItems += source[startIndex];
			delete source[startIndex];
		}
		
		// build values to insert
		var insertedItems:XMLList = new XMLList();
		for each (var item:Object in values) {
			insertedItems += item;
		}
		source[startIndex] = (startIndex < source.length()) ?
							 insertedItems + source[startIndex] :
							 insertedItems;
		
		list._source = source;
		return deletedItems;
	}
	
}
