package flight.components
{
	import flight.collections.SimpleCollection;
	import flight.data.Range;
	import flight.layouts.XYLayout;
	import flight.tests.TestBase;

	import raptor.lists.ListBase;

	public class ListTest extends TestBase
	{
		
		[Test(async)]
		public function testDataProviderChange():void {
			testPropertyChange(ListBase, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testDataProviderNotChanged():void {
			testPropertyNotChanged(ListBase, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(ListBase, "template", {});
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyNotChanged(ListBase, "template", {});
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(ListBase, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(ListBase, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testPositionChange():void {
			testPropertyChange(ListBase, "position", new Range());
		}
		
		[Test(async)]
		public function testPositionNotChanged():void {
			testPropertyNotChanged(ListBase, "position", new Range());
		}
		
	}
}
