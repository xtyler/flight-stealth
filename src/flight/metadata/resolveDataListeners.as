package flight.metadata
{
	import flash.events.IEventDispatcher;
	
	/**
	 * @experimental
	 */
	// TODO: Refactor to an object for memory (binding) purposes - possibly extend DataBind with AdvDataBind
	public function resolveDataListeners(instance:Object):void
	{
		var desc:XMLList = Type.describeMethods(instance, "DataListener");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "DataListener");
			
			// to support multiple DataListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
					tag.arg.(@key == "target").@value :
					tag.arg.@value;
				
				// TODO: Refactor the bindSetter, currently traps setters in memory because this is a global space
				dataBind.bindSetter(instance[meth.@name], instance, targ);
			}
		}
	}
	
}

import flight.data.DataBind;

internal var dataBind:DataBind = new DataBind();