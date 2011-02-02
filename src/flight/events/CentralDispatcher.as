package flight.events
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class CentralDispatcher implements IEventDispatcher
	{
		public var target:Object;
		
		public function CentralDispatcher(target:Object = null)
		{
			this.target = target || this;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			CentralDispatcher.addEventListener(type, target, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			CentralDispatcher.removeEventListener(type, target, listener, useCapture);
		}
		
		public function dispatch(type:String):void
		{
			if (CentralDispatcher.hasEventListener(type, target)) {
				CentralDispatcher.dispatchEvent(new CentralEvent(type, target));
			}
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return CentralDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return CentralDispatcher.hasEventListener(type, target);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return CentralDispatcher.willTrigger(type, target);
		}
		
		// ==== Central EventDispatcher ==== //
		
		public static function addEventListener(type:String, target:Object, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			type = getTargetType(type, target);
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, target:Object, listener:Function, useCapture:Boolean = false):void
		{
			type = getTargetType(type, target);
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public static function hasEventListener(type:String, target:Object):Boolean
		{
			type = getTargetType(type, target);
			return dispatcher.hasEventListener(type);
		}
		
		public static function willTrigger(type:String, target:Object):Boolean
		{
			type = getTargetType(type, target);
			return dispatcher.willTrigger(type);
		}
		
		private static var targetId:Number = 0;
		private static var targetIds:Dictionary = new Dictionary(true);
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		internal static function getTargetType(type:String, target:Object):String
		{
			if (target) {
				var id:String = targetIds[target] || (targetIds[target] = ++targetId + ":");
				return id + type;
			} else {
				return type;
			}
		}
	}
}
