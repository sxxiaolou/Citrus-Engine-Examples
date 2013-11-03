package advancedSounds
{
	import citrus.math.MathUtils;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.sounds.CitrusSound;
	import citrus.sounds.CitrusSoundEvent;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.sounds.CitrusSoundInstance;
	import citrus.view.ICitrusArt;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	
	public class CitrusSoundSprite extends CitrusSprite
	{
		public var loop:String;
		
		public var soundInstances:Vector.<CitrusSoundInstance> = new Vector.<CitrusSoundInstance>();
		
		public static var panAdjust:Function = MathUtils.easeInCubic;
		public static var volAdjust:Function = MathUtils.easeOutQuad;
		
		public var _camVec:MathVector = new MathVector();
		public var _radius:Number = 600;
		
		protected var _image:Image;
		
		public function CitrusSoundSprite(name:String, params:Object = null)
		{
			updateCallEnabled = true;
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
		}
		
		override public function handleArtReady(citrusArt:ICitrusArt):void
		{
			var imgArt:StarlingArt = citrusArt as StarlingArt;
			imgArt.scaleX = imgArt.scaleY = 0.5;
			_image = imgArt.content as Image;
			_image.alignPivot();
			_image.alpha = 0.2;
			
			var citrusSound:CitrusSound;
			if (loop)
			{
				citrusSound = _ce.sound.getSound(loop);
				if (!citrusSound.isPlaying)
				{
					var soundInstance:CitrusSoundInstance = citrusSound.createInstance(false,true);
					if (soundInstance)
					{
						soundInstance.addEventListener(CitrusSoundEvent.SOUND_START, onSoundStart);
						soundInstance.addEventListener(CitrusSoundEvent.SOUND_END, onSoundEnd);
						soundInstance.play();
					}
				}
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var citrusSound:CitrusSound;
			
			if (!loop && Math.random() < 0.0036)
			{
				citrusSound = _ce.sound.getGroup(CitrusSoundGroup.SFX).getRandomSound();
				if (citrusSound)
				{
					var soundInstance:CitrusSoundInstance = citrusSound.createInstance(false, true);
					if (soundInstance)
					{
						soundInstance.addEventListener(CitrusSoundEvent.SOUND_START, onSoundStart);
						soundInstance.addEventListener(CitrusSoundEvent.SOUND_END, onSoundEnd);
						soundInstance.play();
					}
				}
			}
			
			updateSounds();
		}
		
		protected function updateSounds():void
		{
			if (_ce.state.view.camera)
			{
				var camera:StarlingCamera =  _ce.state.view.camera as StarlingCamera;
				var camRect:Rectangle = camera.getRect();
				var camCenter:Point = new Point(camRect.x + camRect.width*0.5,camRect.y + camRect.height*0.5);
				_camVec.x = this.x - camCenter.x ;
				_camVec.y = this.y - camCenter.y ;
				_camVec.angle += camera.getRotation();
			}
			
			var distance:Number = _camVec.length;
			
			var soundInstance:CitrusSoundInstance;
			
			var peaks:Number = 0;
			
			for each (soundInstance in soundInstances)
			{
				if (!soundInstance.isPlaying)
					return;
					
				var volume:Number = distance > _radius ? 0 : 1 - distance / _radius;
				soundInstance.volume = adjustVolume(volume);
				
				var panning:Number = (Math.cos(_camVec.angle) * distance) / 
				( (camera.cameraLensWidth /camera.camProxy.scale) * 0.5 );
				soundInstance.panning = adjustPanning(panning);
				
				peaks += soundInstance.rightPeak + soundInstance.leftPeak;
			}
			
			if (_image)
			{
				_image.scaleX = _image.scaleY = 1 + peaks*4;
				_image.rotation = -camera.camProxy.rotation;
			}
		}
	
		
		public function adjustPanning(value:Number):Number
		{
			if (value <= -1)
				return -1;
			else if (value >= 1)
				return 1;
			
			if (value < 0)
				return -panAdjust(-value, 0, 1, 1);
			else if (value > 0)
				return panAdjust(value, 0, 1, 1);
			return value;
		}
		
		public function adjustVolume(value:Number):Number
		{
			if (value <= 0)
				return 0;
			else if (value >= 1)
				return 1;
				
			return volAdjust(value, 0, 1, 1);
		}
		
		protected function onSoundStart(e:CitrusSoundEvent):void
		{
			soundInstances.push(e.soundInstance);
			if(_image)
			_image.alpha = 1;
		}
		
		protected function onSoundEnd(e:CitrusSoundEvent):void
		{
			e.soundInstance.removeEventListener(CitrusSoundEvent.SOUND_START, onSoundStart);
			e.soundInstance.removeEventListener(CitrusSoundEvent.SOUND_END, onSoundEnd);
			e.soundInstance.removeSelfFromVector(soundInstances);
			if(_image)
				_image.alpha = 0.1;
			trace(this,soundInstances.length);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}