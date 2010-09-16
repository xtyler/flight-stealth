package flight.components
{
	import flight.data.DataChange;
	
	/**
	 * @alpha
	 **/
	public class ButtonBase extends Component
	{
		
		private var _label:String;
		private var _selected:Boolean;
		
		[Bindable(event="labelChange")]
		[Inspectable(name="Label", type=String, defaultValue="Label")]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			DataChange.change(this, "label", _label, _label = value);
		}
		
		[Bindable(event="selectedChange")]
		[Inspectable(name="Selected", type=Boolean, defaultValue=false)]
		public function get selected():Boolean {return _selected; }
		public function set selected(value:Boolean):void {
			DataChange.change(this, "selected", _selected, _selected = value);
		}
		
		public function ButtonBase()
		{
			super();
			//skin = this;
			dataBind.bind(this, "skin.label.text", this, "label", false, false);
		}
		
	}
}