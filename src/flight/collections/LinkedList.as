/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.collections
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class LinkedList implements IList
	{
		protected var head:Object;
		protected var tail:Object;
		protected var next:Dictionary = new Dictionary(true);
		protected var prev:Dictionary = new Dictionary(true);
		
		public function LinkedList()
		{
		}
		
		public function get length():uint { return _length; }
		private var _length:uint = 0;
		
		public function add(items:*, index:int = int.MAX_VALUE):*
		{
			var node:Object = getNode(index);
			
			if (items is Array) {
				for each (var item:Object in items) {
					next[item] = next[node];
					next[node] = item;
					prev[item] = node;
					node = item;
					++_length;
				}
			} else {
				next[items] = next[node];
				next[node] = items;
				prev[items] = node;
				node = items;
				++_length;
			}
			
			if (!next[node]) {
				tail = node;
			} else if (!prev[node]) {
				head = node;
			}
			
			return items;
		}
		
		public function contains(item:Object):Boolean
		{
			return item in next || item == head;
		}
		
		public function get (index:int = 0, length:uint = 0):*
		{
			var node:Object = getNode(index);
			if (!length) {
				return node;
			}
			
			var items:Array = [];
			while (length-- && node) {
				items.push(node);
				node = next[node];
			}
			return items;
		}
		
		public function getById(id:Object, field:String = "id"):Object
		{
			var node:Object = head;
			while (node) {
				if (field in node && node[field] == id) {
					return node;
				}
				node = next[node];
			}
			return null;
		}
		
		public function getIndex(item:Object, fromIndex:int = 0):int
		{
			if (fromIndex < 0) {
				fromIndex = _length - fromIndex > 0 ? _length - fromIndex : 0;
			} else if (fromIndex > _length) {
				fromIndex = _length;
			}
			
			var index:int = fromIndex;
			var node:Object = head;
			while (index--) {
				node = next[node];
			}
			
			while (node) {
				if (node == item) {
					return fromIndex + index;
				}
				++index;
				node = next[node];
			}
			return -1;
		}
		
		public function getLastIndex(item:Object, fromIndex:int = int.MAX_VALUE):int
		{
			if (fromIndex < 0) {
				fromIndex = _length - fromIndex > 0 ? _length - fromIndex : 0;
			} else if (fromIndex > _length) {
				fromIndex = _length;
			}
			
			var index:int = _length - fromIndex;
			var node:Object = tail;
			while (index--) {
				node = prev[node];
			}
			
			while (node) {
				if (node == item) {
					return fromIndex - index;
				}
				++index;
				node = next[node];
			}
			return -1;
		}
		
		public function remove(item:Object):Object
		{
			if (!contains(item)) {
				return null;
			}
			prev[next[item]] = prev[item];
			next[prev[item]] = next[item];
			delete prev[item];
			delete next[item];
			--_length;
			return item;
		}
		
		public function removeAt(index:int = 0, length:uint = 0):*
		{
			var node:Object = getNode(index);
			if (!node) {
				return null;
			} else if (!length) {
				return remove(node);
			}
			
			var prevNode:Object = prev[node];
			var nextNode:Object;
			var items:Array = [];
			while (length-- && node) {
				items.push(node);
				node = nextNode;
				nextNode = next[node];
				delete prev[node];
				delete next[node];
				--_length;
			}
			next[prevNode] = nextNode;
			prev[nextNode] = prevNode;
			return items;
		}
		
		public function set (index:int, item:Object):Object
		{
			var node:Object = getNode(index);
			prev[item] = prev[node];
			next[item] = next[node];
			prev[next[item]] = item;
			next[prev[item]] = item;
			delete prev[node];
			delete next[node];
			return item;
		}
		
		public function setIndex(item:Object, index:int):Object
		{
			if (!contains(item)) {
				return add(item, index);
			}
			remove(item);
			var node:Object = getNode(index);
			next[prev[node]] = item;
			prev[item] = prev[node];
			next[item] = node;
			prev[node] = item;
			return item;
		}
		
		public function swap(item1:Object, item2:Object):void
		{
			prev[next[item1]] = item2;
			next[prev[item1]] = item2;
			prev[next[item2]] = item1;
			next[prev[item2]] = item1;
			
			var prevNode:Object = prev[item1];
			var nextNode:Object = next[item1];
			prev[item1] = prev[item2];
			next[item1] = next[item2];
			prev[item2] = prevNode;
			next[item2] = nextNode;
		}
		
		public function swapAt(index1:int, index2:int):void
		{
			swap(getNode(index1), getNode(index2));
		}
		
		protected function getNode(index:int):Object
		{
			if (index < 0) {
				index = _length - index > 0 ? _length - index : 0;
			}
			
			var node:Object;
			if (index < _length/2) {
				node = head;
				while (index--) {
					node = next[node];
				}
			} else {
				node = tail;
				index = index < _length ? _length - index : 0;
				while (index--) {
					node = prev[node];
				}
			}
			return node;
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
		}
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
		}
	}
}
