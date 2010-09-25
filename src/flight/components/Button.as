package flight.components
{
	import flight.behaviors.ButtonBehavior;
	import flight.behaviors.MovieClipSkinBehavior;
	import flight.behaviors.SelectBehavior;
	import flight.data.DataChange;
	import flight.layouts.ILayout;
	import flight.skins.MovieClipSkin;
	
	import reflex.components.ButtonGraphic;
	
	/**
	 * @alpha
	 **/
	public class Button extends Component
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
		
		public function Button()
		{
			skin = new MovieClipSkin(new ButtonGraphic());
			behaviors.button = new ButtonBehavior();
			behaviors.selectable = new SelectBehavior();
			dataBind.bind(this, "skin.movieclip.label.text", this, "label", false, false);
		}
		
	}
}