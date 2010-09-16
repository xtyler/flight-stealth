package flight.components
{
	import flight.data.DataChange;
	import flight.data.IRange;
	
	public class RangeBase extends Component
	{
		
		private var _position:IRange;
		
		[Bindable(event="positionChange")]
		public function get position():IRange { return _position; }
		public function set position(value:IRange):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function RangeBase()
		{
		}
	}
}