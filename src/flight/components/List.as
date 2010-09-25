package flight.components
{
	
	import flight.collections.SimpleCollection;
	import flight.containers.Group;
	import flight.data.DataChange;
	import flight.data.IRange;
	import flight.layouts.ILayout;
	import flight.layouts.VerticalLayout;
	
	import mx.collections.IList;
	
	/**
	 * @alpha
	 */
	public class List extends Component
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
		
		public function List()
		{
			layout = new VerticalLayout();
			template = Button;
			skin = new Group();
			dataBind.bind(this, "skin.content", this, "dataProvider");
			dataBind.bind(this, "skin.template", this, "template");
			dataBind.bind(this, "skin.layout", this, "layout");
			dataBind.bind(this, "skin.width", this, "width");
			dataBind.bind(this, "skin.height", this, "height");
		}
		
	}
}