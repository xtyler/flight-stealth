/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.data.DataChange;
	import flight.skins.ISkin;
	import flight.skins.ISkinnable;
	import flight.styles.IStateful;

	public class Container extends Group implements ISkinnable
	{
		public function Container()
		{
		}
		
		// IStateful implementation
		
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		private var _currentState:String;
		
		[Bindable(event="dataChange", style="weak")]
		public function get data():Object { return _data }
		public function set data(value:Object):void
		{
			DataChange.change(this, "data", _data, _data = value);
		}
		private var _data:Object;
		
		[Bindable(event="skinChange", style="weak")]
		public function get skin():Object { return _skin }
		public function set skin(value:Object):void
		{
			DataChange.change(this, "skin", _skin, _skin = value);
		}
		private var _skin:Object;
	}
}
