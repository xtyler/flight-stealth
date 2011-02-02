/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.EventDispatcher;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	public class ListSelection extends EventDispatcher implements IListSelection
	{
		private var list:IList;
		private var updatingLists:Boolean;
		
		public function ListSelection(list:IList)
		{
			this.list = list;
			list.addEventListener(ListEvent.LIST_CHANGE, onListChange, false, 10);
			_indices = new ArrayList();
			_indices.addEventListener(ListEvent.LIST_CHANGE, onSelectionChange, false, 10);
			_items = new ArrayList();
			_items.addEventListener(ListEvent.LIST_CHANGE, onSelectionChange, false, 10);
		}
		
		
		[Bindable(event="mutliselectChange", style="noEvent")]
		public function get multiselect():Boolean { return _multiselect }
		public function set multiselect(value:Boolean):void
		{
			DataChange.change(this, "multiselect", _multiselect, _multiselect = value);
		}
		private var _multiselect:Boolean = false;
		
		
		[Bindable(event="indexChange", style="noEvent")]
		public function get index():int { return _index; }
		public function set index(value:int):void
		{
			// restrict value within -1 (deselect) and highest possible index
			value = value < -1 ? -1 : (value > list.length - 1 ? list.length - 1 : value);
			if (_index != value) {
				DataChange.queue(this, "item", _item, _item = list.get(value));
				DataChange.queue(this, "index", _index, _index = value);
				// TODO: optimize list selection
				updatingLists = true;
				_indices.source = [_index];
				_items.source = [_item];
				updatingLists = false;
				DataChange.change();
			}
		}
		private var _index:int = -1;
		
		[Bindable(event="itemChange", style="noEvent")]
		public function get item():Object { return _item; }
		public function set item(value:Object):void
		{
			var i:int = list.getIndex(value);
			if (i == -1) {
				value = null;
			}
			if (_item != value) {
				DataChange.queue(this, "item", _item, _item = value);
				DataChange.queue(this, "index", _index, _index = i);
				updatingLists = true;
				_items.source = [_item];
				_indices.source = [_index];
				updatingLists = false;
			}
		}
		private var _item:Object = null;
		
		[Bindable(event="indicesChange", style="noEvent")]
		public function get indices():IList { return _indices; }
		private var _indices:ArrayList;
		
		[Bindable(event="itemsChange", style="noEvent")]
		public function get items():IList { return _items; }
		private var _items:ArrayList = new ArrayList();
		
		public function select(items:*):void
		{
			_items.source = items;
		}
		
		private function onListChange(event:ListEvent):void
		{
			var tmpItems:Array = [];
			for (var i:int = 0; i < _items.length; i++) {
				var item:Object = _items.get(i);
				var index:int = list.getIndex(item);
				
				if (index != -1) {
					tmpItems.push(item);
				}
			}
			
			_items.source = tmpItems;
		}
		
		private function onSelectionChange(event:ListEvent):void
		{
			if (updatingLists) {
				return;
			}
			
			var list1:ArrayList = event.target as ArrayList;
			if (!multiselect && list1.length > 1) {
				list1.source = event.added != null ? event.added[0] : list1.get(0);
				event.stopImmediatePropagation();
				return;
			}
			
			var list2:ArrayList = (list1 == _indices) ? _items : _indices;
			var getData:Function = (list1 == _indices) ? list.get : list.getIndex;
			var tmpArray:Array;
			var tmpObject:Object;
			
			updatingLists = true;
			switch (event.kind) {
				case ListEventKind.ADD:
					tmpArray = [];
					for each (tmpObject in event.added) {
						tmpArray.push( getData(tmpObject) );
					}
					list2.add(tmpArray, event.from);
					break;
				case ListEventKind.REMOVE:
					list2.removeAt(event.from, event.added.length);
					break;
				case ListEventKind.MOVE:
					if (event.added.length == 1) {
						tmpObject = getData(event.added[0]);
						list2.setIndex(tmpObject, event.from);
					} else {
						list2.swapAt(event.from, event.to);
					}
					break;
				case ListEventKind.REPLACE:
					tmpObject = getData(event.added[0]);
					list2.set(tmpObject, event.from);
					break;
				default:	// ListEventKind.RESET
					tmpArray = [];
					for (var i:int = 0; i < list1.length; i++) {
						tmpObject = list1.get(i);
						tmpArray.push( getData(tmpObject) );
					}
					list2.source = tmpArray;
					break;
			}
			updatingLists = false;
			
			var oldIndex:int = _index;
			var oldItem:Object = _item;
			index = _indices.length > 0 ? _indices.get(0) as Number : -1;
			item = _items.get(0);
		}
		
	}
}
