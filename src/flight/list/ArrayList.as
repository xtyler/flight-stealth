/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.list
{
	import flight.data.IListSelection;
	import flight.data.ListSelection;
	import flight.events.ListEvent;
	
	dynamic public class ArrayList extends ArrayPlus implements IList
	{
		public function ArrayList(source:Array = null)
		{
			super(source);
		}
		
		[Bindable(event="selectionChange", style="noEvent")]
		public function get selected():IListSelection { return _selected ||= new ListSelection(this); }
		private var _selected:ListSelection;
		
		public function add(items:*, index:int = 0x7FFFFFFF):*
		{
			if (items is Array) {
				if (index >= length) {
					push.apply(this, items);
				} else {
					Array(items).unshift(index, 0);
					splice.apply(this, items);
				}
			} else {
				if (index >= length) {
					push(items);
				} else {
					splice(index, 0, items);
				}
			}
			return items;
		}
		
		public function contains(item:Object):Boolean
		{
			return indexOf(item) != -1;
		}
		
		public function get(index:int = 0, length:uint = 0):*
		{
			if (length > 0) {
				return slice(index, index + length);
			}
			
			if (index < 0) {
				index = length - index <= 0 ? 0 : length - index;
			}
			return this[index];
		}
		
		public function getIndex(item:Object):int
		{
			return indexOf(item);
		}
		
		public function getById(id:Object, field:String = "id"):Object
		{
			for each (var item:Object in this) {
				if (field in item && item[field] == id) {
					return item;
				}
			}
			return null;
		}
		
		public function remove(item:Object):Object
		{
			var index:int = indexOf(item);
			return (index != -1) ? removeAt(index) : null;
		}
		
		public function removeAt(index:int = 0, length:uint = 0):*
		{
			if (length > 0) {
				return splice(index, length);
			}
			return splice(index, 1)[0];
		}
		
		public function setIndex(item:Object, index:int):Object
		{
			var oldIndex:int = indexOf(item);
			if (oldIndex == -1) {
				return add(item, index);
			} else if (index < 0) {
				index = Math.max(length + index, 0);
			}
			
			_splice(oldIndex, 1);
			_splice(index, 0, item);
			if (hasEventListener(ListEvent.LIST_CHANGE)) {
				dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false, null, null, index, oldIndex));
			}
			return item;
		}
		
		public function swap(item1:Object, item2:Object):void
		{
			var index1:int = indexOf(item1);
			var index2:int = indexOf(item2);
			swapAt(index1, index2);
		}
		
		public function swapAt(index1:int, index2:int):void
		{
			var item1:Object = this[index1];
			var item2:Object = this[index2];
			this[index1] = item2;
			this[index2] = item1;
			if (hasEventListener(ListEvent.LIST_CHANGE)) {
				dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, this, false, false, null, null, index1, index2));
			}
		}
	}
}
