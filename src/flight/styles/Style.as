/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.styles
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * @inheritDoc
	 */
	dynamic public class Style extends Proxy implements IStyle
	{
		public function Style()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			_id = value;
		}
		private var _id:String;
		
		/**
		 * @inheritDoc
		 */
		public function get styleName():String { return _styleName; }
		public function set styleName(value:String):void
		{
			_styleName = value;
		}
		private var _styleName:String;
		
		/**
		 * @inheritDoc
		 */
		public function get elementType():String { return _elementType; }
		public function set elementType(value:String):void
		{
			_elementType = value;
		}
		private var _elementType:String;
		
		/**
		 * @inheritDoc
		 */
		public function getStyle(property:String):*
		{
			return data[property];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setStyle(property:String, value:*):void
		{
			data[property] = value;
		}
		
		// TODO: ...
		// implicit styles, implicit data, explicit data
		// namespace-specific mapped data retrieval
		// may also delay dataChange notifications based on invalidation
		private var data:Object = {};
		
		override flash_proxy function getProperty(name:*):*
		{
			return data[name.localName];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			data[name.localName] = value;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return false;
		}
		
		override flash_proxy function callProperty(name:*, ...parameters):*
		{
		}
		
		
		// ====== iterate ====== //
		
		override flash_proxy function nextName(index:int):String
		{
			return null;
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return 0;
		}
		
		override flash_proxy function nextValue(index:int):*
		{
		}
	}
}
