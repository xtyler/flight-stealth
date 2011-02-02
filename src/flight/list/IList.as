/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.list
{
	import flash.events.IEventDispatcher;

	import flight.data.IListSelection;

	public interface IList extends IEventDispatcher
	{
		function get length():uint;
		function get selected():IListSelection;
		
		function add(items:*, index:int = 0x7FFFFFFF):*;			// combined addItem, addItemAt, addItems
		function contains(item:Object):Boolean;						// was containsItem
		function get(index:int = 0, length:uint = 0):*;				// combined getItemAt, getItems
		function getIndex(item:Object):int;							// was getItemIndex
		function getById(id:Object, field:String = "id"):Object;	// was getItemById
		function remove(item:Object):Object;						// was removeItem
		function removeAt(index:int = 0, length:uint = 0):*;		// combined removeItemAt, removeItems
		function set(index:int, item:Object):Object;				// was setItemAt
		function setIndex(item:Object, index:int):Object;			// was setItemIndex
		function swap(item1:Object, item2:Object):void				// was swapItems
		function swapAt(index1:int, index2:int):void				// was swapItemsAt
		
	}
}
