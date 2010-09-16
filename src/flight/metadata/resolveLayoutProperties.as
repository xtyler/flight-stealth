package flight.metadata
{
	import flash.events.IEventDispatcher;
	
	// this method of listening for layout invalidating changes is very much experimental
	/**
	 * @experimental
	 */
	// TODO: Refactor to an object for memory (binding) purposes - possibly incorporate to Layout base class
	public function resolveLayoutProperties(instance:Object, child:Object, listener:Function):void
	{
		var desc:XML = Type.describeType(instance);
		for each (var meth:XML in desc.factory[0]) {
			var meta:XMLList = meth.metadata.(@name == "LayoutProperty");
			
			// to support multiple DataListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var sourcePath:String = tag.arg.(@key == "name").@value;
				// TODO: Refactor the bindSetter, currently traps setters in memory because this is a global space
				dataBind.bindSetter(listener, child, sourcePath);
			}
			
		}
	}
	
}

import flight.data.DataBind;

internal var dataBind:DataBind = new DataBind();