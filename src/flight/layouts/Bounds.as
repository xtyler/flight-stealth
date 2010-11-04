/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.events.EventDispatcher;
	
	import flight.data.DataChange;
	
	/**
	 * The Bounds class holds values related to a object's dimensions.
	 */
	public class Bounds extends EventDispatcher implements IBounds
	{
		/**
		 * Constructor.
		 * 
		 * @param		width		The initial width of this bounds instance.
		 * @param		height		The initial height of this bounds instance.
		 */
		public function Bounds(width:Number = NaN, height:Number = NaN)
		{
			_width = width;
			_height = height;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="noEvent")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			value = constrainWidth(value);
			DataChange.change(this, "width", _width, _width = value);
		}
		private var _width:Number;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="heightChange", style="noEvent")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			value = constrainHeight(value);
			DataChange.change(this, "height", _height, _height = value);
		}
		private var _height:Number;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="minWidthChange", style="noEvent")]
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			if (_maxWidth < value) {
				DataChange.queue(this, "maxWidth", _maxWidth, _maxWidth = value);
			}
			DataChange.change(this, "minWidth", _minWidth, _minWidth = value);
		}
		private var _minWidth:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="minHeightChange", style="noEvent")]
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			if (_maxHeight < value) {
				DataChange.queue(this, "maxHeight", _maxHeight, _maxHeight = value);
			}
			DataChange.change(this, "minHeight", _minHeight, _minHeight = value);
		}
		private var _minHeight:Number = 0;
			
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="maxWidthChange", style="noEvent")]
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void
		{
			if (_minWidth > value) {
				DataChange.queue(this, "minWidth", _minWidth, _minWidth = value);
			}
			DataChange.change(this, "maxWidth", _maxWidth, _maxWidth = value);
		}
		private var _maxWidth:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="maxHeightChange", style="noEvent")]
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void
		{
			if (_minHeight > value) {
				DataChange.queue(this, "minHeight", _minHeight, _minHeight = value);
			}
			DataChange.change(this, "maxHeight", _maxHeight, _maxHeight = value);
		}
		private var _maxHeight:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		public function constrainWidth(width:Number):Number
		{
			return (width >= _maxWidth) ? _maxWidth :
				   (width <= _minWidth) ? _minWidth : width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function constrainHeight(height:Number):Number
		{
			return (height >= _maxHeight) ? _maxHeight :
				   (height <= _minHeight) ? _minHeight : height;
		}
	}
}
