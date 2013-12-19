package
{
	import com.iflytek.msc.Synthesizer;
	
	import feathers.controls.Screen;
	
	import starling.events.Event;

	/**
	 * 语音合成demo
	 * @author Administrator
	 */	
	public class SynthScreen extends Screen
	{
		public function SynthScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			initialize();
		}
		
		private function initialize():void
		{
			initController();
			initSynth();
		}
		
		private var synth:Synthesizer;
		private function initSynth():void
		{
			
		}
		
		private function initController():void
		{
		}
	}
}