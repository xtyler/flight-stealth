/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.measurement
{
	import flight.layouts.ILayoutBounds;
	import flight.layouts.IBounds;

	/**
	 * @alpha
	 */
	public function resolveHeight(object:Object):Number
	{
		var explicit:IBounds;
		var measured:IBounds;
		if (object is ILayoutBounds) {
			explicit = (object as ILayoutBounds).explicit;
			measured = (object as ILayoutBounds).measured;
			return isNaN(explicit.height) ? measured.height : explicit.height;
		} /*else if (object is IMeasurements) {
			explicit = (object as IMeasurable).explicit;
			measured = (object as IMeasurable).measured;
			return isNaN(explicit.height) ? measured.height : explicit.height;
		} */ else {
			return object.height;
		}
		
	}
	
}
