/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	
	public function resolveStyle(child:Object, property:String, type:Object = null, standard:* = null):Object
	{
		//if (child.hasOwnProperty("style") && child["style"] != null) {
		//	return child.style[property];
		if (child is IStyleClient) {
			var v:* = (child as IStyleClient).getStyle(property);
			return v != null ? v : standard;
		} else {
			return standard;
		}
	}
	
}
