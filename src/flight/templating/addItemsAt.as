/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.templating
{
	import flash.display.DisplayObject;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addItemsAt(container:Object, children:Array, index:int = 0, template:Object = null):Array
	{
		var output:Array = [];
		var length:int = children.length;
		for (var i:int = 0; i < length; i++) {
			var child:Object = children[i];
			var renderer:Object = addItemAt(container, child, index, template);
			output.push(renderer);
			if (renderer is DisplayObject) {
				index++;
			}
		}
		return output;
	}
	
}
