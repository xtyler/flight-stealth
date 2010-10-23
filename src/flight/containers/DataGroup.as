/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.data.DataChange;
	import flight.list.IList;
	
	/**
	 * @alpha - DataGroup is currently non-functional
	 */
	public class DataGroup extends Group
	{
		[ArrayElementType("Object")]
		[Bindable(event="dataProviderChange", style="noEvent")]
		public function get dataProvider():IList { return _dataProvider }
		public function set dataProvider(value:IList):void
		{
			DataChange.change(this, "dataProvider", _dataProvider, _dataProvider = value);
		}
		private var _dataProvider:IList;
		
		[Bindable(event="templateChange", style="noEvent")]
		public function get template():Object { return _template }
		public function set template(value:Object):void
		{
			DataChange.change(this, "template", _template, _template = value);
		}
		private var _template:Object;
	}
}
