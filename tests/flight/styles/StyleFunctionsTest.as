package flight.styles
{
	import org.flexunit.Assert;
	
	import flight.display.SpriteDisplay;

	public class StyleFunctionsTest
	{
		
		[Test]
		public function testHasStyle():void {
			var instance:IStyleClient = new SpriteDisplay();
			instance.setStyle("testStyle", "test");
			Assert.assertTrue(flight.styles.hasStyle(instance, "testStyle"));
		}
		
		[Test]
		public function testResolveStyle():void {
			var instance:IStyleClient = new SpriteDisplay();
			instance.setStyle("testStyle", "test");
			var v:* = flight.styles.resolveStyle(instance, "testStyle");
			Assert.assertEquals("test", v);
		}
		
		[Test]
		public function testResolveStyleStandard():void {
			var instance:IStyleClient = new SpriteDisplay();
			var v:* = flight.styles.resolveStyle(instance, "testStyle", null, "test");
			Assert.assertEquals("test", v);
		}
		
	}
}
