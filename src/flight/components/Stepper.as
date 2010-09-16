package flight.components
{
	import flight.behaviors.StepBehavior;
	import flight.data.Range;
	
	
	//import reflex.skins.StepperSkin;
	
	public class Stepper extends RangeBase
	{
		
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