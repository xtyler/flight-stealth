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
	
	public class Position extends EventDispatcher implements IPosition
	{
		public function Position(minimum:Number = 0, maximum:Number = 100)
		{
			this.minimum = minimum;
			this.maximum = maximum;
		}
		
		[Bindable(event="minimumChange", style="noEvent")]
		public function get minimum():Number { return _minimum; }
		public function set minimum(value:Number):void
		{
			if (_minimum != value) {
				DataChange.queue(this, "minimum", _minimum, _minimum = value);
				if (_maximum < _minimum) {
					DataChange.queue(this, "maximum", _maximum, _maximum = _minimum);
				}
				DataChange.queue(this, "size", _size, _size = _maximum - _minimum);
				this.value = _value;
			}
		}
		private var _minimum:Number = 0;
		
		[Bindable(event="maximumChange", style="noEvent")]
		public function get maximum():Number { return _maximum;}
		public function set maximum(value:Number):void
		{
			if (_maximum != value) {
				DataChange.queue(this, "maximum", _maximum, _maximum = value);
				if (_minimum > _maximum) {
					DataChange.queue(this, "minimum", _minimum, _minimum = _maximum);
				}
				DataChange.queue(this, "size", _size, _size = _maximum - _minimum);
				this.value = _value;
			}
		}
		private var _maximum:Number = 100;
		
		[Bindable(event="sizeChange", style="noEvent")]
		public function get size():Number { return _size; }
		public function set size(value:Number):void
		{
			if (_size != value) {
				maximum = _minimum + (value <= 0 ? 0 : value);
			}
		}
		private var _size:Number = 100;
		
		[Bindable(event="valueChange", style="noEvent")]
		public function get value():Number { return _value; }
		public function set value(value:Number):void
		{
			value = value <= _minimum ? _minimum : (value > _maximum ? _maximum : value);
			var p:Number = 1 / _precision;
			value = Math.round(value * p) / p;
			DataChange.queue(this, "value", _value, _value = value);
			value = !_size ? 0 : (_value - _minimum) / _size;
			DataChange.queue(this, "percent", _percent, _percent = value);
			dispatchEvent(new Event(Event.CHANGE));
			DataChange.change();
		}
		private var _value:Number = 0;
		
		[Bindable(event="percentChange", style="noEvent")]
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void
		{
			if (_percent != value) {
				this.value = _minimum + value * _size;
			}
		}
		private var _percent:Number = 0;
		
		[Bindable(event="precisionChange", style="noEvent")]
		public function get precision():Number { return _precision; }
		public function set precision(value:Number):void
		{
			if (_precision != value) {
				DataChange.queue(this, "precision", _precision, _precision = value);
				this.value = _value;
			}
		}
		private var _precision:Number = 1;
		
	}
}
