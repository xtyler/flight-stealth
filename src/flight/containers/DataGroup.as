/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.events.Event;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.display.LayoutPhase;
	import flight.display.RenderPhase;
	import flight.list.IList;
	import flight.templating.addItemsAt;
	
	public class DataGroup extends Group
	{
		[ArrayElementType("Object")]
		public var dataProvider:IList;
		public var itemRenderer:Object;
		public var itemRendererFunction:Function;
		 
		private var _template:Object;
		private var renderers:Array;
		
		public function DataGroup()
		{
		}
		
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void
		{
			if (_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			if (content != null) {
				var items:Array = [];
				var length:int = content.length;
				for (var i:int = 0; i < length; i++) {
					var child:Object = content.getItemAt(i);
					items.push(child);
				}
				reset(items);
			}
			RenderPhase.invalidate(this, LayoutPhase.MEASURE);
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
			dispatchEvent(new Event("templateChange"));
		}
		
		private function onMeasure(event:Event):void
		{
			if ((isNaN(explicit.width) || isNaN(explicit.height)) && layout) {
//				var point:Point = layout.measure(renderers);
//				measured.width = point.x;
//				measured.height = point.y;
			}
		}
		
		private function onLayout(event:Event):void
		{
			if (layout) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
//				layout.update(renderers, rectangle);
			}
		}
		
		private function add(items:Array, index:int):void
		{
			var children:Array = addItemsAt(this, items, index, _template);
			renderers.concat(children); // todo: correct ordering
		}
		
		private function reset(items:Array):void
		{
			while (numChildren) {
				removeChildAt(numChildren - 1);
			}
			renderers = addItemsAt(this, items, 0, _template); // todo: correct ordering
			RenderPhase.invalidate(this, LayoutPhase.LAYOUT);
		}
	}
}
