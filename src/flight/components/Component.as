/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flight.behaviors.IBehavior;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.data.IDataRenderer;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.display.SpriteDisplay;
	import flight.skins.ISkin;
	import flight.styles.IStateful;
	import flight.templating.addItem;
	
	public class Component extends SpriteDisplay implements IStateful, IDataRenderer
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Component()
		{
			_behaviors = {};
		}
		
		[Bindable(event="dataChange")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			if (_data == value) {
				return;
			}
			_data = value;
			dispatchEvent(new Event("dataChange"));
		}
		private var _data:Object;
		
		[ArrayElementType("flight.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange")]
		[Inspectable(name="Behaviors", type=Array)]
		/**
		 * A dynamic object or hash map of behavior objects. <code>behaviors</code>
		 * is effectively read-only, but setting either an IBehavior or array of
		 * IBehavior to this property will add those behaviors to the <code>behaviors</code>
		 * object/map.
		 * 
		 * To set behaviors in MXML:
		 * &lt;Component...&gt;
		 *   &lt;behaviors&gt;
		 *     &lt;SelectBehavior/&gt;
		 *     &lt;ButtonBehavior/&gt;
		 *   &lt;/behaviors&gt;
		 * &lt;/Component&gt;
		 */
		public function get behaviors():Object { return _behaviors; }
		public function set behaviors(value:*):void
		{
			/*
			var change:PropertyChange = PropertyChange.begin();
			value = change.add(this, "behaviors", _behaviors, value);
			*/
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
			//change.commit();
			dispatchEvent(new Event("behaviorsChange"));
		}
		private var _behaviors:Object;
		
		[Bindable(event="skinChange")]
		[Inspectable(name="Skin", type=Class)]
		public function get skin():Object { return _skin; }
		public function set skin(value:Object):void
		{
			if (_skin == value) {
				return;
			}
			var oldSkin:Object = _skin;
			_skin = value;
			if (_skin is ISkin) {
				(_skin as ISkin).target = this;
			} else if (_skin is DisplayObject) {
				addItem(this, _skin);
			}
			dispatchEvent(new Event("skinChange"));
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
		}
		private var _skin:Object;
		
		[Bindable(event="enabledChange")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			DataChange.change(this, "enabled", _enabled, _enabled = value);
		}
		private var _enabled:Boolean = true;
		
		// IStateful implementation
		/*
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			if (_states == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "states", _states, _states = value);
		}
		*/
		
		[Bindable(event="currentStateChange", style="weak")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
			if (_skin && "currentState" in _skin) {
				_skin.currentState = _currentState;
			}
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="weak")]
		public function get states():Array { return _states }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
	}
}
