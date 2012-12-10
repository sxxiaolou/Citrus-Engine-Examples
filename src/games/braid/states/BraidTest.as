package games.braid.states
{
	import com.citrusengine.input.controllers.starling.VirtualButtons;
	import com.citrusengine.input.controllers.starling.VirtualJoystick;
	import games.braid.assets.Assets;
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.input.controllers.Keyboard;
	import com.citrusengine.input.controllers.TimeShifter;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.nape.Coin;
	import com.citrusengine.objects.platformer.nape.Platform;
	import com.citrusengine.physics.nape.Nape;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import com.citrusengine.view.starlingview.StarlingArt;
	import flash.geom.Rectangle;
	import games.braid.objects.nape.BraidEnemy;
	import games.braid.objects.nape.BraidHero;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	
	public class BraidTest extends StarlingState
	{
		public var background:CitrusSprite ;
		public var overlay:CitrusSprite;
		
		public var overlayQuadBlue:Quad;
		public var overlayQuadYellow:Quad;
		
		private var hero:BraidHero ;
		
		private var timeshifter:TimeShifter;
		
		private var speedDir:int = 0;
		private var changedDir:Boolean = true;
		private var alphaOverlay:Number = 0.2;
		
		public function BraidTest()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var nape:Nape = new Nape("nape");
			add(nape);
			
			background = new CitrusSprite("background", { view:Image.fromBitmap(new Assets.bg1()) , parallax:0.2 } );
			background.view.scaleX = 2;
			background.view.scaleY = 2;
			add(background);
			
			overlay = new CitrusSprite("overlay", {parallax:0});
			overlayQuadBlue = new Quad(stage.stageWidth*2, stage.stageHeight*2, 0x0000FF);
			overlayQuadBlue.alpha = 0.3;
			overlayQuadBlue.blendMode = BlendMode.MULTIPLY;
			overlayQuadYellow = new Quad(stage.stageWidth*2, stage.stageHeight*2, 0xFFFF00);
			overlayQuadYellow.alpha = 0.1;
			overlayQuadYellow.blendMode = BlendMode.ADD;
			
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
			
			var anim2:AnimationSequence = new AnimationSequence(Tatlas, ["idle", "jump_prep_straight", "running", "fidget", "falling_downward", "looking_downward", "looking_upward","dying","dying_loop"], "idle", 30, true);
			//hero 2 is immune to timeShift.
			var hero2:BraidHero = new BraidHero("hero2", { x:1200, y:600, width:80, height:130, inverted:true, view: anim2 } );
			hero2.inputChannel = 1;
			add(hero2);
			
			var coin:Coin = new Coin("key", { x: 1280, y: 600, height: 50, width: 50, view: new Image(Tatlas.getTexture("key1")) } );
			coin.view.scaleX = coin.view.scaleY = 0.8;
			coin.collectorClass = BraidHero;
			add(coin);
			
			var enemyanim:AnimationSequence = new AnimationSequence(Tatlas, ["monster-walking","monster-dyingMonster","monster-falling"], "monster-walking", 30, true);
			var enemy:BraidEnemy = new BraidEnemy("enemy", { leftBound:350, rightBound:550, x:500, y:500, width:100, height:90, view:enemyanim } );
			enemy.enemyClass = BraidHero;
			add(enemy);
			
			timeshifter = new TimeShifter(20);
			timeshifter.onSpeedChanged.add(changeOverlay);
			
			timeshifter.addBufferSet( { object:hero, continuous:["x", "y"], discrete:["dead","inverted", "collideable", "animation", "animationFrame"] } );
			timeshifter.addBufferSet( { object:hero.camTarget, continuous:["x", "y"] } );
			timeshifter.addBufferSet( { object:enemy.body, discrete:["allowRotation", "angularVel","rotation"] } );
			timeshifter.addBufferSet( { object:enemy, continuous:["x", "y"], discrete:["inverted","collideable","animation","animationFrame"] } );
			
			timeshifter.onActivated.add(hero.detachPhysics);
			timeshifter.onActivated.add(enemy.detachPhysics);
			timeshifter.onDeactivated.add(hero.attachPhysics);
			timeshifter.onDeactivated.add(enemy.attachPhysics);
			
			var keyboard:Keyboard = CitrusEngine.getInstance().input.keyboard as Keyboard;
			keyboard.addKeyAction("timeshift", Keyboard.SHIFT, 16);
			
			keyboard.addKeyAction("left", Keyboard.Q,1);
			keyboard.addKeyAction("up", Keyboard.Z,1);
			keyboard.addKeyAction("down", Keyboard.S,1);
			keyboard.addKeyAction("right", Keyboard.D,1);
			keyboard.addKeyAction("jump", Keyboard.H,1);
			
			StarlingArt.setLoopAnimations(["idle", "running","monster-walking","dying_loop"]);
			
			this.scaleX = 0.5;
			this.scaleY = 0.5;
			
			view.setupCamera(hero.camTarget, new MathVector(stage.stageWidth / 2  , stage.stageHeight / 2 ),
			new Rectangle(0, 0, 2400, 1200), new MathVector(.25, .25));
			
			add(overlay);
			
			var vj:VirtualJoystick = new VirtualJoystick("joy",{radius:120});
			vj.circularBounds = true;
			
			var vb:VirtualButtons = new VirtualButtons("buttons",{buttonradius:40});
			vb.button1Action = "timeshift";
			vb.button1Channel = 16;
			vb.button2Action = "jump";
		}
		
		private function changeOverlay(speed:Number):void
		{
			if (speed < 0)
			{
				overlay.view = overlayQuadYellow;
				alphaOverlay = - speed / 10;
			}
			else if (speed > 0)
			{
				overlay.view = overlayQuadBlue;
				alphaOverlay = speed / 20;
			}
			
			changedDir = true;
			
			if(speed < 0 && timeshifter.speed < 0)
				changedDir = false;
			else if (speed > 0 && timeshifter.speed > 0)
				changedDir = false;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (hero.y > 1400 && !timeshifter.paused)
			{
				timeshifter.pause();
			}
				
				if (timeshifter.targetSpeed == 0 && changedDir)
				{
					overlayQuadBlue.alpha = (1 - timeshifter.easeFactor) * alphaOverlay; 
					overlayQuadYellow.alpha = (1 - timeshifter.easeFactor) * alphaOverlay;
				}
				else if (changedDir)
				{
					overlayQuadBlue.alpha = timeshifter.easeFactor * alphaOverlay; 
					overlayQuadYellow.alpha = timeshifter.easeFactor * alphaOverlay;
				}
				
				if (!changedDir)
				{
					overlayQuadBlue.alpha = overlayQuadBlue.alpha + timeshifter.easeFactor * (alphaOverlay - overlayQuadBlue.alpha);
					overlayQuadYellow.alpha = overlayQuadYellow.alpha + timeshifter.easeFactor * (alphaOverlay - overlayQuadYellow.alpha);
				}
			
			if (!CitrusEngine.getInstance().input.isDoing("timeshift", 16))
			{
				overlay.view = null;
			}
			
		}
	
	}

}