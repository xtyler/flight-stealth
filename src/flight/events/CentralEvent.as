package flight.events
{
	import flash.events.Event;
	
	public class CentralEvent extends Event
	{
		public function CentralEvent(type:String, target:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_type = type;
			_target = target;
			type = CentralDispatcher.getTargetType(type, target);
			super(type, bubbles, cancelable);
		}

		override public function get type():String { return _type; }
		private var _type:String;

		override public function get target():Object { return super.target ? _target || super.target : null; }
		private var _target:Object;

		override public function clone():Event
		{
			return new CentralEvent(type, _target, bubbles, cancelable);
		}
	}
}
