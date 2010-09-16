package flight.components
{
	
	import flight.data.DataChange;
	import flight.data.IRange;
	import flight.layouts.ILayout;
	import flight.layouts.VerticalLayout;
	
	import mx.collections.IList;
	
	/**
	 * @alpha
	 */
	public class ListBase extends Component
	{
		
		private var _layout:ILayout;
		private var _dataProvider:IList;
		private var _template:Object;
		private var _position:IRange;
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			DataChange.change(this, "layout", _layout, _layout = value);
		}
		
		[Bindable(event="dataProviderChange")]
		public function get dataProvider():IList { return _dataProvider; }
		public function set dataProvider(value:IList):void {
			DataChange.change(this, "dataProvider", _dataProvider, _dataProvider = value);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			DataChange.change(this, "template", _template, _template = value);
		}
		
		[Bindable(event="positionChange")]
		public function get position():IRange { return _position; }
		public function set position(value:IRange):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function ListBase()
		{
			if (layout == null) {
				layout = new VerticalLayout();
			}
			if (template == null) {
				template = ButtonBase;
			}
		}
		
	}
}