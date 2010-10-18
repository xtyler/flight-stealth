/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics
{
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.events.Event;

	import flash.geom.Matrix;

	import flight.display.DrawPhase;
	import flight.display.RenderPhase;
	import flight.display.ShapeDisplay;
	import flight.graphics.paint.IFill;
	import flight.graphics.paint.IStroke;
	
	public class GraphicShape extends ShapeDisplay implements IGraphicShape
	{
		// TODO: naming?
		public var canvas:Graphics;
		public var canvasTransform:Matrix;
		
		public var graphicsPath:GraphicsPath;
		public var graphicsData:Vector.<IGraphicsData>;
		
		// TODO: path should draw before measure, rect/ellipse should draw after layout
		public function GraphicShape()
		{
			graphicsData = new Vector.<IGraphicsData>;
			graphicsPath = new GraphicsPath();
			addEventListener(DrawPhase.DRAW, onDraw);
			invalidate(DrawPhase.DRAW);
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
