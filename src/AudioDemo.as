package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x663333")]
	public class AudioDemo extends Sprite
	{
//		public static const CONFIGS:String = "appid=52b2ae69, timeout=2000";
		public static const CONFIGS:String = "appid=52b2ae69";
		
		public function AudioDemo()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var star:Starling = new Starling(Main, stage);
			star.start();
		}
	}
}