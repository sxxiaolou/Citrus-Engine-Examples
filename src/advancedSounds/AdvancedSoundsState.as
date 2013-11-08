package advancedSounds
{
	import advancedSounds.CitrusSoundSprite;
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSpritePool;
	import citrus.sounds.CitrusSoundEvent;
	import citrus.sounds.CitrusSoundInstance;
	import citrus.sounds.CitrusSoundSpace;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Point;
	import starling.text.TextField;
	
	public class AdvancedSoundsState extends StarlingState
	{
		public var camera:StarlingCamera;
		public var camTarget:Point = new Point();
		public var textDisplay:TextField;
		
		public var soundSpace:CitrusSoundSpace;
		public var soundSpritePool:CitrusSpritePool;
		
		protected var _playing:uint = 0;
		
		public function AdvancedSoundsState()
		{
		
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			textDisplay = new TextField(stage.stageWidth, 100, "", "Verdana", 28);
			addChild(textDisplay);
			
			soundSpace = new CitrusSoundSpace("sound space");
			soundSpace.visible = false;
			add(soundSpace);
			
			soundSpritePool = new CitrusSpritePool(CitrusSoundSprite, {});
			addPoolObject(soundSpritePool);
			
			var i:int = 0;
			var pos:MathVector = new MathVector();
			var screenCenter:MathVector = new MathVector(stage.stageWidth * .5, stage.stageHeight * .5);
			var soundSprite:CitrusSoundSprite;
			for (i; i < 150; i++)
			{
				pos.setTo(50 * Math.random() + 150, 0);
				pos.angle = Math.random() * Math.PI * 2;
				
				soundSprite = soundSpritePool.get({x: pos.x, y: pos.y, view: "muffin.png"}).data as CitrusSoundSprite;
			}
			
			soundSprite = new CitrusSoundSprite("looper", {x: 0, y: 0, loop: "loop", view: "muffin.png"});
			add(soundSprite);
			
			_ce.sound.addEventListener(CitrusSoundEvent.FORCE_STOP, function():void  {rejected++;});
			_ce.sound.addEventListener(CitrusSoundEvent.SOUND_LOOP, function():void {looped++;});
			_ce.sound.addEventListener(CitrusSoundEvent.SOUND_END, function():void
				{
					_playing--;
					totalplayed++;
				});
			
			camera = view.camera.setUp(camTarget, new Point(stage.stageWidth * .5, stage.stageHeight * 0.5)) as StarlingCamera;
			camera.allowRotation = true;
			camera.allowZoom = true;
			camera.easing.setTo(1, 1);
			camera.rotationEasing = 1;
			camera.zoomEasing = 1;
			
			camera.zoomFit(400, 400, true);
			camera.reset();
		
		}
		
		private var timer:int = 0;
		private var rejected:int = 0;
		private var looped:int = 0;
		private var totalplayed:int = 0;
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			timer++;
			
			if (_input.justDid("jump"))
				_ce.state = new AdvancedSoundsState();
			
			camera.rotate(0.02);
			camera.offset.setTo(Math.cos(timer / 50) * .5 * stage.stageWidth + stage.stageWidth * .5, stage.stageHeight * .5);
			camera.setZoom(Math.cos(timer / 10) * 0.05 + 0.95);
			
			textDisplay.text = "active/rejected/looped/total played\n" + CitrusSoundInstance.activeSoundInstances.length.toString() + " / " + rejected + " / " + looped + " / " + totalplayed;
		}
		
		override public function destroy():void
		{
			_ce.sound.stopAllPlayingSounds();
			_ce.sound.removeAllEventListeners();
			removeChild(textDisplay);
			camera = null;
			camTarget = null;
			super.destroy();
		}
	
	}

}