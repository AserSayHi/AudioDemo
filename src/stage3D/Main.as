package stage3D
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import stage3D.themes.MetalWorksMobileTheme;
	
	public class Main extends Sprite
	{
		public function Main()
		{
//			new MetalWorksMobileTheme();
			
//			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
//			initDPI();
//			initTab();
//			initNav();
		}
		
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		private var _originalDPI:int;
		public static var scale:Number;
		private function initDPI():void
		{
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			
			scale = scaledDPI / this._originalDPI;
			scale = .7;
		}
		
		private const RECOG_SCREEN:String = "语音识别";
		private const SYNTH_SCREEN:String = "语音合成";
		private const srceens:Array = [RECOG_SCREEN, SYNTH_SCREEN];
		
		private var nav:ScreenNavigator;
		private function initNav():void
		{
			const w:uint = stage.stageWidth;
			const h:uint = stage.stageHeight - tab.height;
			nav = new ScreenNavigator();
			nav.addScreen(RECOG_SCREEN, new ScreenNavigatorItem( RecogScreen, null, {
				width: w,
				height: h
			} ));
			nav.addScreen(SYNTH_SCREEN, new ScreenNavigatorItem( SynthScreen, null, {
				width: w,
				height: h
			}  ));
			this.addChild(nav);
			nav.showScreen( RECOG_SCREEN );
			nav.y = tab.height;
			nav.width = h
			nav.height = w;
		}
		
		private var tab:TabBar;
		private function initTab():void
		{
			tab = new TabBar();
			tab.dataProvider = new ListCollection([
				{label: RECOG_SCREEN},
				{label:	SYNTH_SCREEN}
			]);
			
			tab.width = stage.stageWidth;
			tab.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			this.addChild( tab );
			tab.validate();
			tab.addEventListener(Event.CHANGE, onChanged);
		}
		
		private function onChanged(e:Event):void
		{
			nav.showScreen( srceens[tab.selectedIndex] );
		}
		
	}
}