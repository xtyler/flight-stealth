/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.text
{
	
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	import flight.metadata.resolveCommitProperties;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	public class Text extends TextFieldDisplay
	{
		public function Text()
		{
			super();
			this.selectable = false;
			resolveCommitProperties(this);
		}
		
		/**
		 * @private
		 */
		[CommitProperties(target="text")]
		public function measure(event:Event):void
		{
			var metrics:TextLineMetrics = this.getLineMetrics(0);
			measuredLayout.width = metrics.width;
			measuredLayout.height = 12;
		}
		
	}
}
