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
	
	public class MovieClipSkin extends Skin
	{
		protected var skinParts:Object;
		protected var statefulParts:Object;
		
		public function MovieClipSkin()
		{
		}
		
		override public function set target(value:Sprite):void
		{
			skinParts = statefulParts = null;
			super.target = value;
			if (value) {
				skinParts = {};
				statefulParts = [];
				inspectSkin(value);
			}
		}
		
		override public function getSkinPart(part:String):InteractiveObject
		{
			if (target && part in skinParts) {
				return  skinParts[part];
			}
			return null;
		}
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			for each (var states:Object in statefulParts) {
				var skinPart:MovieClip = states.skinPart;
				if (states[value]) {
					skinPart.gotoAndStop(states[value]);
				}
			}
		}
		
		private function inspectSkin(skinPart:Sprite):void
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
					skinParts[child.name.replace("$", "")] = child;
					// inspect child if not its own component/skin
					if (child is Sprite && !(child is ISkinnable)) {
						inspectSkin(child as Sprite);
					}
				}
			}
		}
	}
}
