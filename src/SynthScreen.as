package
{
	import com.iflytek.events.MSCErrorEvent;
	import com.iflytek.events.MSCEvent;
	import com.iflytek.events.MSCSynthAudioEvent;
	import com.iflytek.msc.Synthesizer;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	
	import starling.events.Event;
	
	/**
	 * 语音合成demo
	 * @author Administrator
	 */	
	public class SynthScreen extends Screen
	{
		public function SynthScreen()
		{
		}
		
		override protected function initialize():void
		{
			initButtons();
			initEdit();
			initSynth();
			this.addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			if(state == 1)
				return;
			var string:String = textInput.text;
			if(string)
			{
				btnSynth.label = "合成音频";
				btnSynth.isEnabled = true;
			}else
			{
				btnSynth.label = "文本为空";
				btnSynth.isEnabled = false;
			}
		}
		
		private var padding:uint = 60;
		private var textInput:TextInput;
		private function initEdit():void
		{
			textInput = new TextInput();
			textInput.textEditorFactory = function stepperTextEditorFactory():TextFieldTextEditor{
				return new TextFieldTextEditor();
			};
			textInput.textEditorProperties.textFormat = new TextFormat("palaceFont", 32 * Main.scale, 0xfeffcf, null, null, null, null, null, TextFormatAlign.CENTER);
			textInput.textEditorProperties.embedFonts = true;
			textInput.textEditorProperties.multiline=true;
			textInput.textEditorProperties.wordWrap=true;
			textInput.textEditorProperties.autoSize = "center";
			textInput.maxChars = 30;
			textInput.width = stage.stageWidth-padding*2;
			textInput.height = btnSynth.y-padding*2;
			this.addChild( textInput );
			textInput.x = textInput.y = padding;
		}
		
		private var btnSynth:Button;
		private var btnPlay:Button;
		private function initButtons():void
		{
			btnSynth = new Button();
			btnSynth.label = "输入文本";
			this.addChild( btnSynth );
			btnSynth.validate();
			btnSynth.addEventListener(starling.events.Event.TRIGGERED, onTriggered);
			
			btnSynth.pivotX = btnSynth.width >> 1;
			btnSynth.x = stage.stageWidth >> 1;
			btnSynth.y = stage.stageHeight - 180;
			
			btnPlay = new Button();
			btnPlay.label = "等待音频";
			btnPlay.isEnabled = false;
			this.addChild( btnPlay );
			btnPlay.validate();
			btnPlay.addEventListener(starling.events.Event.TRIGGERED, onTriggered);
			
			btnPlay.pivotX = btnPlay.width >> 1;
			btnPlay.x = stage.stageWidth >> 1;
			btnPlay.y = stage.stageHeight - 130;
		}
		
		private var state:uint = 0;
		private function onTriggered(e:starling.events.Event):void
		{
			switch(e.target)
			{
				case btnSynth:		//开始合成
					btnSynth.isEnabled = false;
					btnSynth.label = "合成中...."
					state = 1;
					btnPlay.isEnabled = false;
					btnPlay.label = "等待音频";
					synth.Stop();
					synth.synthStop();
					synth.synthStart(textInput.text, params);
					break;
				case btnPlay:		//播放声音
					btnPlay.label = "播放中....";
					btnPlay.isEnabled = false;
					try
					{
						synth.Play();
					} 
					catch(error:Error) 
					{
						trace(error.errorID, error.message);
						btnPlay.isEnabled = false;
						btnPlay.label = "播放出错";
					}
					break;
			}
		}
		private var synth:Synthesizer;
		private var params:String = "ssm=1,vol=default,ttp=text,bgs=0,auf=audio/L16;rate=8000,ent=intp65,vcn=xiaoyan,spd=0";
		private function initSynth():void
		{
			synth = new Synthesizer(AudioDemo.CONFIGS);
			synth.addEventListener(MSCErrorEvent.ERROR, synthListener);
			synth.addEventListener(MSCEvent.SYNTH_COMPLETED, synthListener);
			synth.addEventListener(MSCSynthAudioEvent.AUDIO_GET, synthListener);
			synth.addEventListener(MSCEvent.SYNTH_READY_TO_PLAY, synthListener);
			synth.addEventListener(MSCEvent.SYNTH_PLAY_COMPLETED, synthListener); 
		}
		
		private var sound:Sound;
		protected function synthListener(e:flash.events.Event):void
		{
			switch(e.type)
			{
				case MSCEvent.SYNTH_COMPLETED:
					trace("synth_complete");
					btnSynth.isEnabled = true;
					btnSynth.label = "合成音频";
					break;
				case MSCSynthAudioEvent.AUDIO_GET:
					trace("get audio data");
					break;
				case MSCEvent.SYNTH_READY_TO_PLAY:
					btnPlay.isEnabled = true;
					btnPlay.label = "播放音频";
					state = 0;
					break;
				case MSCEvent.SYNTH_PLAY_COMPLETED:
					trace("synth_play_completed");
					btnPlay.isEnabled = true;
					btnPlay.label = "播放音频";
					break;
				case MSCErrorEvent.ERROR:
					trace((e as MSCErrorEvent).message);
					break;
			}
		}
		
		override public function dispose():void
		{
			if(synth)
			{
				synth.Stop();
				synth.synthStop();
				synth.dispose();
			}
			if(btnPlay)
			{
				btnPlay.removeEventListener(starling.events.Event.TRIGGERED, onTriggered);
				btnPlay.removeFromParent(true);
			}
			if(btnSynth)
			{
				btnSynth.removeEventListener(starling.events.Event.TRIGGERED, onTriggered);
				btnSynth.removeFromParent(true);
			}
			super.dispose();
		}
	}
}