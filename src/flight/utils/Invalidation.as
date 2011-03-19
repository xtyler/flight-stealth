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

	public class Invalidation
	{
		private static var phaseList:Array = [];
		private static var phaseIndex:Object = {};
		
		private static var rendering:Boolean = true;
		private static var displays:Dictionary = new Dictionary(true);
		private static var displayLevels:Dictionary = new Dictionary(true);
		
		public static function registerPhase(phase:String, eventType:Class = null, priority:int = 0, ascending:Boolean = true):Boolean
		{
			var invalidationPhase:InvalidationPhase = phaseIndex[phase];
			if (!invalidationPhase) {
				invalidationPhase = new InvalidationPhase(phase);
				phaseIndex[phase] = invalidationPhase;
				phaseList.push(invalidationPhase);
			} else if (invalidationPhase.priority == priority &&
					   invalidationPhase.ascending == ascending) {
				return false;
			}
			
			invalidationPhase.priority = priority;
			invalidationPhase.ascending = ascending;
			phaseList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
			return true;
		}
		
		public static function invalidate(target:IEventDispatcher, phase:String, level:int = 1):Boolean
		{
			var invalidationPhase:InvalidationPhase = phaseIndex[phase];
			
			if (!target) {
				return false;
			} else if (!invalidationPhase) {
				throw new Error(getClassName(target) + " cannot be invalidated by unknown phase '" + phase + "'.");
			}
			
			if (!(target is DisplayObject)) {
				return invalidationPhase.add(target, level);
			} else if (invalidationPhase.contains(target)) {
				return false;
			}
			
			var display:DisplayObject = DisplayObject(target);
			var stage:Stage = display.stage;
			
			if (!displays[display]) {
				display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 50, true);
				display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 50, true);
				if (stage && !displays[stage]) {
					stage.addEventListener(Event.RENDER, onRender, false, 50, true);
					stage.addEventListener(Event.RESIZE, onRender, false, 50, true);
					displays[stage] = true;
				}
				displays[display] = true;
			}
			
			if (stage) {
				if (!rendering) {
					stage.invalidate();
				} else {
					setTimeout(stage.invalidate, 1);
				}
				
				level = displayLevels[display] || getDisplayLevel(display);
				return invalidationPhase.add(target, level);
			} else {
				return invalidationPhase.add(target, -1);
			}
		}
		
		public static function validate(target:IEventDispatcher = null, phase:String = null):void
		{
			var invalidationPhase:InvalidationPhase;
			if (phase && !phaseIndex[phase]) {
				throw new Error(getClassName(target) + " cannot be validated by unknown phase '" + phase + "'.");
			} else if (phase) {
				invalidationPhase = phaseIndex[phase];
				invalidationPhase.validate(target);
			} else {
				for each (invalidationPhase in phaseList) {
					invalidationPhase.validate(target);
				}
			}
		}
		
		private static function getDisplayLevel(target:DisplayObject):int
		{
			var level:int = 1;
			var display:DisplayObject = target;
			while ((display = display.parent)) {
				if (displayLevels[display] !== undefined) {
					level += displayLevels[display];
					break;
				}
				++level;
			}
			trace(level, target);
			return displayLevels[target] = level;
		}
		
		private static function onRender(event:Event):void
		{
			rendering = true;
			validate();
			rendering = false;
		}
		
		private static function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var level:int = getDisplayLevel(target);
			
			var phaseList:Array = phaseList;
			for each (var renderPhase:InvalidationPhase in phaseList) {
				if (renderPhase.contains(target)) {
					renderPhase.remove(target);
					invalidate(target, renderPhase.type, level);
				}
			}
		}
		
		private static function onRemovedFromStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			delete displayLevels[target];
			
			var phaseList:Array = phaseList;
			for each (var renderPhase:InvalidationPhase in phaseList) {
				if (renderPhase.contains(target)) {
					renderPhase.remove(target);
					renderPhase.add(target, -1);
				}
			}
		}
	}
}

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

internal class InvalidationPhase
{
	public var ascending:Boolean = false;
	public var priority:int = 0;
	public var eventType:Class;
	public var invalidated:Boolean;
	
	private var levels:Array = [];
	private var invalidTargets:Dictionary = new Dictionary(true);
	private var currentTargets:Dictionary = new Dictionary(true);
	private var currentLevel:int = -1;
	
	public function InvalidationPhase(type:String, eventType:Class = null)
	{
		_type = type;
		this.eventType = eventType || Event;
	}
	
	public function get type():String { return _type; }
	private var _type:String;
	
	public function validate(target:IEventDispatcher = null):void
	{
		if (!invalidated) {
			return;
		}
		invalidated = false;
		
		if (target) {
			if (remove(target)) {
				target.dispatchEvent(new eventType(_type));
			}
			return;
		}
		
		var cleanList:Dictionary = currentTargets;
		var end:int, vel:int;			// ascending or descending between 1 and length
		if (ascending) {
			currentLevel = levels.length - 1;
			end = 0;
			vel = -1;
		} else {
			currentLevel = 1;
			end = levels.length;
			vel = 1;
		}
		
		for (currentLevel; currentLevel != end; currentLevel += vel) {
			
			if (levels[currentLevel]) {
				currentTargets = levels[currentLevel];
				levels[currentLevel] = cleanList;
				
				for (var i:Object in currentTargets) {
					target = IEventDispatcher(i);
					delete currentTargets[target];
					delete invalidTargets[target];
					target.dispatchEvent(new eventType(_type));
				}
				cleanList = currentTargets;
			}
		}
		
		currentLevel = -1;
	}
	
	public function add(target:IEventDispatcher, level:int = 1):Boolean
	{
		if (invalidTargets[target] === level) {
			return false;
		} else if (invalidTargets[target] !== undefined) {
			delete levels[invalidTargets[target]][target];
		}
		
		if (levels[level] == null) {
			levels[level] = new Dictionary(true);
		}
		levels[level][target] = true;
		invalidTargets[target] = level;
		
		if (currentLevel == -1 ||
			(ascending && level >= currentLevel) ||
			(!ascending && level <= currentLevel)) {
			invalidated = true;
		}
		return true;
	}
	
	public function remove(target:IEventDispatcher):Boolean
	{
		if (invalidTargets[target] === undefined) {
			return false;
		}
		var level:int = invalidTargets[target];
		delete levels[level][target];
		delete invalidTargets[target];
		return true;
	}
	
	public function contains(target:IEventDispatcher):Boolean
	{
		return invalidTargets[target] !== undefined;
	}
}
