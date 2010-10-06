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
	// this needs some updates to handle non-DisplayObjects (like Rect) better
	public function resolveCommitProperties(instance:Object, resolver:Function = null):void
	{
		var desc:XMLList = Type.describeMethods(instance, "CommitProperties");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "CommitProperties");
			
			// to support multiple CommitProperties metadata tags on a single method
			for each (var tag:XML in meta) {
				var target:String = ( tag.arg.(@key == "target").length() > 0 ) ? tag.arg.(@key == "target").@value : tag.arg.@value;
				var properties:Array = target.replace(/\s+/g, "").split(",");
				CommitUtility.instance.register(instance, meth.@name, properties, resolver);
			}
		}
	}
	
}
