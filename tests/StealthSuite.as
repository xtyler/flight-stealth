package 
{
	import flash.display.Stage;
	
	import flight.behaviors.ButtonBehaviorTest;
	import flight.behaviors.CompositeBehaviorTest;
	import flight.behaviors.SelectBehaviorTest;
	import flight.components.ButtonTest;
	import flight.components.ComponentTest;
	import flight.components.DataChangeTest;
	import flight.components.ListTest;
	import flight.display.BitmapDisplayMeasurableTest;
	import flight.display.DisplayFunctionsTest;
	import flight.display.DisplayMeasurableTest;
	import flight.display.DisplayStyleableTest;
	import flight.display.GroupTest;
	import flight.display.TextFieldDisplayMeasurableTest;
	import flight.layouts.BasicLayoutTest;
	import flight.layouts.HorizontalLayoutTest;
	import flight.layouts.VerticalLayoutTest;
	import flight.layouts.XYLayoutTest;
	import flight.measurement.MeasurementFunctionsTest;
	import flight.skins.SkinContainerTest;
	import flight.skins.SkinMeasurementTest;
	import flight.styles.StyleFunctionsTest;
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class StealthSuite
	{
		
		static public var stage:Stage;
		
		public var measuredSprite:DisplayMeasurableTest;
		public var styleableSprite:DisplayStyleableTest;
		
		public var measuredBitmap:BitmapDisplayMeasurableTest;
		public var measuredTextField:TextFieldDisplayMeasurableTest;
		
		public var container:GroupTest;
		
		public var compositeBehavior:CompositeBehaviorTest;
		public var selectabeBehavior:SelectBehaviorTest;
		public var buttonBehavior:ButtonBehaviorTest;
		
		public var skinMeasurement:SkinMeasurementTest;
		public var skinContainer:SkinContainerTest;
		
		public var measurementFunctions:MeasurementFunctionsTest;
		public var styleFunctions:StyleFunctionsTest;
		public var displayFunctions:DisplayFunctionsTest;
		
		public var component:ComponentTest;
		//public var application:ApplicationTest;
		public var button:ButtonTest;
		public var listItem:DataChangeTest;
		public var list:ListTest;
		
		// layouts
		public var xyLayout:XYLayoutTest;
		public var basicLayout:BasicLayoutTest;
		public var verticalLayout:VerticalLayoutTest;
		public var horizontalLayout:HorizontalLayoutTest;
		
	}
}