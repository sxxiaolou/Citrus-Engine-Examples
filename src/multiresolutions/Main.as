package multiresolutions {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.controllers.gamepad.Gamepad;
	import citrus.input.controllers.gamepad.GamePadManager;
	import citrus.input.controllers.gamepad.maps.GamePadMap;
	import starling.core.Starling;

	import multiresolutions.Assets;
	import multiresolutions.MultiResolutionsState;
	import multiresolutions.Utils;

	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Rectangle;

	//[SWF(backgroundColor="#000000", frameRate="60", width="500", height="400")] // 1
	//[SWF(backgroundColor="#000000", frameRate="60", width="960", height="640")] // 2
	//[SWF(backgroundColor="#000000", frameRate="60", width="1000", height="640")] // 2
	//[SWF(backgroundColor="#000000", frameRate="60", width="1200", height="600")] // 1.5
	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")] //2
	//[SWF(backgroundColor="#000000", frameRate="60", width="1536", height="1536")] // 4
	//[SWF(backgroundColor="#000000", frameRate="60", width="1537", height="1537")] // 5
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		//imagine those as being properties of StarlingCitrusEngine :)
		public static var baseWidth:Number = 480;
		public static var baseHeight:Number = 320;
		
		private var _scaleFactor:Number;
		
		public static var viewportMode:String = ViewportMode.FULLSCREEN;
		
		/**
		 * keeping a ref to viewport rectangle
		 */
		public static var viewport:Rectangle;
		
		public function Main() {
			
			new GamePadManager().onControllerAdded.addOnce(function(gamepad:Gamepad):void
			{
				gamepad.setStickActions(GamePadMap.STICK_LEFT, "up", "right", "duck", "left");
				gamepad.setStickActions(GamePadMap.STICK_RIGHT, "zoomIn", "rotate-", "zoomOut", "rotate+");
				gamepad.setButtonAction(GamePadMap.DPAD_DOWN, "duck");
				gamepad.setButtonAction(GamePadMap.BUTTON_BOTTOM, "jump");
			});
			
			//we have designed our game for an iPhone 3GS, so the baseWidth & baseHeight are 480 & 320.
		}
		
		override protected function handleStageResize(e:flash.events.Event = null):void
		{
			
			//-- code from CitrusEngine.handleStageResize
			
			if (_fullScreen)
			{
				_screenWidth = stage.fullScreenWidth;
				_screenHeight = stage.fullScreenHeight;
			}
			else
			{
				_screenWidth = stage.stageWidth;
				_screenHeight = stage.stageHeight;
			}
			
			onStageResize.dispatch(_screenWidth, _screenHeight);
			
			//------
			
			if (!_starling)
				return;
			
			scaleFactor =  Utils.FindScaleFactor(screenWidth, screenHeight);
			
			resetViewport();
			_starling.viewPort.copyFrom(viewport);
		}
			
		override protected function handleAddedToStage(e:flash.events.Event):void {
			super.handleAddedToStage(e);
			
			setUpStarling(true, 1, resetViewport());
		}
		
		protected function resetViewport():Rectangle
		{
			if (viewport == null)
					viewport = new Rectangle(0, 0, _screenWidth, _screenHeight);
					
			var baseRect:Rectangle = new Rectangle(0, 0, baseWidth, baseHeight);
			var screenRect:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			
			trace("VIEWPORT MODE:", viewportMode);
			
			switch(viewportMode)
			{
				case ViewportMode.LETTERBOX:
					viewport = RectangleUtil.fit(baseRect, screenRect, ScaleMode.SHOW_ALL);
					viewport.x = screenWidth * .5 - viewport.width * .5;
					viewport.y = screenHeight * .5 - viewport.height * .5;
					
					if (_starling)
					{
						_starling.stage.stageWidth = baseWidth;
						_starling.stage.stageHeight = baseHeight;
					}
					
					break;
				case ViewportMode.FULLSCREEN:
					viewport = RectangleUtil.fit(baseRect, screenRect, ScaleMode.SHOW_ALL);
					var ratioW:Number = viewport.width / baseRect.width;
					var ratioH:Number = viewport.height / baseRect.height;
					viewport.copyFrom(screenRect);
					
					viewport.x = 0;
					viewport.y = 0;
					
					if (_starling)
					{
						_starling.stage.stageWidth = screenRect.width / ratioW;
						_starling.stage.stageHeight = screenRect.height / ratioH;
					}
					
					break;
				case ViewportMode.NO_SCALE:
					viewport.copyFrom(baseRect);
					viewport.x = screenWidth * .5 - viewport.width * .5;
					viewport.y = screenHeight * .5 - viewport.height * .5;
					
					if (_starling)
					{
						_starling.stage.stageWidth = baseWidth;
						_starling.stage.stageHeight = baseHeight;
					}
					
					break;
				case ViewportMode.MANUAL:
					break;
			}
				
			return viewport;
		}

		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, viewPort:Rectangle = null, profile:String = "baseline"):void {
			
			// -swf-version=21
			//if (Assets.ScaleFactor >= 4)
			
			resetViewport();
			super.setUpStarling(debugMode, antiAliasing, viewport, Context3DProfile.BASELINE_EXTENDED);
			
			//else
				//super.setUpStarling(debugMode, antiAliasing, viewPort, profile);
				
			// fixed starling stage dimensions using baseWidth/baseHeight
			//_starling.stage.stageWidth = baseWidth;
			//_starling.stage.stageHeight = baseHeight;
		}

		override protected function _context3DCreated(evt:starling.events.Event):void {
			super._context3DCreated(evt);
			
			Assets.assets = new AssetManager();
			scaleFactor =  Utils.FindScaleFactor(screenWidth, screenHeight);
		}
		
		public function set scaleFactor(value:Number):void
		{
			if (value == scaleFactor)
				return;
			
			if (!Assets.assets)
				return;
				
			Assets.ScaleFactor = _scaleFactor = value;
			trace("NOW USING SCALE FACTOR", Assets.ScaleFactor);
			
			//Assets.assets.dispose();
			
			Assets.assets.scaleFactor = _scaleFactor;
			
			// We don't use the Assets.assets.enqueue(File.applicationDirectory.resolvePath(formatString("assets/{0}x", scaleFactor)));
			// syntax because we want to be able to run this game everywhere (Web & AIR).
			Assets.assets.enqueue("multi-resolutions/assets" + Assets.ScaleFactor + "x.png");
			Assets.assets.enqueue("multi-resolutions/assets" + Assets.ScaleFactor + "x.xml");

			Assets.assets.verbose = true;

			Assets.assets.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
					state = new MultiResolutionsState();
			});
		}
		
		public function get scaleFactor():Number
		{
			return _scaleFactor;
		}
	}
}