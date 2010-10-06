/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.templating
{
	import flash.display.DisplayObject;
	
	import flight.display.IDrawable;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	/**
	 * Returns a renderer to be used for the given data according to the given template.
	 */
	public function getDataRenderer(container:Object, data:*, template:Object):Object
	{
		var instance:Object;
		if (template is IDataTemplate) {
			instance = (template as IDataTemplate).createDisplayObject(data);
		} else if (template is IFactory) {
			instance = (template as IFactory).newInstance();
		} else if (template is Class) {
			instance = new (template as Class);
		} else if (template is Function) {
			instance = (template as Function)(data);
		} else if (data is DisplayObject) {
			instance = data as DisplayObject;
		}
		if (instance is IDataRenderer) {
			(instance as IDataRenderer).data = data;
		}
//		if (data is IDrawable) {
//			(data as IDrawable).target = container;
//		}
		return instance != null ? instance : data;
	}
	
}
