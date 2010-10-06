package flight.display
{
	import flash.display.Shape;

	import flight.data.DataChange;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayoutBounds;
	import flight.styles.IStyle;
	import flight.styles.IStyleClient;
	import flight.styles.Style;

	import mx.core.IMXMLObject;

	/**
	 * Advanced Shape implementation providing styling, transformation and
	 * simple layout properties, also making the display bindable.
	 */
	public class ShapeDisplay extends Shape implements IStyleClient, ITransform, ILayoutBounds, IMXMLObject
	{
		// ====== IStyleClient implementation ====== //
		// TODO: resolve styling solutoin (data split between styleclient and style object
		
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
		[Inspectable(category="General")]
		[Bindable(event="elementTypeChange", style="weak")]
		public function get elementType():String { return _elementType;}
		public function set elementType(value:String):void
		{
			DataChange.change(this, "elementType", _elementType, _elementType = value);
		}
		private var _elementType:String;
		
		/**
		 * @inheritDoc
		 */
		public function get style():IStyle { return _style || (_style = new Style()); }
		private var _style:Style;
		
		/**
		 * @inheritDoc
		 */
		public function getStyle(property:String):*
		{
			return style.getStyle(property);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setStyle(property:String, value:*):void
		{
			style.setStyle(property, value);
		}
		
		
		// ====== ITransform implementation ====== //
		
//		/**
//		 * @inheritDoc
//		 */
//		[Bindable(event="parentTransformChange", style="weak")]
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
			// TODO: udpate registration point if transformX/Y != 0
			DataChange.change(this, "x", super.x, super.x = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="yChange", style="weak")]
		override public function set y(value:Number):void
		{
			// TODO: udpate registration point if transformX/Y != 0
			DataChange.change(this, "y", super.y, super.y = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="weak")]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void
		{
			explicit.width = value;
			value = !isNaN(_layoutWidth) ? _layoutWidth : preferredWidth;
			value = constrainWidth(value);
			DataChange.change(this, "width", _width, _width = value);
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
			explicit.height = value;
			value = !isNaN(_layoutHeight) ? _layoutHeight : preferredHeight;
			value = constrainHeight(value);
			DataChange.change(this, "height", _height, _height = value);
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
			DataChange.change(this, "nativeWidth", super.width, super.width = value);
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
			DataChange.change(this, "nativeHeight", super.height, super.height = value);
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
			// TODO: udpate position based on registration point if transformX/Y != 0
			DataChange.change(this, "scaleX", super.scaleX, super.scaleX = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="scaleYChange", style="weak")]
		override public function set scaleY(value:Number):void
		{
			// TODO: udpate position based on registration point if transformX/Y != 0
			DataChange.change(this, "scaleY", super.scaleY, super.scaleY = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="rotationChange", style="weak")]
		override public function set rotation(value:Number):void
		{
			// TODO: udpate position based on registration point if transformX/Y != 0
			DataChange.change(this, "rotation", super.rotation, super.rotation = value);
		}

//		/**
//		 * @inheritDoc
//		 */
//		[Inspectable(category="General")]
//		[Bindable(event="matrixChange", style="weak")]
//		public function get matrix():Matrix
//		{
//			return _matrix || transform.matrix;
//		}
//		public function set matrix(value:Matrix):void
//		{
//			if (_parentTransform == parent) {
//				transform.matrix = value;
//			} else { // TODO: implement
//				_matrix = value;
//			}
//		}
//		private var _matrix:Matrix;
		
		// ====== ILayoutBounds implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="Change", style="weak")]
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			DataChange.change(this, "freeform", _freeform, _freeform = value);
		}
		private var _freeform:Boolean = false;
		
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			return !isNaN(explicit.width) ? explicit.width : measured.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			return !isNaN(explicit.height) ? explicit.height : measured.height;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="minWidthChange", style="weak")]
		public function get minWidth():Number { return _minWidth;}
		public function set minWidth(value:Number):void
		{
			explicit.minWidth = value;
			if (explicit.maxWidth < value) {
				explicit.maxWidth = value;
			}
			value = measured.constrainWidth(value);
			DataChange.change(this, "minWidth", _minWidth, _minWidth = value);
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
			explicit.minHeight = value;
			if (explicit.maxHeight < value) {
				explicit.maxHeight = value;
			}
			value = measured.constrainHeight(value);
			DataChange.change(this, "minHeight", _minHeight, _minHeight = value);
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
			if (explicit.minWidth > value) {
				explicit.minWidth = value;
			}
			explicit.maxWidth = value;
			value = measured.constrainWidth(value);
			DataChange.change(this, "maxWidth", _maxWidth, _maxWidth = value);
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
			if (explicit.minHeight > value) {
				explicit.minHeight = value;
			}
			explicit.maxHeight = value;
			value = measured.constrainHeight(value);
			DataChange.change(this, "maxHeight", _maxHeight, _maxHeight = value);
		}
		private var _maxHeight:Number = 0xFFFFFF;
		
		/**
		 * @inheritDoc
		 */
		public function get explicit():IBounds { return _explicit || (_explicit = new Bounds(NaN, NaN)); }
		protected var _explicit:Bounds;
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured || (_measured = new Bounds(0, 0)); }
		protected var _measured:Bounds;
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutPosition(x:Number, y:Number):void
		{
			DataChange.queue(this, "x", super.x, super.x = x);
			DataChange.change(this, "y", super.y, super.y = y);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutSize(width:Number, height:Number):void
		{
			_layoutWidth = width;
			width = constrainWidth(!isNaN(width) ? width : preferredWidth);
			DataChange.queue(this, "width", _width, _width = width);
			
			_layoutHeight = height;
			height = constrainHeight(!isNaN(height) ? height : preferredHeight);
			DataChange.change(this, "height", _height, _height = height);
		}
		private var _layoutWidth:Number;
		private var _layoutHeight:Number;
		
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
		
		public function invalidate(phase:String):void
		{
			RenderPhase.invalidate(this, phase);
		}
	}
}
