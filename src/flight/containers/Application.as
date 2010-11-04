/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import flight.display.InitializePhase;
	import flight.layouts.DockLayout;

	//[Frame(factoryClass="flight.containers.FrameLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends Group
	{
		public function Application()
		{
			addEventListener(InitializePhase.INITIALIZE, onInit);
			if (stage != null) {
				// if this is the root application class
				initStage();
			}
		}
		
		protected function init():void
		{
			layout = new DockLayout();
		}
		
		protected function initStage():void
		{
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
		
		private function onInit(event:Event):void
		{
			init();
		}
	}
}
