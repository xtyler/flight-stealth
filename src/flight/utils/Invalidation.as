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

	/**
	 * The Invalidation utility allows potentially expensive processes, such as
	 * layout, to delay their execution and run these processes just once each
	 * time the screen is rendered. In the case of layout this delayed execution
	 * is essential, because size and position of parents affect the size and
	 * position of their children and vice versa, through all levels of the
	 * display-list. Invalidation runs in ordered execution by level and
	 * supports any number of custom phases (it is recommended to maintain a
	 * small set of known phases for performance and approachability).
	 */
	public class Invalidation
	{
		/**
		 * An Array of registered phases ordered by priority from highest to
		 * lowest.
		 */
		public static var phaseList:Array = [];

		/**
		 * Internal phase lookup by phase name, for convenience.
		 */
		private static var phaseIndex:Object = {};

		/**
		 * Indicates invalidation is currently running under a "render" event
		 * dispatched from Stage.
		 */
		private static var rendering:Boolean = true;

		/**
		 * Internal weak-referenced registry of all display objects and their
		 * stages that have touched invalidation, to allow one-time setup on
		 * each of these objects.
		 */
		private static var displays:Dictionary = new Dictionary(true);

		/**
		 * Internal weak-referenced registry of the levels (depth in hierarchy
		 * from the stage down, with stage being 1, root 2, etc) of all display
		 * objects currently invalidated.
		 */
		private static var displayLevels:Dictionary = new Dictionary(true);

		/**
		 * Phases of invalidation such as "measure", "layout" and "draw" allow
		 * different systems to register their own pass over the display-list
		 * independent of any other system. Phases are ordered by priority and
		 * marked as ascending (execution of child then parent) or descending
		 * (from parent to child). Though phases run in the same render cycle
		 * they are independent from each other and must be invalidated
		 * independently. Finally, each phase supports a unique event dispatched
		 * from the display object which is how systems such as layout execute.
		 * 
		 * For example:
		 * <code>
		 *     // phases only need to be registered once
		 *     Invalidation.registerPhase(LayoutEvent.MEASURE, LayoutEvent, 100);
		 *     
		 *     // invalidate/listen on display objects wanting to support measurement
		 *     Invalidation.invalidate(sprite, LayoutEvent.MEASURE);
		 *     sprite.addEventListener(LayoutEvent.MEASURE, onMeasure);
		 *     
		 *     function onMeasure(event:LayoutEvent):void
		 *     {
		 *         // run measurement code on event.target (the invalidated display object)
		 *     }
		 * </code>
		 * 
		 * @param phaseName		The name by which objects are invalidated and
		 * 						the event type dispatched on their validation.
		 * @param eventType		The event class created and dispatched on
		 * 						validation.
		 * @param priority		Phase priority relating to other phases, where
		 * 						higher priority runs validation first.
		 * @param ascending		Determines order of execution within the phase
		 * 						with ascending from child to parent.
		 * @return				Returns true if phase was successful registered
		 * 						for the first time, or re-registered with new
		 * 						priority/ascending settings.
		 */
		public static function registerPhase(phaseName:String, eventType:Class = null, priority:int = 0, ascending:Boolean = true):Boolean
		{
			var invalidationPhase:InvalidationPhase = phaseIndex[phaseName];
			if (!invalidationPhase) {
				invalidationPhase = new InvalidationPhase(phaseName, eventType);
				phaseList.push(invalidationPhase);									// keep track of phases in both ordered phaseList and the phaseIndex easy lookup
				phaseIndex[phaseName] = invalidationPhase;
			} else if (invalidationPhase.priority == priority &&
					   invalidationPhase.ascending == ascending) {
				return false;
			}
			
			invalidationPhase.priority = priority;
			invalidationPhase.ascending = ascending;
			phaseList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);			// always maintain order - phases shouldn't be registered often
			return true;
		}

		/**
		 * Marks a target for delayed execution in the specified phase, to
		 * execute just once this render cycle regardless of the number times
		 * invalidate is called. Phase "execution" is carried out through an
		 * event of type phaseName dispatched from the target, and can be
		 * listened to by anyone.
		 * 
		 * @param target		The IEventDispatcher or display object to be
		 * 						invalidated.
		 * @param phaseName		The phase to be invalidated by, and the event
		 * 						type dispatched on resolution.
		 * @param level			Optional level supplied for IEventDispatchers.
		 * 						Display objects' level is calculated internally.
		 * @return				Returns true if the target was invalidated for
		 * 						the first time this render cycle.
		 */
		public static function invalidate(target:IEventDispatcher, phaseName:String, level:int = 1):Boolean
		{
			var invalidationPhase:InvalidationPhase = phaseIndex[phaseName];
			
			if (!target) {
				return false;
			} else if (!invalidationPhase) {
				throw new Error(getClassName(target) + " cannot be invalidated by unknown phase '" + phaseName + "'.");
			}
			
			// no special treatment for non-display objects or display objects that are already invalidated
			if (!(target is DisplayObject)) {
				return invalidationPhase.add(target, level);
			} else if (invalidationPhase.contains(target)) {
				return false;
			}
			// display objects invalidated for the first time this render cycle are watched for level changes and require stage invalidation
			var display:DisplayObject = DisplayObject(target);
			var stage:Stage = display.stage;
			
			
			if (!displays[display]) {																		// setup listeners only once on a display object
				display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 50, true);			// watch for level changes - this is a permanent fixture since these changes happen
				display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 50, true);	// less frequently than invalidation and so require fewer level calculations
				if (stage && !displays[stage]) {
					stage.addEventListener(Event.RENDER, onRender, false, 50, true);						// listen to ALL stage render events, also a permanent fixture since they only get
																											// dispatched with a stage.invalidate and add/remove listeners costs some in performance
					stage.addEventListener(Event.RESIZE, onRender, false, 50, true);						// in many environments render and enterFrame events stop firing when stage is resized -
																											// listening to resize compensates for this shortcoming and continues to run validation
					displays[stage] = true;																	// with each screen render
				}
				displays[display] = true;
			}
			
			if (stage) {
				if (!rendering) {
					stage.invalidate();
				} else {
					setTimeout(stage.invalidate, 1);								// stage.invalidate can't be called in the middle of a render cycle -
																					// it just doesn't work. Note that this delayed stage invalidation
																					// isn't always utilized because phases are smart enough to include
																					// targets of yet un-executed levels in the current render cycle.
				}
				level = displayLevels[display] || getDisplayLevel(display);			// retrieve level (depth in hierarchy) for proper ordering
				return invalidationPhase.add(display, level);
			} else {
				return invalidationPhase.add(display, -1);							// keep a reference to invalidated targets on the phase, but stored at
																					// a level that won't be executed until display is addedToStage
			}
		}

		/**
		 * Most often internally invoked with the render cycle, validate runs
		 * each phase of invalidation by priority and level. A specific target
		 * and phase may be validated manually independent of the render cycle. 
		 * 
		 * @param target		Optional invalidated target to be resolved. If
		 * 						null, full validation cycle is run.
		 * 						are resolved.
		 * @param phaseName		Optional invalidation phase to run. If null, all
		 * 						phases will be run in order of priority.
		 */
		public static function validate(target:IEventDispatcher = null, phaseName:String = null):void
		{
			var invalidationPhase:InvalidationPhase;
			if (phaseName && !phaseIndex[phaseName]) {
				throw new Error(getClassName(target) + " cannot be validated by unknown phase '" + phaseName + "'.");
			} else if (phaseName) {
				invalidationPhase = phaseIndex[phaseName];
				invalidationPhase.validate(target);
			} else {
				for each (invalidationPhase in phaseList) {
					invalidationPhase.validate(target);
				}
			}
		}

		/**
		 * Calculates the level in display-list hierarchy of target display
		 * object, where stage is level 1, children of stage are level 2, their
		 * children are level 3 and so on.
		 * 
		 * @param target		Display object residing in the display-list.
		 * @return				Hierarchical level as an integer.
		 */
		private static function getDisplayLevel(target:DisplayObject):int
		{
			var level:int = 1;														// start with level 1, stage, which has no parent
			var display:DisplayObject = target;
			while ((display = display.parent)) {
				if (displayLevels[display] !== undefined) {							// shortcut when parent level is already defined - used often
					level += displayLevels[display];								// because addedToStage resolves for parents before children
					break;
				}
				++level;
			}
			return displayLevels[target] = level;									// assign in a global index and return
		}

		/**
		 * Listener responding to both render and stage resize events.
		 */
		private static function onRender(event:Event):void
		{
			rendering = true;
			validate();
			rendering = false;
		}

		/**
		 * Listener responding to any previously invalidated display objects
		 * being added to the display-list, calculating their level (depth
		 * in display-list hierarchy).
		 */
		private static function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var level:int = getDisplayLevel(target);
			
			var phaseList:Array = phaseList;										// correctly invalidate newly added display object on all phases
			for each (var renderPhase:InvalidationPhase in phaseList) {				// where it was invalidated while off of the display-list (and set at level -1)
				if (renderPhase.contains(target)) {
					renderPhase.remove(target);
					invalidate(target, renderPhase.name, level);
				}
			}
		}

		/**
		 * Listener responding to any previously invalidated display objects
		 * being removed from the display-list, deleting their level (depth
		 * in display-list hierarchy).
		 */
		private static function onRemovedFromStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			delete displayLevels[target];
			
			var phaseList:Array = phaseList;										// remove display object from proper invalidation and add it at level -1
			for each (var renderPhase:InvalidationPhase in phaseList) {				// where it won't be executed until added to display-list again
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

/**
 * Internal class for exclusive use with Invalidation, representing a phase
 * of invalidation such as "measure", "layout or "draw" and storing invalidated
 * targets until validate is called.
 */
internal class InvalidationPhase
{
	/**
	 * Order of execution in display-list hierarchy, where ascending is from
	 * child to parent up the display list until the stage is reached.
	 */
	public var ascending:Boolean = false;

	/**
	 * The priority of this phase relating to other invalidation phases.
	 */
	public var priority:int = 0;

	/**
	 * The event class instantiated for dispatch from invalidation targets.
	 */
	public var eventType:Class;

	/**
	 * Flag indicating whether there have been any invalidation targets added
	 * since last validation.
	 */
	public var invalidated:Boolean;
	
	/**
	 * List of dictionaries storing invalidation targets, indexed by level.
	 */
	private var levels:Array = [];
	
	/**
	 * Quick reference with invalidated targets as key and value as level.
	 */
	private var invalidTargets:Dictionary = new Dictionary(true);

	/**
	 * Current level's dictionary storing invalidation targets, always taken
	 * from the levels array, rotating in the empty dictionary.
	 */
	private var currentTargets:Dictionary = new Dictionary(true);

	/**
	 * Current level being executed, or -1 when not running.
	 */
	private var currentLevel:int = -1;

	/**
	 * Constructor requiring phase name also used as event type, and optionally
	 * the class used for event instantiation.
	 * 
	 * @param name			Phase name, also the event type.
	 * @param eventType		Event class used when dispatching from invalidation
	 * 						targets.
	 */
	public function InvalidationPhase(name:String, eventType:Class = null)
	{
		_name = name;
		this.eventType = eventType || Event;
	}

	/**
	 * Phase name, also used as the event type.
	 */
	public function get name():String { return _name; }
	private var _name:String;

	/**
	 * Execution of the phase by dispatching an event from each target, in order
	 * ascending or descending by level. Event type and class correlate with
	 * phase name and eventType respectively.
	 * 
	 * @param target		Optional target may be specified for isolated
	 * 						validation. If null, full validation is run on all
	 * 						targets in proper level order.
	 */
	public function validate(target:IEventDispatcher = null):void
	{
		if (!invalidated) {
			return;
		}
		invalidated = false;
		
		if (target) {																// skip full validation and run only on specified target
			if (remove(target)) {
				target.dispatchEvent(new eventType(_name));
			}
			return;
		}
		
		var cleanList:Dictionary = currentTargets;									// rotating dictionary - always one clean dictionary to be put in place
																					// of the current dictionary, allowing invalidation to add new items at
																					// this current level for processing next time.
		var end:int, vel:int;
		if (ascending) {															// ascending or descending between 1 and length, velocity of 1 or -1
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
				currentTargets = levels[currentLevel];								// retrieve current level's dictionary for target iteration and replace it 
				levels[currentLevel] = cleanList;									// with a clean one, allowing for invalidation to occur on this level
																					// to be resolved with the next validation call
				
				for (var key:Object in currentTargets) {							// targets stored as keys remain weak-referenced and can be garbage collected
					target = IEventDispatcher(key);
					delete currentTargets[target];
					delete invalidTargets[target];
					target.dispatchEvent(new eventType(_name));
				}
				cleanList = currentTargets;											// current level's dictionary has now been emptied
			}
		}
		
		currentLevel = -1;															// reset current level indicator when not in use
	}

	/**
	 * Effectively invalidates target with this phase.
	 * 
	 * @param target		Target to be invalidated.
	 * @param level			Level in display-list hierarchy.
	 * @return				Returns true the first time target is invalidated.
	 */
	public function add(target:IEventDispatcher, level:int = 1):Boolean
	{
		if (invalidTargets[target] === level) {
			return false;															// already invalidated
		} else if (invalidTargets[target] !== undefined) {							// invalidated, but at a different level, so clear and re-invalidate
			delete levels[invalidTargets[target]][target];
		}
		
		if (levels[level] == null) {
			levels[level] = new Dictionary(true);									// once a level is assigned a dictionary it will always have a dictionary
		}
		levels[level][target] = true;												// store target in both the level and the quick reference
		invalidTargets[target] = level;
		
		if (currentLevel == -1 ||
			(ascending && level >= currentLevel) ||									// targets invalidated in a level soon-to-be executed do not flag an invalid phase
			(!ascending && level <= currentLevel)) {
			invalidated = true;
		}
		return true;
	}

	/**
	 * Removes a target from invalidation without executing validation.
	 * 
	 * @param target		Target to be removed, reversing invalidation.
	 * @return				Returns true if the target was previously
	 * 						invalidated.
	 */
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
