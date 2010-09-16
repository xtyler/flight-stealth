package flight.behaviors
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import org.flexunit.asserts.assertEquals;
	
	import flight.containers.Group;

	public class ButtonBehaviorTest
	{
		
		public var stage:Stage;
		public var display:Group;
		
		public function ButtonBehaviorTest() {
			stage = StealthSuite.stage;
			display = new Group();
			var behavior:ButtonBehavior = new ButtonBehavior(display);
		}
		
		[Test]
		public function testButtonStateUp():void {
			stage.addChild(display);
			display.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true));
			assertEquals("up", display.currentState);
			stage.removeChild(display);
		}
		
		[Test]
		public function testButtonStateOver():void {
			stage.addChild(display);
			display.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true));
			assertEquals("over", display.currentState);
			stage.removeChild(display);
		}
		
		[Test]
		public function testButtonStateDown():void {
			stage.addChild(display);
			display.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true));
			assertEquals("down", display.currentState);
			stage.removeChild(display);
		}
		
		
		
	}
}