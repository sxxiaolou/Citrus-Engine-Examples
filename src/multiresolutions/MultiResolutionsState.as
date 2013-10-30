package multiresolutions {

	import citrus.core.starling.StarlingState;
	import citrus.input.InputAction;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.ui.starling.BasicUIElement;
	import citrus.ui.starling.BasicUILayout;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingCamera;
	import flash.geom.Rectangle;
	import starling.core.Starling;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	import flash.geom.Point;	
	
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
		private var _uiLayout:BasicUILayout;
		
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
			
			_camera = view.camera.setUp(_hero, new Point(stage.stageWidth * .5, stage.stageHeight * .5), null, new Point(.25, .05)) as StarlingCamera;
			_camera.allowZoom = true;
			_camera.allowRotation = true;
			
			_input.keyboard.addKeyAction("rotate+", Keyboard.D);
			_input.keyboard.addKeyAction("rotate-", Keyboard.S);
			_input.keyboard.addKeyAction("zoomIn", Keyboard.C);
			_input.keyboard.addKeyAction("zoomOut", Keyboard.X);
			
			setupUi();
			
			//optional uiLayout and background resizing
			_ce.onStageResize.add(function(width:Number,height:Number):void
			{
				_uiLayout.rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
				q.width = stage.stageWidth;
				q.height = stage.stageHeight;
			});
		}
		
		/**
		 * dynamically position elements on screen like you would for a ui (here we simply place tiles)
		 */
		protected function setupUi():void
		{
			_uiLayout = new BasicUILayout(this,new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			
			var tex:Texture = Assets.assets.getTexture("grass/grass_003");
			
			var el:BasicUIElement;
			
			
			_uiLayout.addElement(new Image(tex), BasicUILayout.TOP_LEFT);
			_uiLayout.addElement(new Image(tex), BasicUILayout.TOP_CENTER);
			_uiLayout.addElement(new Image(tex), BasicUILayout.TOP_RIGHT);
			
			_uiLayout.addElement(new Image(tex), BasicUILayout.MIDDLE_LEFT);
			//_uiLayout.addElement(new Image(tex), BasicUILayout.MIDDLE_CENTER);
			_uiLayout.addElement(new Image(tex), BasicUILayout.MIDDLE_RIGHT);
			
			_uiLayout.addElement(new Image(tex), BasicUILayout.BOTTOM_LEFT);
			el =  _uiLayout.addElement(new Image(tex), BasicUILayout.BOTTOM_CENTER);
			_uiLayout.addElement(new Image(tex), BasicUILayout.BOTTOM_RIGHT);
			
			_uiLayout.alpha = 0.8;
			
			_uiLayout.removeElement(el);
			
			//put stats forward
			_ce.starling.showStats = false;
			_ce.starling.showStats = true;
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
