package games.braid.states {

	import games.braid.SoundPlaybackControl;
	import games.braid.assets.Assets;
	import games.braid.objects.nape.BraidEnemy;
	import games.braid.objects.nape.BraidHero;
	import games.braid.objects.nape.Key;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.input.controllers.Keyboard;
	import com.citrusengine.input.controllers.TimeShifter;
	import com.citrusengine.input.controllers.starling.VirtualButtons;
	import com.citrusengine.input.controllers.starling.VirtualJoystick;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.nape.Platform;
	import com.citrusengine.physics.nape.Nape;
	import com.citrusengine.utils.Mobile;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import com.citrusengine.view.starlingview.StarlingArt;

	import flash.geom.Rectangle;
	
	public class BraidTest extends StarlingState
	{
		public var background:CitrusSprite ;
		public var overlay:CitrusSprite;
		
		public var overlayQuadBlue:Quad;
		public var overlayQuadYellow:Quad;
		
		private var hero:BraidHero ;
		private var timeshifter:TimeShifter;
		
		private var currentAlphaOverlay:Number = 0;
		private var targetAlphaOverlay:Number = 0;
		
		//screen shaking.
		private var _shake:Boolean = false;
		
		//overlay easing.
		private var _easeTimer:uint = 0;
		private var _easeDuration:uint = 40;
		private var _easeFunc:Function;
		
		public function BraidTest()
		{
			super();
			
			_easeFunc = Tween_easeOut;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var nape:Nape = new Nape("nape");
			add(nape);
			
			background = new CitrusSprite("background", { view:Image.fromBitmap(new Assets.bg1()) , parallax:0.2 } );
			background.view.scaleX =background.view.scaleY = 2;
			add(background);
			
			overlay = new CitrusSprite("overlay", {parallax:0, group:1});
			overlayQuadBlue = new Quad(stage.stageWidth*2, stage.stageHeight*2, 0x0000FF);
			overlayQuadYellow = new Quad(stage.stageWidth * 2, stage.stageHeight * 2, 0xFFFF00);
			overlayQuadBlue.blendMode = BlendMode.MULTIPLY;
			overlayQuadYellow.blendMode = BlendMode.ADD;
			add(overlay);
			
			var floor:Platform = new Platform("floor2", { x:400, y:590, width:800, height:30 } );
			floor.view = new Quad(800, 30, 0x000044);
			add(floor);
			
			var floor2:Platform = new Platform("floor", { x:1200, y:700, width:800, height:30 } );
			floor2.view = new Quad(800, 30, 0x000044);
			add(floor2);

			var Tatlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new Assets.braid()), new XML(new Assets.braidXML()));
			var anim:AnimationSequence = new AnimationSequence(Tatlas, ["idle", "jump_prep_straight", "running", "fidget","falling_downward","looking_downward","looking_upward","dying","dying_loop"], "idle", 30, true);
			hero = new BraidHero("hero", { x:40, y:10, width:80, height:130, view: anim } );
			add(hero);
			
			var key:Key = new Key("key", { x: 1280, y: 600, height: 50, width: 50, view: new Image(Tatlas.getTexture("key1")) } );
			key.view.scaleX = key.view.scaleY = 0.8;
			add(key);
			
			var enemyanim:AnimationSequence = new AnimationSequence(Tatlas, ["monster-walking","monster-dying","monster-falling"], "monster-walking", 30, true);
			var enemy:BraidEnemy = new BraidEnemy("enemy", {speed:39, leftBound:350, rightBound:550, x:500, y:500, width:100, height:90, view:enemyanim } );
			enemy.enemyClass = BraidHero;
			add(enemy);
			
			add(new BraidEnemy("enemy", {speed:39, leftBound:800, rightBound:1600, x:1200, y:500, width:100, height:90, view:enemyanim.clone() } ));
			
			timeshifter = new TimeShifter(20);
			timeshifter.onSpeedChanged.add(changeOverlay);
			
			timeshifter.addBufferSet( { object:hero, continuous:["x", "y"], discrete:["dead","inverted", "collideable", "animation", "animationFrame","keySlot"] } );
			timeshifter.addBufferSet( { object:key, continuous:["x", "y"], discrete:["inverted"] } );
			timeshifter.addBufferSet( { object:hero.camTarget, continuous:["x", "y"] } );
			timeshifter.addBufferSet( { object:enemy.body, discrete:["allowRotation", "angularVel","rotation"] } );
			timeshifter.addBufferSet( { object:enemy, continuous:["x", "y"], discrete:["inverted","collideable","animation","animationFrame"] } );
			
			timeshifter.onActivated.add(hero.detachPhysics);
			timeshifter.onActivated.add(enemy.detachPhysics);
			timeshifter.onDeactivated.add(hero.attachPhysics);
			timeshifter.onDeactivated.add(enemy.attachPhysics);
			
			timeshifter.onActivated.add(function():void { _shake = true; });
			timeshifter.onDeactivated.add(function():void { _shake = false; x = 0; y = 0; } );
			timeshifter.onDeactivated.add(function():void { changeOverlay(0); } );
			
			var keyboard:Keyboard = CitrusEngine.getInstance().input.keyboard as Keyboard;
			keyboard.addKeyAction("timeshift", Keyboard.SHIFT, 16);
			
			keyboard.addKeyAction("left", Keyboard.Q,1);
			keyboard.addKeyAction("up", Keyboard.Z,1);
			keyboard.addKeyAction("down", Keyboard.S,1);
			keyboard.addKeyAction("right", Keyboard.D,1);
			keyboard.addKeyAction("jump", Keyboard.H,1);
			
			StarlingArt.setLoopAnimations(["idle", "running","monster-walking","dying_loop"]);
			
			this.scaleX = this.scaleY = 0.5;
			
			view.setupCamera(hero.camTarget, new MathVector(stage.stageWidth / 2  , stage.stageHeight / 2 ),
			new Rectangle(0, 0, 2400, 1200), new MathVector(.25, .25));
			
			if (Mobile.isAndroid()) {
				
				var vj:VirtualJoystick = new VirtualJoystick("joy",{radius:120});
				vj.circularBounds = true;
				
				var vb:VirtualButtons = new VirtualButtons("buttons",{buttonradius:40});
				vb.button1Action = "timeshift";
				vb.button1Channel = 16;
				vb.button2Action = "jump";
			}
			
			var s:SoundPlaybackControl = new SoundPlaybackControl(new Assets.sound1());
			timeshifter.onSpeedChanged.add(function(val:Number):void { s.playbackSpeed = (val != 0)?val:0.01; } );
			timeshifter.onEndOfBuffer.add(function():void { s.playbackSpeed = 0.01; } );
			timeshifter.onDeactivated.add(function():void { s.playbackSpeed = 1; } );
		}
		
		private function shakeState():void
		{
			x = Math.random() * 1 - 1;
			y = Math.random() * 1 - 1;
		}
		
		private function changeOverlay(speed:Number):void
		{
			_easeTimer = 0;
			if (speed < 0)
			{
				overlay.view = overlayQuadYellow;
				targetAlphaOverlay = - speed / 10;
			}
			else if (speed > 0)
			{
				overlay.view = overlayQuadBlue;
				targetAlphaOverlay = speed / 10;
			}
			else if (speed == 0)
				targetAlphaOverlay = 0;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_shake)
				shakeState();
			
			if (hero.y > 1700 && !timeshifter.paused)
				timeshifter.pause();
			
			if (_easeTimer < _easeDuration)
			{
				_easeTimer++;
				currentAlphaOverlay = _easeFunc(_easeTimer, currentAlphaOverlay, targetAlphaOverlay - currentAlphaOverlay, _easeDuration);
			}
			
			overlayQuadBlue.alpha = overlayQuadYellow.alpha = currentAlphaOverlay;
		}
		
		private function Tween_easeOut(t:Number, b:Number, c:Number, d:Number):Number { t /= d; return -c * t*(t-2) + b; }
	
	}

}