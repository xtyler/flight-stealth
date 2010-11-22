/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.InitializePhase;
	import flight.display.LayoutPhase;
	import flight.display.MovieClipDisplay;
	import flight.display.RenderPhase;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.SkinEvent;
	import flight.layouts.Align;
	import flight.layouts.Box;
	import flight.layouts.DockLayout;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.layouts.ILayoutBounds;
	import flight.layouts.IMeasureable;
	import flight.list.ArrayList;
	import flight.list.IList;
	import flight.styles.IStateful;
	import flight.styles.IStyleable;
	import flight.utils.Type;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	[DefaultProperty("content")]
	dynamic public class MovieClipSkin extends MovieClipDisplay implements ISkin, IContainer, IStateful
	{
		protected var dataBind:DataBind = new DataBind();
		protected var skinParts:Object;
		protected var statefulParts:Object;
		
		private var tweens:Dictionary;
		
		public function MovieClipSkin()
		{
			nativeSizing = false;
			dataBind.bind(this, "currentState", this, "target.currentState");
			
			for (var i:int = 0; i < numChildren; i ++) {
				_content.addItem(getChildAt(i));
			}
			
			addEventListener(InitializePhase.INITIALIZE, onInit);
			addEventListener(Event.ADDED, onChildAdded, true);
			addEventListener(Event.REMOVED, onChildRemoved, true);
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
		}
		
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target != value) {
				if (_target) {
					detachSkin();
				}
				skinParts = statefulParts = null;
				DataChange.queue(this, "target", _target, _target = value);
				if ("hostComponent" in this) {
					this["hostComponent"] = _target;
				}
				if (_target) {
					attachSkin();
				}
				DataChange.change();
			}
		}
		private var _target:Sprite;
		
		public function getSkinPart(partName:String):InteractiveObject
		{
			return partName in skinParts ? skinParts[partName] : null;
		}
		
		protected function attachSkin():void
		{
			_target.addChild(this);
			skinParts = {};
			statefulParts = [];
			inspectSkin(target);
			if (!layout) {
				layout = new DockLayout();
			}
			_target.addEventListener(LayoutPhase.LAYOUT, onLayout);
		}
		
		protected function detachSkin():void
		{
			_target.removeChild(this);
		}
		
		protected function inspectSkin(skinPart:Sprite):void
		{
			if (skinPart is MovieClip) {
				
				// get frame labels
				var movieclip:MovieClip = skinPart as MovieClip;
				if (movieclip.currentLabels.length) {
					var states:Object = {skinPart:movieclip};
					for each (var label:FrameLabel in movieclip.currentLabels) {
						states[label.name] = label.frame;
					}
					statefulParts.push(states);
				}
			}
			for (var i:int = 0; i < skinPart.numChildren; i++) {
				var child:DisplayObject = skinPart.getChildAt(i);
				if (child is InteractiveObject) {
					var id:String = child.name.replace("$", "");
					skinParts[id] = child;
					if (id in this) {
						
						if (child is ISkin) {
							var type:Class = Type.getPropertyType(this, id);
							if (!(child is type)) {
								var component:InteractiveObject = new type();
								skinPart.addChildAt(component, i);
								component.transform.matrix = child.transform.matrix;
								ISkinnable(component).skin = ISkin(child);
								skinParts[id] = child = component;
							}
						}
						
						this[id] = child;
						dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, id, null, InteractiveObject(child)));
					}
					// inspect child if not its own component/skin
					if (child is Sprite && !(child is ISkinnable)) {
						inspectSkin(child as Sprite);
					}
				}
			}	
		}
		
		protected function setTimelineMargins(skinPart:InteractiveObject):void
		{
			if (!target || !(skinPart is IStyleable)) {
				return;
			}
			
			var style:Object = IStyleable(skinPart).style;
			var rect:Rectangle = target.getRect(target);
			var childRect:Rectangle = skinPart is ILayoutBounds ?
				ILayoutBounds(skinPart).getLayoutRect() :
				skinPart.getRect(skinPart.parent);
			
			// support for simple docking
			if (style.dock != null && skinPart is ILayoutBounds) {
				var margin:Box = ILayoutBounds(skinPart).margin;
				if (style.dock != Align.LEFT) {
					margin.right = rect.right - childRect.right;
				}
				if (style.dock != Align.TOP) {
					margin.bottom = rect.bottom - childRect.bottom;
				}
				if (style.dock != Align.RIGHT) {
					margin.left = childRect.left;
				}
				if (style.dock != Align.BOTTOM) {
					margin.top = childRect.top;
				}
			} else {
				if (!isNaN(style.left)) {
					style.left = childRect.left;
				}
				if (!isNaN(style.top)) {
					style.top = childRect.top;
				}
				if (!isNaN(style.right)) {
					style.right = rect.right - childRect.right;
				}
				if (!isNaN(style.bottom)) {
					style.bottom = rect.bottom - childRect.bottom;
				}
				if (!isNaN(style.horizontal)) {
					style.offsetX = childRect.x - style.horizontal * (rect.width - childRect.width);
				}
				if (!isNaN(style.vertical)) {
					style.offsetY = childRect.y - style.vertical * (rect.height - childRect.height);
				}
			}
		}
		
		private function onTweenFrame(event:Event):void
		{
			var tweening:Boolean = false;
			for (var skinPart:* in tweens) {
				var targetFrame:int = tweens[skinPart];
				if (targetFrame == skinPart.currentFrame) {
					delete tweens[skinPart];
				} else {
					tweening = true;
					if (targetFrame < skinPart.currentFrame) {
						skinPart.gotoAndStop(skinPart.currentFrame - 1);
					} else {
						skinPart.gotoAndStop(skinPart.currentFrame + 1);
					}
				}
			}
			if (!tweening) {
				target.removeEventListener(Event.ENTER_FRAME, onTweenFrame);
			}
		}
		
		private function onLayout(event:Event):void
		{
			setLayoutSize(parent.width, parent.height);
		}
		
		private function onInit(event:Event):void
		{
			if (parent is ISkinnable) {
				ISkinnable(parent).skin = this;
			}
		}
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			if (_currentState != value) {
				DataChange.change(this, "currentState", _currentState, _currentState = value);
				gotoState(value);
			}
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
		protected function gotoState(state:String):void
		{
			removeEventListener(Event.ENTER_FRAME, onTweenFrame);
			for each (var states:Object in statefulParts) {
				var skinPart:MovieClip = states.skinPart;
				if (!states[state]) {
					continue;
				}
				if (states[state + "Start"]) {
					target.addEventListener(Event.ENTER_FRAME, onTweenFrame);
					if (!tweens) tweens = new Dictionary(true);
					tweens[skinPart] = states[state];
					skinPart.gotoAndStop(states[state + "Start"]);
				} else {
					skinPart.gotoAndStop(states[state]);
				}
			}
		}
		
		// ====== IContainer implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			_content.removeItems();
			if (value is IList) {
				_content.addItems( IList(value).getItems() );
			} else if (value is Array) {
				_content.addItems(value);
			} else {
				_content.addItem(value);
			}
			DataChange.change(this, "content", _content, _content, true);
		}
		private var _content:IList = new ArrayList();
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange", style="noEvent")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				if (_layout) {
					_layout.target = null;
				}
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_layout) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="widthChange", style="noEvent")]
		public function get contentWidth():Number
		{
			return width;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="heightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			return height;
		}
		
		override protected function measure():void
		{
			if (measured.width < defaultRect.right) {
				measured.width = defaultRect.right;
			}
			if (measured.height < defaultRect.bottom) {
				measured.height = defaultRect.bottom;
			}
			if (_target is IMeasureable) {
				var targetMeasured:IBounds = IMeasureable(_target).measured;
				targetMeasured.minWidth = measured.minWidth;
				targetMeasured.minHeight = measured.minHeight;
				targetMeasured.maxWidth = measured.maxWidth;
				targetMeasured.maxHeight = measured.maxHeight;
				targetMeasured.width = measured.width;
				targetMeasured.height = measured.height;
			}
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.addItemAt(child, getChildIndex(child));
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != this) {
				return;
			}
			
			contentChanging = true;
			content.removeItem(child);
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (contentChanging) {
				return;
			}
			
			contentChanging = true;
			var child:DisplayObject;
			var location:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD:
					for each (child in event.items) {
						addChildAt(child, location++);
					}
					break;
				case ListEventKind.REMOVE:
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case ListEventKind.MOVE:
					addChildAt(event.items[0], location);
					if (event.items.length == 2) {
						addChildAt(event.items[1], event.location2);
					}
					break;
				case ListEventKind.REPLACE:
					removeChild(event.items[1]);
					addChildAt(event.items[0], location);
					break;
				default:	// ListEventKind.RESET
					for each (child in event.items) {
						removeChild(child);
					}
					for each (child in _content) {
						addChildAt(child, location++);
					}
			}
			contentChanging = false;
			
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
		private var contentChanging:Boolean;
		
	}
}
