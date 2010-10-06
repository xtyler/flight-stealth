package flight.measurement
{
	import flight.layouts.ILayoutBounds;

	import org.flexunit.Assert;
	
	import flight.display.SpriteDisplay;

	public class MeasurementFunctionsTest
	{
		
		[Test]
		public function testResolveWidthObject():void {
			var object:Object = {width: 100};
			var v:Number = flight.measurement.resolveWidth(object);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveWidthMeasured():void {
			var instance:ILayoutBounds = new SpriteDisplay();
			instance.measured.width = 100;
			var v:Number = flight.measurement.resolveWidth(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveWidthexplicit():void {
			var instance:ILayoutBounds = new SpriteDisplay();
			instance.measured.width = 5;
			instance.explicit.width = 100;
			var v:Number = flight.measurement.resolveWidth(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightObject():void {
			var object:Object = {height: 100};
			var v:Number = flight.measurement.resolveHeight(object);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightMeasured():void {
			var instance:ILayoutBounds = new SpriteDisplay();
			instance.measured.height = 100;
			var v:Number = flight.measurement.resolveHeight(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightexplicit():void {
			var instance:ILayoutBounds = new SpriteDisplay();
			instance.measured.height= 5;
			instance.explicit.height = 100;
			var v:Number = flight.measurement.resolveHeight(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testSetSizeObject():void {
			var object:Object = {};
			flight.measurement.setSize(object, 100, 100);
			Assert.assertEquals(100, object.width);
			Assert.assertEquals(100, object.height);
		}
		
		[Test]
		public function testSetSizeMeasurable():void {
			var instance:ILayoutBounds = new SpriteDisplay();
			instance.measured.width = 5;
			instance.measured.height = 5;
			instance.explicit.width = 5;
			instance.explicit.height = 5;
			flight.measurement.setSize(instance, 100, 100);
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(5, instance.measured.width);
			Assert.assertEquals(5, instance.measured.height);
			Assert.assertEquals(5, instance.explicit.width);
			Assert.assertEquals(5, instance.explicit.height);
		}
		
	}
}
