package flight.components
{
	import flight.tests.TestBase;
	
	public class DataChangeTest extends TestBase
	{
		
		[Test(async)]
		public function testDataChange():void {
			testPropertyChange(Component, "data", {});
		}
		
		[Test(async)]
		public function testDataNotChanged():void {
			testPropertyNotChanged(Component, "data", {});
		}
		
	}
}