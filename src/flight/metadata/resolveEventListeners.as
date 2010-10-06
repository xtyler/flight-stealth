/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.metadata
{
	
	
	/**
	 * @experimental
	 */
	// TODO: Refactor to an object for memory (binding) purposes - possibly extend DataBind with AdvDataBind
	public function resolveEventListeners(instance:Object):void
	{
		var desc:XMLList = Type.describeMethods(instance, "EventListener");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "EventListener");
			
			// to support multiple EventListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var type:String = ( tag.arg.(@key == "type").length() > 0 ) ?
					tag.arg.(@key == "type").@value :
					tag.arg.@value;
				var targ:String = tag.arg.(@key == "target").@value;
				
				// TODO: Refactor the bindSetter, currently traps setters in memory because this is a global space
				dataBind.bindEventListener(type, instance[meth.@name], instance, targ);
			}
		}
		
	}
	
}

import flight.data.DataBind;

internal var dataBind:DataBind = new DataBind();
