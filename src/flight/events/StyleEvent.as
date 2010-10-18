/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	public class StyleEvent extends Event
	{
		public static const STYLE_CHANGE:String = "styleChange";
		public static const STYLES_CHANGED:String = "stylesChanged";
		
		public function StyleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
								   styleName:String = "", styleValue:Object = null, changedStyles:Object = null)
		{
			super(type, bubbles, cancelable);
			_styleName = styleName;
			_styleValue = styleValue;
			_changedStyles = changedStyles;
		}
		
		public function get styleName():String { return _styleName; }
		private var _styleName:String;
		
		public function get styleValue():Object { return _styleValue; }
		private var _styleValue:Object;
		
		public function get changedStyles():Object { return _changedStyles; }
		private var _changedStyles:Object;
		
		override public function clone():Event
		{
			return new StyleEvent(type, bubbles, cancelable, styleName, styleValue, changedStyles);
		}
	}
}
