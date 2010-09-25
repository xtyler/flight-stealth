package flight.skins
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.collections.SimpleCollection;
	import flight.components.IStateful;
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.RenderPhase;
	import flight.layouts.ILayout;
	import flight.measurement.IMeasurable;
	import flight.measurement.IMeasurements;
	import flight.measurement.Measurements;
	import flight.templating.addItemsAt;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * Skin is a convenient base class for many skins, a swappable graphical
	 * definition. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 * @alpha
	 */
	[DefaultProperty("content")]
	public class Skin extends EventDispatcher implements ISkin, IContainer, IStateful, IMeasurable
	{
		
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		RenderPhase.registerPhase(MEASURE, 0, true);
		RenderPhase.registerPhase(LAYOUT, 0, true);
		
		protected var dataBind:DataBind = new DataBind();
		
		private var renderers:Array = [];
		private var _layout:ILayout;
		private var _states:Array;
		private var _currentState:String; 
		//private var _transitions:Array;
		private var _template:Object; // = new StealthDataTemplate();
		
		private var unscaledWidth:Number = 160;
		private var unscaledHeight:Number = 22;
		
		private var _explicit:IMeasurements;
		private var _measured:IMeasurements;
		
		//
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="widthChange")]
		public function get width():Number { return unscaledWidth; }
		public function set width(value:Number):void {
			if (unscaledWidth == value) {
				return;
			}
			_explicit.width = value;
			RenderPhase.invalidate(target, LAYOUT);
			DataChange.change(this, "width", unscaledWidth, unscaledWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="heightChange")]
		public function get height():Number { return unscaledHeight; }
		public function set height(value:Number):void {
			if (unscaledHeight == value) {
				return;
			}
			_explicit.height = value;
			RenderPhase.invalidate(target, LAYOUT);
			DataChange.change(this, "height", unscaledHeight, unscaledHeight = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="explicitChange")]
		public function get explicit():IMeasurements { return _explicit; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="measuredChange")]
		public function get measured():IMeasurements { return _measured; }
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			RenderPhase.invalidate(target, LAYOUT);
			DataChange.queue(this, "width", unscaledWidth, unscaledWidth = width);
			DataChange.change(this, "height", unscaledHeight, unscaledHeight = height);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if (_layout == value) {
				return;
			}
			if (_layout) { _layout.target = null; }
			DataChange.queue(this, "layout", _layout, _layout = value);
			_layout.target = target;
			if (target) {
				RenderPhase.invalidate(target, MEASURE);
				RenderPhase.invalidate(target, LAYOUT);
			}
			DataChange.change();
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			DataChange.change(this, "template", _template, _template = value);
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			DataChange.change(this, "states", _states, _states = value);
		}
		
		private var _target:Sprite;
		private var _content:IList;
		
		public function Skin()
		{
			super();
			_content = new SimpleCollection();
			_explicit = new Measurements(this);
			_measured = new Measurements(this, 160, 22);
			_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			addEventListener(LAYOUT, onLayout, false, 0, true);
		}
		
		
		[Bindable(event="targetChange")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target == value) {
				return;
			}
			
			DataChange.queue(this, "target", _target, _target = value);
			if (layout) {
				layout.target = _target;
			}
			
			if (this.hasOwnProperty('hostComponent')) {
				this['hostComponent'] = _target;
			}
			
			if (_target != null) {
				target.addEventListener(MEASURE, onMeasure, false, 0, true);
				target.addEventListener(LAYOUT, onLayout, false, 0, true);
				RenderPhase.invalidate(target, MEASURE);
				RenderPhase.invalidate(target, LAYOUT);
			}
			
			var items:Array = [];
			for (var i:int = 0; i < _content.length; i++) {
				items.push(_content.getItemAt(i));
			}
			reset(items);
			DataChange.change();
		}
		
		protected function init():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="contentChange")]
		public function get content():IList
		{
			return _content;
		}
		public function set content(value:*):void
		{
			if (_content == value) {
				return;
			}
			
			var oldContent:IList = _content;
			
			if (_content) {
				_content.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			
			if (value == null) {
				_content = null;
			} else if (value is IList) {
				_content = value as IList;
			} else if (value is Array || value is Vector) {
				_content = new SimpleCollection(value);
			} else {
				_content = new SimpleCollection([value]);
			}
			
			if (_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _content.length; i++) {
					items.push(_content.getItemAt(i));
				}
				reset(items);
			}
			
			
			DataChange.change(this, "content", oldContent, _content);
		}
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return (part in this) ? this[part] : null;
		}
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			if (_target == null) {
				return;
			}
			var child:DisplayObject;
			var loc:int = event.location;
			switch (event.kind) {
				case CollectionEventKind.ADD :
					add(event.items, loc++);
					break;
				case CollectionEventKind.REMOVE :
					for each (child in event.items) {
					_target.removeChild(child);
					}
					break;
				case CollectionEventKind.REPLACE :
					_target.removeChild(event.items[1]);
					_target.addChildAt(event.items[0], loc);
					break;
				case CollectionEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
		}
		
		
		private function add(items:Array, index:int):void {
			var children:Array = flight.templating.addItemsAt(_target, items, index, template);
			renderers.concat(children); // todo: correct ordering
		}
		
		private function reset(items:Array):void {
			if (_target) {
				while (_target.numChildren) {
					_target.removeChildAt(_target.numChildren-1);
				}
				renderers = flight.templating.addItemsAt(_target, items, 0, template); // todo: correct ordering
				RenderPhase.invalidate(_target, MEASURE);
				RenderPhase.invalidate(_target, LAYOUT);
			}
		}
		
		private function onMeasure(event:Event):void {
			var target:IMeasurable= this.target as IMeasurable;
			if (layout && target && (isNaN(target.explicit.width) || isNaN(target.explicit.height))) {
				var items:Array = [];
				var length:int = _content.length;
				for (var i:int = 0; i < length; i++) {
					items.push(_content.getItemAt(i));
				}
				var point:Point = layout.measure(items);
			}
		}
		
		private function onLayout(event:Event):void {
			if (layout) {
				var items:Array = [];
				var length:int = _content.length;
				for (var i:int = 0; i < length; i++) {
					items.push(_content.getItemAt(i));
				}
				
				var rectangle:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
				layout.update(items, rectangle);
			}
		}
		
	}
}
