/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.measurement
{
	import flight.layouts.ILayoutBounds;

	public function setSize(child:Object, width:Number, height:Number):void
	{
		if (child is ILayoutBounds) { // || child is IDrawable
			child.setSize(width, height);
		} else if (child != null) {
			child.width = width;
			child.height = height;
		}
	}
	
}
