package stage3D
{
	import com.iflytek.define.RATE;
	import com.iflytek.events.MSCErrorEvent;
	import com.iflytek.events.MSCEvent;
	import com.iflytek.events.MSCMicStatusEvent;
	import com.iflytek.events.MSCRecordAudioEvent;
	import com.iflytek.events.MSCResultEvent;
	import com.iflytek.msc.Recognizer;
	
	import flash.events.Event;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	/**
	 * 语音识别demo
	 * @author Administrator
	 * 
	 */	
	public class RecogScreen extends Screen
	{
		public function RecogScreen()
		{
		}
		
		override protected function initialize():void
		{
			initController();
			initLabel();
			initRecog();
		}
		
		private var padding:uint = 60;
		private var tf:TextField;
		private function initLabel():void
		{
			tf = new TextField(stage.stageWidth-padding*2, button.y-padding*2, "","palaceFont", 32*Main.scale, 0xffffff);
			tf.border = true;
			this.addChild( tf );
			tf.x = tf.y = padding;
			tf.touchable = false;
			tf.vAlign = tf.hAlign = "center";
		}
		
		private var button:Button;
		private function initController():void
		{
			button = new Button();
			button.label = "按下说话";
			this.addChild( button );
			button.validate();
			button.addEventListener(TouchEvent.TOUCH, onTouch);
			
			button.pivotX = button.width >> 1;
			button.x = stage.stageWidth >> 1;
			button.y = stage.stageHeight - 150;
		}
		
//		private const params:String = "ssm=1,sub=iat,aue=speex-wb;7,auf=audio/L16;rate=8000,ent=sms8k, rst=plain";			//中文引擎
		private const params:String = "ssm=1,sub=iat,aue=speex-wb;7,auf=audio/L16;rate=16000,ent=sms-en16k, rst=plain";		//英文引擎
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(button);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					button.label = "抬起结束";
					if(!isCompleted)
						return;
					tf.text = "";
					recog.recogStart(RATE.rate16k, null, params);
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					button.label = "按下说话";
					if(!isCompleted)
						recog.recogStop();
				}
			}
		}
		
		private function initRecog():void
		{
			recog = new Recognizer(AudioDemo.CONFIGS);
			//麦克风状态事件
			recog.addEventListener(MSCMicStatusEvent.STATUS, eventListenerHandler);
			//音频到达事件
			recog.addEventListener(MSCRecordAudioEvent.AUDIO_ARRIVED, eventListenerHandler);
			//结果到达
			recog.addEventListener(MSCResultEvent.RESULT_GET, eventListenerHandler);
			//识别结束
			recog.addEventListener(MSCEvent.RECOG_COMPLETED, eventListenerHandler);
			//错误
			recog.addEventListener(MSCErrorEvent.ERROR, eventListenerHandler);
			
		}
		
		protected function eventListenerHandler(e:Event):void
		{
			switch(e.type)
			{
				case MSCMicStatusEvent.STATUS:
					trace( "status:" + e );
					break;
				case MSCRecordAudioEvent.AUDIO_ARRIVED:
					trace("音量：" + (e as MSCRecordAudioEvent).volume);
					break;
				case MSCResultEvent.RESULT_GET:
					var ev:MSCResultEvent = e as MSCResultEvent;
					var txt:String = ev.result.readMultiByte(ev.result.bytesAvailable, "GBK");
					tf.text += txt;
					break;
				case MSCEvent.RECOG_COMPLETED:
					if(!button.visible)
						stop();
					break;
				case MSCErrorEvent.ERROR:
					trace( (e as MSCErrorEvent).message );
					break;
				
			}
		}
		
		private var isCompleted:Boolean = true;
		private function stop():void
		{
			isCompleted = true;
			trace("stopFunc");
			recog.recogStop();
		}
		
		private var recog:Recognizer;
		
		override public function dispose():void
		{
			if(recog)
			{
				recog.recogStop();
				recog.dispose();
			}
			if(button)
			{
				button.removeEventListener(TouchEvent.TOUCH, onTouch);
				button.removeFromParent(true);
			}
			if(tf)
			{
				tf.dispose();
			}
			super.dispose();
		}
	}
}