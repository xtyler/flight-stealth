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
	public function resolveWidth(object:Object):Number
	{
		var explicit:IBounds;
		var measured:IBounds;
		if (object is ILayoutBounds) {
			explicit = (object as ILayoutBounds).explicit;
			measured = (object as ILayoutBounds).measured;
			return isNaN(explicit.width) ? measured.width : explicit.width;
		} /* else if (object is IMeasurements) {
			measurements = (object as IMeasurements);
			return isNaN(measurements.explicitWidth) ? measurements.measuredWidth : measurements.explicitWidth;
		} */ else {
			return object.width;
		}
		
	}
	
}
