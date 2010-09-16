package flight.components
{
	import flight.behaviors.SlideBehavior;
	
	import legato.components.ScrollBarGraphic;

	public class ScrollBar extends RangeBase
	{
		public function ScrollBar()
		{
			skin = new ScrollBarGraphic();
			behaviors.addItem(new SlideBehavior(this));
		}
		
		/*protected function init():void
		{
		//var scrollBarSkin:ScrollBarSkin = new ScrollBarSkin();
		skin = new ScrollBarGraphic();
		var slideBehavior:SlideBehavior = new SlideBehavior(this);
		behaviors.slide = slideBehavior;
		var stepBehavior:StepBehavior = new StepBehavior(this);
		behaviors.step = stepBehavior;
		//			position = scrollBarSkin.position = slideBehavior.position = stepBehavior.position;
		}
		*/
	}
}