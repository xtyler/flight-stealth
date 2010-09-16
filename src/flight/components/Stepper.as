package flight.components
{
	import flight.behaviors.StepBehavior;
	import flight.data.DataChange;
	import flight.data.IRange;
	import flight.data.Range;
	
	public class Stepper extends Component
	{
		
		private var _position:IRange;
		
		[Bindable(event="positionChange")]
		public function get position():IRange { return _position; }
		public function set position(value:IRange):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function Stepper()
		{
			position = new Range();
			position.position = 0;
			position.min = 0;
			position.max = 100;
			//skin = new StepperSkin();
			behaviors = new StepBehavior();
		}
	}
}