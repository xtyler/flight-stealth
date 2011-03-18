/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class RenderPhase
	{
		private static var rendering:Boolean = false;
		private static var phaseList:Array = [];
		private static var phaseIndex:Object = {};
		private static var displayLevels:Dictionary = new Dictionary(true);
		private static var invalidStages:Dictionary = new Dictionary(true);
		
		public static function registerPhase(type:String, eventType:Class = null, priority:int = 0, ascending:Boolean = true):void
		{
			var renderPhase:RenderPhase = phaseIndex[type];
			if (!renderPhase) {
				renderPhase = new RenderPhase(type);
				phaseIndex[type] = renderPhase;
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
			if (renderPhase.hasDispatcher(display)) {
				return;
			}
			
			display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 50, true);
			display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 50, true);
			
			if (display.stage == null) {
				renderPhase.addDispatcher(display, -1);
			} else {
				
				var level:int = displayLevels[display] != null ?
					displayLevels[display] :
					displayLevels[display] = getLevel(display);
				
				renderPhase.addDispatcher(display, level);
				
				if (!rendering) {
					invalidateStage(display.stage);
				} else if ((renderPhase.ascending && level >= renderPhase.currentLevel) ||
						  (!renderPhase.ascending && level <= renderPhase.currentLevel)) {
					setTimeout(invalidateStage, 0, display.stage);
				}
			}
		}
		
		public static function validateNow(display:DisplayObject = null, phase:String = null):void
		{
			if (phase && !phaseIndex[phase]) {
				throw new Error(getClassName(display) + " cannot be invalidated in unknown phase '" + phase + "'.");
			} else if (!display) {
				render();
				return;
			}
			
			var renderPhase:RenderPhase = phaseIndex[phase];
			if (renderPhase) {
				renderPhase.removeDispatcher(display);
				display.dispatchEvent(new Event(renderPhase.type));
			} else {
				for each (renderPhase in phaseList) {
					if (renderPhase.hasDispatcher(display)) {
						renderPhase.removeDispatcher(display);
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
		
		private static function getLevel(display:DisplayObject):int
		{
			var level:int = 0;
			while ((display = display.parent) != null) {
				level++;
				// if a parent already has level defined, take the shortcut
				if (displayLevels[display] != null) {
					level += displayLevels[display];
					break;
				}
			}
			return level;
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
				delete invalidStages[stage];
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
			displayLevels[display] = getLevel(display);
			
			for each (var renderPhase:RenderPhase in phaseList) {
				if (renderPhase.hasDispatcher(display)) {
					renderPhase.removeDispatcher(display);
					invalidate(display, renderPhase.type);
				}
			}
		}
		
		private static function onRemovedFromStage(event:Event):void
		{
			var display:DisplayObject = DisplayObject(event.target);
			delete displayLevels[display];
			
			for each (var renderPhase:RenderPhase in phaseList) {
				if (renderPhase.hasDispatcher(display)) {
					renderPhase.removeDispatcher(display);
					renderPhase.addDispatcher(display, -1);
				}
			}
		}
		
		
		
		public var ascending:Boolean = false;
		public var priority:int = 0;
		
		private var levels:Array = [];
		private var eventType:Class;
		private var currentList:Dictionary = new Dictionary(true);
		private var invalidated:Dictionary = new Dictionary(true);
		
		public function RenderPhase(type:String, eventType:Class = null)
		{
			_type = type;
			this.eventType = eventType || Event;
		}
		
		public function get type():String { return _type; }
		private var _type:String;
		
		public function get currentLevel():int { return _currentLevel; }
		private var _currentLevel:int = -1;
		
		public function render():void
		{
			var cleanList:Dictionary = currentList;
			var end:int, vel:int;
			if (ascending) {
				_currentLevel = levels.length - 1;
				end = -1;
				vel = -1;
			} else {
				_currentLevel = 0;
				end = levels.length;
				vel = 1;
			}
			
			for (_currentLevel; _currentLevel != end; _currentLevel += vel) {
				
				if (levels[_currentLevel]) {
					currentList = levels[_currentLevel];
					levels[_currentLevel] = cleanList;
					
					for (var dispatcher:Object in currentList) {
						delete currentList[dispatcher];
						delete invalidated[dispatcher];
						IEventDispatcher(dispatcher).dispatchEvent(new eventType(type));
					}
					cleanList = currentList;
				}
			}
			
			_currentLevel = -1;
		}
		
		public function addDispatcher(dispatcher:IEventDispatcher, level:int = 0):void
		{
			if (levels[level] == null) {
				levels[level] = new Dictionary(true);
			}
			levels[level][dispatcher] = true;
			invalidated[dispatcher] = level;
		}
		
		public function removeDispatcher(dispatcher:IEventDispatcher):void
		{
			var level:int = invalidated[dispatcher];
			delete levels[level][dispatcher];
			delete invalidated[dispatcher];
		}
		
		public function hasDispatcher(dispatcher:IEventDispatcher):Boolean
		{
			return Boolean(invalidated[dispatcher]);
		}
		
	}
}
