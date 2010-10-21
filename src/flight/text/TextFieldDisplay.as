/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.text
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import flash.text.TextLineMetrics;

	import flight.data.DataChange;
	import flight.display.IInvalidating;
	import flight.display.ITransform;
	import flight.display.InitializePhase;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.layouts.Bounds;
	import flight.layouts.Box;
	import flight.layouts.IBounds;
	import flight.layouts.ILayoutBounds;
	import flight.styles.IStyleable;
	import flight.styles.Style;
	
	import mx.core.IMXMLObject;
	
	[Style(name="left")]
	[Style(name="top")]
	[Style(name="right")]
	[Style(name="bottom")]
	[Style(name="horizontal")]
	[Style(name="vertical")]
	[Style(name="margin")]
	[Style(name="dock")]
	[Style(name="tile")]
	
	[Event(name="initialize", type="flash.events.Event")]
	[Event(name="style", type="flash.events.Event")]
	[Event(name="move", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	[Event(name="ready", type="flash.events.Event")]
	
	/**
	 * Advanced TextField implementation providing styling, transformation and
	 * simple layout properties, also making the display bindable.
	 */
	public class TextFieldDisplay extends TextField implements IStyleable, ITransform, ILayoutBounds, IInvalidating, IMXMLObject
	{
		public function TextFieldDisplay()
		{
			_explicit = new Bounds(NaN, NaN);
			_measured = new Bounds(0, 0);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(LayoutPhase.MEASURE, onMeasure);
		}
		
		// ====== IStyleable implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="idChange", style="weak")]
		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			DataChange.change(this, "id", _id, _id = value);
		}
		private var _id:String;
		
		/**
		 * @inheritDoc
		 */
		override public function set name(value:String):void
		{
			id = super.name = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="styleNameChange", style="weak")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void
		{
			DataChange.change(this, "styleName", _styleName, _styleName = value);
		}
		private var _styleName:String;
		
		/**
		 * @inheritDoc
		 */
		public function get style():Object { return _style || (_style = new Style(this)); }
		private var _style:Style;
		
		/**
		 * @inheritDoc
		 */
		public function getStyle(property:String):*
		{
			return _style[property];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setStyle(property:String, value:*):void
		{
			_style[property] = value;
		}
		
		
		// ====== ITransform implementation ====== //
		
//		/**
//		 * @inheritDoc
//		 */
//		[Bindable(event="parentTransformChange", style="weak")]	// TODO: implement support from layout for non-children
//		public function get parentTransform():ITransform { return _parentTransform; }
//		public function set parentTransform(value:ITransform):void
//		{
//			DataChange.change(this, "parentTransform", _parentTransform, _parentTransform = value);
//		}
//		private var _parentTransform:ITransform;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="xChange", style="weak")]
		override public function set x(value:Number):void
		{
			if (super.x != value) {
				// TODO: update registration point if transformX/Y != 0
				invalidateLayout();
				RenderPhase.invalidate(this, LayoutPhase.MOVE);
				DataChange.change(this, "x", super.x, super.x = value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="yChange", style="weak")]
		override public function set y(value:Number):void
		{
			if (super.y != value) {
				// TODO: update registration point if transformX/Y != 0
				invalidateLayout();
				RenderPhase.invalidate(this, LayoutPhase.MOVE);
				DataChange.change(this, "y", super.y, super.y = value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="weak")]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void
		{
			_explicit.width = value;
			updateWidth();
		}
		private var _width:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="heightChange", style="weak")]
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void
		{
			_explicit.height = value;
			updateHeight();
		}
		private var _height:Number = 0;
		
		/**
		 * The width of the display in pixels relative to the local
		 * coordinates of the parent. The nativeWidth is calculated based on
		 * the bounds of the content of this display instance. When setting
		 * the nativeWidth property the scaleX property is adjusted
		 * accordingly.
		 */
		[Bindable(event="nativeWidthChange", style="weak")]
		public function get nativeWidth():Number { return super.width; }
		public function set nativeWidth(value:Number):void
		{
			if (super.width != value) {
				invalidateLayout();
				DataChange.change(this, "nativeWidth", super.width, super.width = value);
			}
		}
		
		/**
		 * The height of the display in pixels relative to the local
		 * coordinates of the parent. The nativeHeight is calculated based on
		 * the bounds of the content of this display instance. When setting
		 * the nativeHeight property the scaleY property is adjusted
		 * accordingly.
		 */
		[Bindable(event="nativeHeightChange", style="weak")]
		public function get nativeHeight():Number { return super.height; }
		public function set nativeHeight(value:Number):void
		{
			if (super.height != value) {
				invalidateLayout();
				DataChange.change(this, "nativeHeight", super.height, super.height = value);
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="Change", style="weak")]
		public function get transformX():Number { return _transformX; }
		public function set transformX(value:Number):void
		{
			// TODO: implement
			DataChange.change(this, "transformX", _transformX, _transformX = value);
		}
		private var _transformX:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="transformYChange", style="weak")]
		public function get transformY():Number { return _transformY; }
		public function set transformY(value:Number):void
		{
			// TODO: implement
			DataChange.change(this, "transformY", _transformY, _transformY = value);
		}
		private var _transformY:Number = 0;
		
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="scaleXChange", style="weak")]
		override public function set scaleX(value:Number):void
		{
			if (super.scaleX != value) {
				// TODO: udpate position based on registration point if transformX/Y != 0
				invalidateLayout();
				DataChange.change(this, "scaleX", super.scaleX, super.scaleX = value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="scaleYChange", style="weak")]
		override public function set scaleY(value:Number):void
		{
			if (super.scaleY != value) {
				// TODO: udpate position based on registration point if transformX/Y != 0
				invalidateLayout();
				DataChange.change(this, "scaleY", super.scaleY, super.scaleY = value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="rotationChange", style="weak")]
		override public function set rotation(value:Number):void
		{
			if (super.rotation != value) {
				// TODO: udpate position based on registration point if transformX/Y != 0
				invalidateLayout();
				DataChange.change(this, "rotation", super.rotation, super.rotation = value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="matrixChange", style="weak")]
		public function get matrix():Matrix
		{
			return _matrix || transform.matrix;
		}
		public function set matrix(value:Matrix):void
		{
//			if (_parentTransform == parent) {
				transform.matrix = value;
//			} else { // TODO: implement
//				_matrix = value;
//			}
		}
		private var _matrix:Matrix;
		
		/**
		 * @inheritDoc
		 */
		public function get display():DisplayObject { return this; }
		
		// ====== ILayoutBounds implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="Change", style="weak")]
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			if (_freeform != value) {
				if (!isNaN(_layoutWidth)) {
					_layoutWidth = NaN;
					updateWidth();
				}
				if (!isNaN(_layoutWidth)) {
					_layoutHeight = NaN;
					updateHeight();
				}
				DataChange.change(this, "freeform", _freeform, _freeform = value);
			}
		}
		private var _freeform:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", style="weak")]
		public function get percentWidth():Number { return _percentWidth }
		public function set percentWidth(value:Number):void
		{
			if (_percentWidth != value) {
				invalidateLayout();
				DataChange.change(this, "percentWidth", _percentWidth, _percentWidth = value);
			}
		}
		private var _percentWidth:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", style="weak")]
		public function get percentHeight():Number { return _percentHeight }
		public function set percentHeight(value:Number):void
		{
			if (_percentHeight != value) {
				invalidateLayout();
				DataChange.change(this, "percentHeight", _percentHeight, _percentHeight = value);
			}
		}
		private var _percentHeight:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			return !isNaN(_explicit.width) ? _explicit.width : _measured.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			return !isNaN(_explicit.height) ? _explicit.height : _measured.height;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="marginChange", style="weak")]
		public function get margin():Box { return _margin || (_margin = new Box()); }
		public function set margin(value:*):void
		{
			value = (value is String ? Box.fromString(value) : value) as Box;
			invalidateLayout();
			DataChange.change(this, "margin", _margin, _margin = value);
		}
		private var _margin:Box;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="minWidthChange", style="weak")]
		public function get minWidth():Number { return _minWidth;}
		public function set minWidth(value:Number):void
		{
			_explicit.minWidth = value;
			if (_explicit.maxWidth < value) {
				_explicit.maxWidth = value;
			}
			value = _measured.constrainWidth(value);
			if (_minWidth != value) {
				invalidateLayout(true);
				DataChange.change(this, "minWidth", _minWidth, _minWidth = value);
			}
		}
		private var _minWidth:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="minHeightChange", style="weak")]
		public function get minHeight():Number { return _minHeight;}
		public function set minHeight(value:Number):void
		{
			_explicit.minHeight = value;
			if (_explicit.maxHeight < value) {
				_explicit.maxHeight = value;
			}
			value = _measured.constrainHeight(value);
			if (_minHeight != value) {
				invalidateLayout(true);
				DataChange.change(this, "minHeight", _minHeight, _minHeight = value);
			}
		}
		private var _minHeight:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="maxWidthChange", style="weak")]
		public function get maxWidth():Number { return _maxWidth;}
		public function set maxWidth(value:Number):void
		{
			if (_explicit.minWidth > value) {
				_explicit.minWidth = value;
			}
			_explicit.maxWidth = value;
			value = _measured.constrainWidth(value);
			if (_maxWidth != value) {
				invalidateLayout(true);
				DataChange.change(this, "maxWidth", _maxWidth, _maxWidth = value);
			}
		}
		private var _maxWidth:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="maxHeightChange", style="weak")]
		public function get maxHeight():Number { return _maxHeight;}
		public function set maxHeight(value:Number):void
		{
			if (_explicit.minHeight > value) {
				_explicit.minHeight = value;
			}
			_explicit.maxHeight = value;
			value = _measured.constrainHeight(value);
			if (_maxHeight != value) {
				invalidateLayout(true);
				DataChange.change(this, "maxHeight", _maxHeight, _maxHeight = value);
			}
		}
		private var _maxHeight:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		public function get explicit():IBounds { return _explicit; }
		private var _explicit:Bounds;
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:Bounds;
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutPosition(x:Number, y:Number):void
		{
			if (complexMatrix()) {
				var m:Matrix = matrix, d:Number;
				d = m.a * _width + m.c * _height;
				if (d < 0) x -= d;
				d = m.d * _height + m.b * _width;
				if (d < 0) y -= d;
			}
			
			DataChange.queue(this, "x", super.x, super.x = x);
			DataChange.change(this, "y", super.y, super.y = y);
			RenderPhase.invalidate(this, LayoutPhase.RESIZE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutSize(width:Number, height:Number):void
		{
			if (complexMatrix()) {
				var m:Matrix = matrix;
				if (isNaN(width)) {
					width = Math.abs(m.a * preferredWidth + m.c * preferredHeight);
				}
				if (isNaN(height)) {
					height = Math.abs(m.d * preferredHeight + m.b * preferredWidth);
				}
				
				m.invert();
				_layoutWidth = Math.abs(m.a * width + m.c * height);
				_layoutHeight = Math.abs(m.d * height + m.b * width);
			} else {
				_layoutWidth = isNaN(width) ? NaN : width * scaleX;
				_layoutHeight = isNaN(height) ? NaN : height * scaleY;
			}
			
			updateWidth(true);
			updateHeight(true);
			
		}
		private var _layoutWidth:Number;
		private var _layoutHeight:Number;
		
		/**
		 * @inheritDoc
		 */
		public function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		{
			if (isNaN(width)) width = _width;
			if (isNaN(height)) height = _height;
			
			if (complexMatrix()) {
				var m:Matrix = matrix;
				var x:Number, y:Number, tx:Number, ty:Number;
				var minX:Number, minY:Number, maxX:Number, maxY:Number;
				
				x = this.x;
				y = this.y;
				tx = m.a * x + m.c * y + m.tx;
				ty = m.d * y + m.b * x + m.ty;
				minX = maxX = tx;
				minY = maxY = ty;
				x += width;
				tx = m.a * x + m.c * y + m.tx;
				ty = m.d * y + m.b * x + m.ty;
				if (tx < minX) minX = tx else if (tx > maxX) maxX = tx;
				if (ty < minY) minY = ty else if (ty > maxY) maxY = ty;
				y += height;
				tx = m.a * x + m.c * y + m.tx;
				ty = m.d * y + m.b * x + m.ty;
				if (tx < minX) minX = tx else if (tx > maxX) maxX = tx;
				if (ty < minY) minY = ty else if (ty > maxY) maxY = ty;
				x = this.x;
				tx = m.a * x + m.c * y + m.tx;
				ty = m.d * y + m.b * x + m.ty;
				if (tx < minX) minX = tx else if (tx > maxX) maxX = tx;
				if (ty < minY) minY = ty else if (ty > maxY) maxY = ty;
				
				rect.x = minX;
				rect.y = minY;
				rect.width = maxX - minX;
				rect.height = maxY - minY;
			} else {
				rect.x = this.x;
				rect.y = this.y;
				rect.width = width * scaleX;
				rect.height = height * scaleY;
			}
			return rect;
		}
		private var rect:Rectangle = new Rectangle();
		
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
		
		/**
		 * @inheritDoc
		 */
		public function invalidate(phase:String = null):void
		{
			RenderPhase.invalidate(this, phase || RenderPhase.VALIDATE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(phase:String = null):void
		{
			RenderPhase.validateNow(this, phase);
		}
		
		/**
		 * Specialized method for MXML, called after the display has been
		 * created and all of its properties specified in MXML have been
		 * initialized.
		 * 
		 * @param		document	The MXML document defining this display.
		 * @param		id			The identifier used by <code>document</code>
		 * 							to refer to this display, or its instance
		 * 							name.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.id = super.name = id;
		}
		
		protected function measure():void
		{
			var metrics:TextLineMetrics = getLineMetrics(0);
			_measured.width = metrics.width;
			_measured.height = metrics.height;
		}
		
		protected function invalidateLayout(measureOnly:Boolean = false):void
		{
			if (!_freeform) {
				RenderPhase.invalidate(parent, LayoutPhase.MEASURE);
				if (!measureOnly) {
					RenderPhase.invalidate(parent, LayoutPhase.LAYOUT);
				}
			}
		}
		
		private function updateWidth(layout:Boolean = false):void
		{
			var w:Number = !isNaN(_layoutWidth) ? _layoutWidth : preferredWidth;
			w = constrainWidth(w);
			if (_width != w) {
				if (!layout) {
					invalidateLayout();
				}
				RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
				RenderPhase.invalidate(this, LayoutPhase.RESIZE);
				DataChange.change(this, "width", _width, _width = w);
			}
		}
		
		private function updateHeight(layout:Boolean = false):void
		{
			var h:Number = !isNaN(_layoutHeight) ? _layoutHeight : preferredHeight;
			h = constrainHeight(h);
			if (_height != h) {
				if (!layout) {
					invalidateLayout();
				}
				RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
				RenderPhase.invalidate(this, LayoutPhase.RESIZE);
				DataChange.change(this, "height", _height, _height = h);
			}
		}
		
		private function complexMatrix():Boolean
		{
			var m:Matrix = matrix;
			return (m.a < 0 || m.d < 0 ||
					m.b != 0 || m.c != 0);
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
			updateWidth();
			updateHeight();
			minWidth = minWidth;
			minHeight = minHeight;
			maxWidth = maxWidth;
			maxHeight = maxHeight;
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			RenderPhase.invalidate(this, InitializePhase.INITIALIZE);
			RenderPhase.invalidate(this, InitializePhase.READY);
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
		}
	}
}
