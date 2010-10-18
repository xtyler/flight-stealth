package flight.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import org.flexunit.Assert;
	
	import flight.display.SpriteDisplay;

	public class VerticalLayoutTest extends EventDispatcher
	{
		
		[Test]
		public function testMeasurement():void {
			var child1:SpriteDisplay = new SpriteDisplay();
			var child2:SpriteDisplay = new SpriteDisplay();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.paddingVertical = 10;
			var point:Point = layout.measure([child1, child2]);
			Assert.assertEquals(20, point.x);
			Assert.assertEquals(60, point.y);
		}
		
	}
}
