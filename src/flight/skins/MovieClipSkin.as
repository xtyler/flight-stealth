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
	
	import flight.containers.Group;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	
	public class MovieClipSkin implements ISkin
	{
		protected var dataBind:DataBind = new DataBind();
		private var _currentState:String = "default";
		private var _target:Sprite;
		private var _movieclip:Sprite;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function MovieClipSkin(movieclip:Sprite)
		{
			this.movieclip = movieclip;
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
			if (_movieclip is MovieClip) {
				gotoState(_movieclip as MovieClip, _currentState);
			} else if (_movieclip is Sprite) {
				var length:int = _movieclip.numChildren;
				for (var i:int = 0; i < length; i++) {
					var child:DisplayObject = _movieclip.getChildAt(i);
					if (child is MovieClip) {
						gotoState(child as MovieClip, _currentState);
					}
				}
			}
		}
		
		[Bindable(event="targetChange")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target) {
				if (_movieclip) {
					_target.removeChild(_movieclip);
				}
				_target.removeEventListener(LayoutPhase.LAYOUT, onSizeChange);
			}
			DataChange.change(this, "target", _target, _target = value);
			if (_target) {
				if (_movieclip) {
					_target.addChild(_movieclip);
				}
				_target.addEventListener(LayoutPhase.LAYOUT, onSizeChange);
				onSizeChange(null);
			}
		}
		
		[Bindable(event="movieclipChange")]
		public function get movieclip():Sprite { return _movieclip; }
		public function set movieclip(value:Sprite):void
		{
			if (_movieclip && _target) {
				_target.removeChild(_movieclip);
			}
			DataChange.change(this, "movieclip", _movieclip, _movieclip = value);
			if (_movieclip && _target) {
				_target.addChild(_movieclip);
				onSizeChange(null);
			}
		}
		
		[Bindable(event="widthChange")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			DataChange.change(this, "width", _width, _width = value);
			RenderPhase.invalidate(_target, LayoutPhase.LAYOUT);
		}
		
		[Bindable(event="heightChange")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			DataChange.change(this, "height", _height, _height = value);
			RenderPhase.invalidate(_target, LayoutPhase.LAYOUT);
		}
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return (part in _movieclip) ? _movieclip[part] : (part in this ? this[part] : null);
		}
		
		private function onSizeChange(event:Event):void
		{
			if (_movieclip && _target) {
				_movieclip.width = _target.width;
				_movieclip.height = _target.height;
			}
		}
		
		// we'll update this for animated/play animations later
		private function gotoState(clip:MovieClip, state:String):void
		{
			var frames:Array = clip.currentLabels;
			for each(var label:FrameLabel in frames) {
				if (label.name == state) {
					clip.gotoAndStop(label.frame);
				}
			}
			
			var length:int = clip.numChildren; // recurse (for now)
			for (var i:int = 0; i < length; i++) {
				var child:DisplayObject = clip.getChildAt(i);
				if (child is MovieClip) {
					gotoState(child as MovieClip, state);
				}
			}
		}
	}
}
