package flight.components
{
	import flight.tests.TestBase;

	import raptor.buttons.ButtonBase;

	public class ButtonTest extends TestBase
	{
		
		[Test(async)]
		public function testLabelChange():void {
			testPropertyChange(ButtonBase, "label", "test");
		}
		
		[Test(async)]
		public function testLabelNotChanged():void {
			testPropertyNotChanged(ButtonBase, "label", "test");
		}
		
		[Test(async)]
		public function testSelectedChange():void {
			testPropertyChange(ButtonBase, "selected", true);
		}
		
		[Test(async)]
		public function testSelectedNotChanged():void {
			testPropertyNotChanged(ButtonBase, "selected", true);
		}
		
	}
}
