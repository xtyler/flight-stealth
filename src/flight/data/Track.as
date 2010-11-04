/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	public class Track extends Position implements ITrack
	{
		public function Track(min:Number = 0, max:Number = 100)
		{
			super(min, max);
		}
		
		[Bindable(event="stepSizeChange", style="noEvent")]
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(value:Number):void
		{
			DataChange.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		private var _stepSize:Number = 1;
		
		[Bindable(event="pageSizeChange", style="noEvent")]
		public function get pageSize():Number { return _pageSize; }
		public function set pageSize(value:Number):void
		{
			DataChange.change(this, "pageSize", _pageSize, _pageSize = value);
		}
		private var _pageSize:Number = 10;
		
		public function stepForward():Number
		{
			return value += _stepSize;
		}
		
		public function stepBackward():Number
		{
			return value -= _stepSize;
		}
		
		public function pageForward():Number
		{
			return value += _pageSize;
		}
		
		public function pageBackward():Number
		{
			return value -= _pageSize;
		}
	}
}
