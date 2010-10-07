/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import flight.metadata.getClassName;
	
	public class RenderPhase
	{
		// the 'render' event is dispatched by Flash through which order of
		// resolution is not guaranteed
		public static const VALIDATE:String = "validate";
		RenderPhase.registerPhase(VALIDATE);
		
		private static var rendering:Boolean = false;
		private static var phaseList:Array = [];
		private static var phaseIndex:Object = {};
		private static var displayNodeDepths:Dictionary = new Dictionary(true);
		private static var invalidStages:Dictionary = new Dictionary(true);
		
		public static function registerPhase(phase:String, priority:int = 0, ascending:Boolean = true):void
		{
			var renderPhase:RenderPhase = phaseIndex[phase];
			if (!renderPhase) {
				renderPhase = new RenderPhase(phase);
				phaseIndex[phase] = renderPhase;
				phaseList.push(renderPhase);
			}
			
			renderPhase.priority = priority;
			renderPhase.ascending = ascending;
			phaseList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
		}
		
		public static function invalidate(display:DisplayObject, phase:String):void
		{
			if (!display) {
				return;
			} else if (!phaseIndex[phase]) {
				throw new Error(getClassName(display) + " cannot be invalidated in unknown phase '" + phase + "'.");
			}
			
			var renderPhase:RenderPhase = phaseIndex[phase];
			if (renderPhase.hasDisplay(display)) {
				return;
			}
			
			display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 50, true);
			display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 50, true);
			
			if (display.stage == null) {
				renderPhase.addDisplay(display, -1);
			} else {
				
				var nodeDepth:int = displayNodeDepths[display] != null ?
					displayNodeDepths[display] :
					displayNodeDepths[display] = getDepth(display);
				
				renderPhase.addDisplay(display, nodeDepth);
				
				if (!rendering) {
					invalidateStage(display.stage);
				} else if ((renderPhase.ascending && nodeDepth >= renderPhase.renderingDepth) ||
						  (!renderPhase.ascending && nodeDepth <= renderPhase.renderingDepth)) {
					setTimeout(invalidateStage, 0, display.stage);
				}
			}
		}
		
		public static function validateNow(display:DisplayObject, phase:String = null):void
		{
			if (phase && !phaseIndex[phase]) {
				throw new Error(getClassName(display) + " cannot be invalidated in unknown phase '" + phase + "'.");
			} else if (!display) {
				return;
			}
			
			var renderPhase:RenderPhase = phaseIndex[phase];
			if (renderPhase) {
				renderPhase.removeDisplay(display);
				display.dispatchEvent(new Event(renderPhase.type));
			} else {
				for each (renderPhase in phaseList) {
					if (renderPhase.hasDisplay(display)) {
						renderPhase.removeDisplay(display);
						display.dispatchEvent(new Event(renderPhase.type));
					}
				}
			}
		}
		
		public static function render():void
		{
			rendering = true;
			validateStages();
			for each (var renderPhase:RenderPhase in phaseList) {
				renderPhase.render();
			}
			rendering = false;
		}
		
		private static function getDepth(display:DisplayObject):int
		{
			var nodeDepth:int = 0;
			while ((display = display.parent) != null) {
				nodeDepth++;
				// if a parent already has nodeDepth defined, take the shortcut
				if (displayNodeDepths[display] != null) {
					nodeDepth += displayNodeDepths[display];
					break;
				}
			}
			return nodeDepth;
		}
		
		private static function invalidateStage(stage:Stage):void
		{
			if (!invalidStages[stage]) {
				invalidStages[stage] = true;
				stage.invalidate();
				stage.addEventListener(Event.RENDER, onRender, false, 50, true);
				stage.addEventListener(Event.RESIZE, onRender, false, 50, true);
			}
		}
		
		private static function validateStages():void
		{
			for (var i:* in invalidStages) {
				var stage:Stage = i;
				stage.removeEventListener(Event.RENDER, onRender);
				stage.removeEventListener(Event.RESIZE, onRender);
			}
		}
		
		private static function onRender(event:Event):void
		{
			render();
		}
		
		private static function onAddedToStage(event:Event):void
		{
			var display:DisplayObject = DisplayObject(event.target);
			displayNodeDepths[display] = getDepth(display);
			
			for each (var renderPhase:RenderPhase in phaseList) {
				if (renderPhase.hasDisplay(display)) {
					renderPhase.removeDisplay(display);
					invalidate(display, renderPhase.type);
				}
			}
		}
		
		private static function onRemovedFromStage(event:Event):void
		{
			var display:DisplayObject = DisplayObject(event.target);
			delete displayNodeDepths[display];
			
			for each (var renderPhase:RenderPhase in phaseList) {
				if (renderPhase.hasDisplay(display)) {
					renderPhase.removeDisplay(display);
					renderPhase.addDisplay(display, -1);
				}
			}
		}
		
		
		public var ascending:Boolean = false;
		public var priority:int = 0;
		
		private var _type:String;
		private var depths:Array = [];
		private var pos:int = -1;
		private var current:Dictionary = new Dictionary(true);
		private var invalidated:Dictionary = new Dictionary(true);
		
		public function RenderPhase(type:String)
		{
			_type = type;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get renderingDepth():int
		{
			return pos;
		}
		
		public function render():void
		{
			if (depths.length == 0) {
				return;
			}
			
			var beg:int, end:int, vel:int;
			if (ascending) {
				beg = depths.length;
				end = 0;
				vel = -1;
			} else {
				beg = -1;
				end = depths.length;
				vel = 1;
			}
			var pre:Dictionary;
			
			for (pos = beg; pos != end; pos += vel) {
				if (depths[pos] == null) {
					continue;
				}
				
				// replace current dictionary with a clean one before new cycle
				pre = current;
				current = depths[pos];
				depths[pos] = pre;
				
				for (var i:* in current) {
					var display:DisplayObject = i;
					delete current[i];
					delete invalidated[display];
					display.dispatchEvent(new Event(type));
				}
			}
			pos = -1;
		}
		
		public function addDisplay(display:DisplayObject, nodeDepth:int):void
		{
			if (depths[nodeDepth] == null) {
				depths[nodeDepth] = new Dictionary(true);
			}
			depths[nodeDepth][display] = true;
			invalidated[display] = nodeDepth;
		}
		
		public function removeDisplay(display:DisplayObject):void
		{
			delete depths[ invalidated[display] ][display];
			delete invalidated[display];
		}
		
		public function hasDisplay(display:IEventDispatcher):Boolean
		{
			return invalidated[display] != null;
		}
		
	}
}
