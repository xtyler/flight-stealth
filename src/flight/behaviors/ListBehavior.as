/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;

	public class ListBehavior extends Behavior
	{
		public var hScrollBar:InteractiveObject;
		public var vScrollBar:InteractiveObject;
		
		private var hSlideBehavior:SlideBehavior;
		private var vSlideBehavior:SlideBehavior;
		
		public function ListBehavior()
		{
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			//var skin:ISkin = ISkinnable(target).skin;
			
//			hScrollBar = getSkinPart('hScrollBar');
//			vScrollBar = getSkinPart('vScrollBar');
			
			hSlideBehavior = new SlideBehavior();
			vSlideBehavior = new SlideBehavior();
			
			hSlideBehavior.target = hScrollBar;
			vSlideBehavior.target = vScrollBar;
			
		}
	}
}
