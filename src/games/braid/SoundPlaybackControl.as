package games.braid 
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;	

	/**
	 * based on MP3Player.as by Kelvin Luck (http://www.kelvinluck.com/2008/11/first-steps-with-flash-10-audio-programming/)
	 * 
	 * Todo: "speed tweening" as in TimeShifter, linear interpolation, dynamic sound extraction, mixing capabilities (for multiple sounds), 
	 * generate brown noise when speed = 0 for a braid-like effect (?) .
	 */
	public class SoundPlaybackControl 
	{

		private var _playbackSpeed:Number = 1;	

		private var _mp3:Sound;
		private var _Samples:ByteArray;
		private var _dynamicSound:Sound;
		private var _phase:Number;
		private var _numSamples:int;
		
		public var volume:Number = 0.7;

		public function SoundPlaybackControl(sound:Sound)
		{
			_mp3 = sound;
			
			var bytes:ByteArray = new ByteArray();
			sound.extract(bytes, int(sound.length * 44.1));
			sound = null;
			play(bytes);
		}
		
		public function stop():void
		{
			if (_dynamicSound) {
				_dynamicSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_dynamicSound = null;
			}
		}

		private function play(bytes:ByteArray):void
		{
			stop();
			_dynamicSound = new Sound();
			_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			
			_Samples = bytes;
			_numSamples = bytes.length / 8;
			
			_phase = 0;
			_dynamicSound.play();
		}

		private function onSampleData( event:SampleDataEvent ):void
		{
			
			var l:Number;
			var r:Number;
			
			var outputLength:int = 0;
			while (outputLength < 2048) { 

				_Samples.position = int(_phase) * 8; // 4 bytes per float and two channels so the actual position in the ByteArray is a factor of 8 bigger than the phase

				l = _Samples.readFloat();
				r = _Samples.readFloat();

				event.data.writeFloat(l* volume);
				event.data.writeFloat(r* volume);
				
				outputLength++;

				_phase += _playbackSpeed;

				if (_phase < 0) {
					_phase += _numSamples;
				} else if (_phase >= _numSamples) {
					_phase -= _numSamples;
				}
			}
		}
		
		public function set playbackSpeed(value:Number):void
		{
			_playbackSpeed = value;
		}
	}
}
