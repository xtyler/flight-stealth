package flight.skins
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	/**
	 * Implemented by objects which will provide the visual definition for a component's display.
	 * 
	 * @alpha
	 */
	public interface ISkin
	{
		
		function get target():Sprite;
		function set target(value:Sprite):void;
		
		function getSkinPart(part:String):InteractiveObject;
	}
}