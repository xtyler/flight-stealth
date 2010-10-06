package flight.graphics
{
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.events.Event;

	import flight.display.RenderPhase;
	import flight.display.ShapeDisplay;
	import flight.graphics.paint.IFill;
	import flight.graphics.paint.IStroke;
	
	public class GraphicShape extends ShapeDisplay implements IGraphicShape
	{
		public static const DRAW:String = "draw";
		RenderPhase.registerPhase(DRAW, 0xFF);
		
		// TODO: naming?
		public var canvas:Graphics;
		
		public var graphicsPath:GraphicsPath;
		public var graphicsData:Vector.<IGraphicsData>;
		
		public function GraphicShape()
		{
			graphicsData = new Vector.<IGraphicsData>;
			graphicsPath = new GraphicsPath();
		}
		
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}
		private var _stroke:IStroke;
		
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void
		{
			_fill = value;
		}
		private var _fill:IFill;
		
		
		public function draw(graphics:Graphics):void
		{
			graphics.drawGraphicsData(graphicsData);
		}
		
		public function update():void
		{
			graphicsData.splice(0, graphicsData.length);
			if (stroke) {
				graphicsData.push(stroke.graphicsStroke);
			}
			if (fill) {
				graphicsData.push(fill.graphicsFill);
			}
			graphicsData.push(graphicsPath);
		}
		
		private function onDraw(event:Event):void
		{
			update();
			draw(canvas || graphics);
		}
	}
}
