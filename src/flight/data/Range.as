/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Range extends EventDispatcher implements IRange
	{
		public function Range(min:Number = 0, max:Number = 10)
		{
			_min = min;
			_max = max;
		}
		
		[Bindable(event="minChange", style="noEvent")]
		public function get min():Number { return _min; }
		public function set min(value:Number):void
		{
			if (_min != value) {
				DataChange.queue(this, "min", _min, _min = value);
				if (_max < _min) {
					DataChange.queue(this, "max", _max, _max = _min);
				}
				value = _value;
			}
		}
		private var _min:Number = 0;
		
		[Bindable(event="maxChange", style="noEvent")]
		public function get max():Number { return _max;}
		public function set max(value:Number):void
		{
			if (_max != value) {
				DataChange.queue(this, "max", _max, _max = value);
				if (_min > _max) {
					DataChange.queue(this, "min", _min, _min = _max);
				}
				value = _value;
			}
		}
		private var _max:Number = 0;
		
		[Bindable(event="valueChange", style="noEvent")]
		public function get value():Number { return _value; }
		public function set value(value:Number):void
		{
			value = value <= _min ? _min : (value > _max ? _max : value);
			var p:Number = 1 / _precision;
			value = Math.round(value * p) / p;
			if (_value != value) {
				DataChange.queue(this, "value", _value, _value = value);
				value = _min == _max ? 0 : (_value - _min) / (_max - _min);
				DataChange.queue(this, "percent", _percent, _percent = value);
				dispatchEvent(new Event(Event.CHANGE));
			}
			DataChange.change();
		}
		private var _value:Number = 0;
		
		[Bindable(event="percentChange", style="noEvent")]
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void
		{
			if (_percent != value) {
				value = _min + value * (_max - _min);
			}
		}
		private var _percent:Number = 0;
		
		[Bindable(event="precisionChange", style="noEvent")]
		public function get precision():Number { return _precision; }
		public function set precision(value:Number):void
		{
			if (_precision != value) {
				DataChange.queue(this, "precision", _precision, _precision = value);
				value = _value;
			}
		}
		private var _precision:Number = 1;
		
		[Bindable(event="stepSizeChange", style="noEvent")]
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(value:Number):void
		{
			DataChange.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		private var _stepSize:Number = 1;
		
		public function stepForward():Number
		{
			return value += _stepSize;
		}
		
		public function stepBackward():Number
		{
			return value -= _stepSize;
		}
		
	}
}
