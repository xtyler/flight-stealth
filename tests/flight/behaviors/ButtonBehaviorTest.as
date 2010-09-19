package flight.behaviors
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import flight.components.Component;
	
	import org.flexunit.asserts.assertEquals;

	public class ButtonBehaviorTest
	{
		
		public var stage:Stage;
		public var display:Component;
		
		public function ButtonBehaviorTest() {
			stage = StealthSuite.stage;
			display = new Component();
			display.behaviors.add(new ButtonBehavior(display));
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