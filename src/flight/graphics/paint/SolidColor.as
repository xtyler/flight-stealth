/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsFill;
	
	public class SolidColor implements IFill
	{
		public var color:uint;
		public var alpha:int;
		
		private var solidFill:GraphicsSolidFill;
		
		public function SolidColor(color:uint = 0x000000, alpha:Number = 1)
		{
			this.color = color;
			this.alpha = alpha;
			solidFill = new GraphicsSolidFill(color, alpha);
		}
		
		protected function update():void
		{
			solidFill.color = color;
			solidFill.alpha = alpha;
		}
		
		public function get graphicsFill():IGraphicsFill
		{
			return solidFill;
		}
	}
}
