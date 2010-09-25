package flight.components
{
	import flight.behaviors.SlideBehavior;
	import flight.behaviors.StepBehavior;
	import flight.data.DataChange;
	import flight.data.IScroll;
	import flight.data.Scroll;
	import flight.skins.MovieClipSkin;
	
	import legato.components.ScrollBarGraphic;

	public class ScrollBar extends Component
	{
		private var _position:IScroll = new Scroll();
		
		[Bindable(event="positionChange")]
		public function get position():IScroll { return _position; }
		public function set position(value:IScroll):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function ScrollBar()
		{
			position.stepSize = 10;
			position.pageSize = 40;
			skin = new MovieClipSkin(new legato.components.ScrollBarGraphic());
			behaviors.step = new StepBehavior();
			behaviors.slide = new SlideBehavior();
		}
	}
}