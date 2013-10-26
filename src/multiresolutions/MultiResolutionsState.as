package multiresolutions {

	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.input.InputAction;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import starling.display.Sprite;

	import starling.core.Starling;
	import starling.display.Quad;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState {
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;
		private var box2D:Box2D;
		
		//base represents the base dimensions of the game defined in Main.
		private var baseSprite:CitrusSprite;
		
		private var _hero:Hero;

		public function MultiResolutionsState() {
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform, Sensor, Coin];
		}

		override public function initialize():void {
			super.initialize();
			
			var q:Quad = parent.addChild(new Quad(10000, 10000, 0x86f8ff)) as Quad;
			parent.swapChildren(this, q);
			
			var baseQuad:Quad = new Quad(480, 320, 0xFF0000);
			baseQuad.setVertexColor(1, 0x00FF00);
			baseQuad.setVertexColor(2, 0x0000FF);
			baseQuad.setVertexColor(3, 0xFF00FF);
			baseQuad.pivotX = baseQuad.width * .5;
			baseQuad.pivotY = baseQuad.height * .5;
			
			baseSprite = new CitrusSprite("base", { view:baseQuad, parallaxX:0, parallaxY:0} );
			add(baseSprite);
			
			box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			ObjectMakerStarling.FromTiledMap(XML(new _Map()), Assets.assets);

			_hero = getFirstObjectByType(Hero) as Hero;
			_hero.registration = "topLeft";
			_hero.view = new AnimationSequence(Assets.assets, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			_hero.offsetX = -_hero.view.width * 0.5;
			_hero.offsetY = -_hero.view.height * 0.5; 

			view.camera.setUp(_hero, new Point(Starling.current.stage.stageWidth * .5, Starling.current.stage.stageHeight * .5), new Rectangle(0, 0, 6000, 7000), new Point(.25, .05));
			view.camera.allowZoom = true;
			view.camera.allowRotation = true;
			
			_ce.input.keyboard.addKeyAction("rotate+", Keyboard.D);
			_ce.input.keyboard.addKeyAction("rotate-", Keyboard.S);
			_ce.input.keyboard.addKeyAction("zoomIn", Keyboard.C);
			_ce.input.keyboard.addKeyAction("zoomOut", Keyboard.X);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			view.camera.cameraLensWidth = Starling.current.viewPort.width;
			view.camera.cameraLensHeight = Starling.current.viewPort.height;
			view.camera.offset.setTo(Starling.current.stage.stageWidth * .5, Starling.current.stage.stageHeight * .5);
			
			var action:InputAction;
			if ((action = _ce.input.isDoing("zoomOut"))!= null)
				view.camera.zoom(1 - 0.05 * action.value);
			if ((action = _ce.input.isDoing("zoomIn"))!= null)
				view.camera.zoom(1 + 0.05 * action.value);
			if ((action = _ce.input.isDoing("rotate-"))!= null)
				view.camera.rotate(0.03 * action.value);
			if ((action = _ce.input.isDoing("rotate+"))!= null)
				view.camera.rotate(-0.03 * action.value);
			
			
			baseSprite.x = view.camera.offset.x;
			baseSprite.y = view.camera.offset.y;
		}

	}
}
