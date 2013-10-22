package multiresolutions {

	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.gamepad.controls.StickController;
	import citrus.input.InputAction;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingView;
	import flash.geom.Matrix;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.ScaleMode;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState {
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;
		private var box2D:Box2D;
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
			
			box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			ObjectMakerStarling.FromTiledMap(XML(new _Map()), Assets.assets);

			_hero = getFirstObjectByType(Hero) as Hero;
			_hero.registration = "topLeft";
			_hero.view = new AnimationSequence(Assets.assets, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			_hero.offsetX = -_hero.view.width * 0.5;
			_hero.offsetY = -_hero.view.height * 0.5; 

			view.camera.setUp(_hero, new Point(480 * .5, 320 * .5), new Rectangle(0, 0, 6000, 7000), new Point(.25, .05));
			view.camera.allowZoom = true;
			view.camera.allowRotation = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (Starling.current.viewPort.width > _ce.screenWidth ||  Starling.current.viewPort.height > _ce.screenHeight)
			{
				view.camera.cameraLensWidth = Starling.current.stage.stageWidth;
				view.camera.cameraLensHeight =Starling.current.stage.stageHeight;
				
				view.camera.offset.setTo(view.camera.cameraLensWidth * .5, view.camera.cameraLensHeight * .5);
			}
			else
			{
				view.camera.cameraLensWidth = Starling.current.viewPort.width;
				view.camera.cameraLensHeight = Starling.current.viewPort.height;
				
				view.camera.offset.setTo(480 * .5, 320 * .5); // middle of base dimensions.
			}
			
			var action:InputAction;
			if ((action = _ce.input.isDoing("zoomOut"))!= null)
				view.camera.zoom(1 - 0.05 * action.value)
			if ((action = _ce.input.isDoing("zoomIn"))!= null)
				view.camera.zoom(1 + 0.05 * action.value)
			if ((action = _ce.input.isDoing("rotate-"))!= null)
				view.camera.rotate(0.03 * action.value)
			if ((action = _ce.input.isDoing("rotate+"))!= null)
				view.camera.rotate(-0.03 * action.value)
			
			//fix box2D debug view...
			var m:Matrix = box2D.debugView.transformMatrix;
			m.translate(Starling.current.viewPort.x/Starling.current.contentScaleFactor, Starling.current.viewPort.y/Starling.current.contentScaleFactor);
			m.scale(Starling.current.contentScaleFactor, Starling.current.contentScaleFactor);
			box2D.debugView.transformMatrix = m;
		}

	}
}
