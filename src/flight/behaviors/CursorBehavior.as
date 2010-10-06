/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	
	import flight.cursors.Cursor;
	
	public class CursorBehavior extends Behavior
	{
		[Bindable]
		public var cursor:Object;
		
		public function CursorBehavior(target:IEventDispatcher = null)
		{
			super(target);
			dataBind.bindSetter(cursorChange, this, "cursor");
			dataBind.bindSetter(targetChange, this, "target");
		}
		
		protected function cursorChange(cursor:Object):void
		{
			if (target) {
				Cursor.useCursor(target, cursor);
			}
		}
		
		protected function targetChange(oldTarget:InteractiveObject, newTarget:InteractiveObject):void
		{
			if (oldTarget && cursor) Cursor.useCursor(oldTarget, null);
			if (newTarget && cursor) Cursor.useCursor(newTarget, cursor);
		}
	}
}
