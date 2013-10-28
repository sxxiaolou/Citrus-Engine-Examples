package multiresolutions
{
	
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.input.InputAction;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState
	{
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx",mimeType="application/octet-stream")]
		private const _Map:Class;
		private var box2D:Box2D;
		private var _camera:StarlingCamera;
		private var _hero:Hero;
		
		public function MultiResolutionsState()
		{
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform, Sensor, Coin];
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//background quad
			var q:Quad = parent.addChild(new Quad(_ce.baseWidth, _ce.baseHeight, 0x86f8ff)) as Quad;
			parent.swapChildren(this, q);
			
			box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);
			
			ObjectMakerStarling.FromTiledMap(XML(new _Map()), Assets.assets);
			
			_hero = getFirstObjectByType(Hero) as Hero;
			_hero.view = new AnimationSequence(Assets.assets, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			
			_camera = view.camera.setUp(_hero, new Point(_stage.stageWidth * .5, _stage.stageHeight * .5), null, new Point(.25, .05)) as StarlingCamera;
			_camera.allowZoom = true;
			_camera.allowRotation = true;
			
			_ce.input.keyboard.addKeyAction("rotate+", Keyboard.D);
			_ce.input.keyboard.addKeyAction("rotate-", Keyboard.S);
			_ce.input.keyboard.addKeyAction("zoomIn", Keyboard.C);
			_ce.input.keyboard.addKeyAction("zoomOut", Keyboard.X);
			
			setupUi();
		
		}
		
		/**
		 * dynamically position elements on screen like you would for a ui (here we simply place tiles)
		 */
		protected function setupUi():void
		{
			var tex:Texture = Assets.assets.getTexture("grass/grass_003");
			var stageWidth:int = _stage.stageWidth;
			var stageHeight:int = _stage.stageHeight;
			
			var uiTopLeft:Image = new Image(tex);
			
			var uiTop:Image = new Image(tex);
			uiTop.alignPivot(HAlign.CENTER, VAlign.TOP);
			uiTop.x = stageWidth * .5;
			
			var uiTopRight:Image = new Image(tex);
			uiTopRight.alignPivot(HAlign.RIGHT, VAlign.TOP);
			uiTopRight.x = stageWidth;
			
			var uiMiddleLeft:Image = new Image(tex);
			uiMiddleLeft.alignPivot(HAlign.LEFT, VAlign.CENTER);
			uiMiddleLeft.y = stageHeight * .5;
			
			var uiMiddleRight:Image = new Image(tex);
			uiMiddleRight.alignPivot(HAlign.RIGHT, VAlign.CENTER);
			uiMiddleRight.x = stageWidth;
			uiMiddleRight.y = stageHeight * .5;
			
			var uiBottomLeft:Image = new Image(tex);
			uiBottomLeft.alignPivot(HAlign.LEFT, VAlign.BOTTOM);
			uiBottomLeft.y = stageHeight;
			
			var uiBottomRight:Image = new Image(tex);
			uiBottomRight.alignPivot(HAlign.RIGHT, VAlign.BOTTOM);
			uiBottomRight.x = stageWidth;
			uiBottomRight.y = stageHeight;
			
			var uiBottom:Image = new Image(tex);
			uiBottom.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			uiBottom.x = stageWidth * .5;
			uiBottom.y = stageHeight;
			
			addChild(uiTopLeft);
			addChild(uiTop);
			addChild(uiTopRight);
			addChild(uiMiddleLeft);
			addChild(uiMiddleRight);
			addChild(uiBottomLeft);
			addChild(uiBottom);
			addChild(uiBottomRight);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var action:InputAction;
			if ((action = _input.isDoing("zoomOut")) != null)
				_camera.zoom(1 - 0.05 * action.value);
			if ((action = _input.isDoing("zoomIn")) != null)
				_camera.zoom(1 + 0.05 * action.value);
			if ((action = _input.isDoing("rotate-")) != null)
				_camera.rotate(0.03 * action.value);
			if ((action = _input.isDoing("rotate+")) != null)
				_camera.rotate(-0.03 * action.value);
			
			if (_camera.getZoom() < 1)
				_camera.setZoom(1);
		}
	
	}
}
