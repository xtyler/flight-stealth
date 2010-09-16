package flight.display
{
	import org.flexunit.Assert;
	
	import flight.styles.IStyleable;
	import flight.styles.StyleableTestBase;
	
	public class DisplayStyleableTest extends StyleableTestBase
	{
		
		public function DisplayStyleableTest()
		{
			super();
			C = Display;
		}
		
		[Test]
		public function testStyleString():void {
			var instance:Display = new C();
			instance.style = "testStyle: test;"; // more complex parsing needed later
			var v:Object = instance.getStyle("testStyle");
			Assert.assertEquals("test", v);
		}
		
	}
}