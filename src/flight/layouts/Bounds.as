/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	/**
	 * The Bounds class holds values related to a object's dimensions.
	 */
	public class Bounds implements IBounds
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
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			_width = constrainWidth(value);
		}
		private var _width:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			_height = constrainHeight(value);
		}
		private var _height:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			_minWidth = value;
			if (_maxWidth < value) {
				_maxWidth = value;
			}
		}
		private var _minWidth:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			_minHeight = value;
			if (_maxHeight < value) {
				_maxHeight = value;
			}
		}
		private var _minHeight:Number = 0;
			
		/**
		 * @inheritDoc
		 */	
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void
		{
			if (_minWidth > value) {
				_minWidth = value;
			}
			_maxWidth = value;
		}
		private var _maxWidth:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void
		{
			if (_minHeight > value) {
				_minHeight = value;
			}
			_maxHeight = value;
		}
		private var _maxHeight:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		public function constrainWidth(width:Number):Number
		{
			return (width <= _minWidth) ? _minWidth :
				   (width >= _maxWidth) ? _maxWidth : width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function constrainHeight(height:Number):Number
		{
			return (height <= _minHeight) ? _minHeight :
				   (height >= _maxHeight) ? _maxHeight : height;
		}
	}
}
