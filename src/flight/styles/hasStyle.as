/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	public function hasStyle(child:Object, property:String):Boolean
	{
		//if (child.hasOwnProperty("style") && child["style"] != null) {
		//	return (child.style[property] != null);
		if (child is IStyleable) {
			var v:* = (child as IStyleable).getStyle(property);
			return v != null;
		} else {
			return false;
		}
	}
	
}
