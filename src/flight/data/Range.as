/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.EventDispatcher;
	
	public class Range extends EventDispatcher implements IRange
	{
		
		private var _min:Number = 0;
		[Bindable(event="minChange", style="weak")]
		public function get min():Number { return _min; }
		public function set min(value:Number):void
		{
			if (_min != value) {
				DataChange.queue(this, "min", _min, _min = value);
				if (_max < _min) {
					DataChange.queue(this, "max", _max, _max = _min);
				}
				position = _position;
			}
		}
		
		private var _max:Number = 0;
		[Bindable(event="maxChange", style="weak")]
		public function get max():Number { return _max;}
		public function set max(value:Number):void
		{
			if (_max != value) {
				DataChange.queue(this, "max", _max, _max = value);
				if (_min > _max) {
					DataChange.queue(this, "min", _min, _min = _max);
				}
				position = _position;
			}
		}
		
		private var _position:Number = 0;
		[Bindable(event="positionChange", style="weak")]
		public function get position():Number { return _position; }
		public function set position(value:Number):void
		{
			value = value <= _min ? _min : (value > _max ? _max : value);
			var p:Number = 1 / _precision;
			value = Math.round(value * p) / p;
			if (_position != value) {
				DataChange.queue(this, "position", _position, _position = value);
				value = _min == _max ? 0 : (_position - _min) / (_max - _min);
				DataChange.queue(this, "percent", _percent, _percent = value);
			}
			DataChange.change();
		}
		
		private var _percent:Number = 0;
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void
		{
			if (_percent != value) {
				position = _min + value * (_max - _min);
			}
		}
		
		private var _stepSize:Number = 1;
		[Bindable(event="stepSizeChange", style="weak")]
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(value:Number):void
		{
			DataChange.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		
		private var _precision:Number = _stepSize;
		[Bindable(event="precisionChange", style="weak")]
		public function get precision():Number { return _precision; }
		public function set precision(value:Number):void
		{
			if (_precision != value) {
				DataChange.queue(this, "precision", _precision, _precision = value);
				position = _position;
			}
		}
		
		public function Range(min:Number = 0, max:Number = 10)
		{
			_min = min;
			_max = max;
		}
		
		
		public function stepForward():Number
		{
			return position += _stepSize;
		}
		
		public function stepBackward():Number
		{
			return position -= _stepSize;
		}
		
	}
}
