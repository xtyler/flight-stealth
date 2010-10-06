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
	public function addItem(container:Object, child:Object, template:Object = null):Object
	{
		var renderer:Object = getDataRenderer(container, child, template);
		container.addChild(renderer as DisplayObject);
		return renderer;
	}
	
}
