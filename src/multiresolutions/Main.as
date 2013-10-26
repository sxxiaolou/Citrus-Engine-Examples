package multiresolutions {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	import citrus.input.controllers.gamepad.Gamepad;
	import citrus.input.controllers.gamepad.GamePadManager;
	import citrus.input.controllers.gamepad.maps.GamePadMap;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import multiresolutions.Assets;
	import multiresolutions.MultiResolutionsState;
	import multiresolutions.Utils;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;




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
		
		
		public function Main() {
			
			_baseWidth = 480;
			_baseHeigth = 320;
			_viewportMode = ViewportMode.LETTERBOX;
			
		}
		
		override protected function handleStageResize(e:flash.events.Event = null):void
		{
			
			super.handleStageResize(e);
			
			if (!_starling)
				return;
			
			scaleFactor =  Utils.FindScaleFactor(_screenWidth, _screenHeight);
		}
			
		override protected function handleAddedToStage(e:flash.events.Event):void {
			super.handleAddedToStage(e);
			
			setUpStarling(true, 1, null,Context3DProfile.BASELINE_EXTENDED);
		}

		override protected function _context3DCreated(evt:starling.events.Event):void {
			super._context3DCreated(evt);
			
			Assets.assets = new AssetManager();
			
			scaleFactor =  Utils.FindScaleFactor(_screenWidth, _screenHeight);
		}
		
		/**
		 * overriding scaleFactor setter to load assets dynamically.
		 */
		override public function set scaleFactor(value:Number):void
		{
			if (value == scaleFactor)
				return;
			
			if (!Assets.assets)
				return;
				
			Assets.ScaleFactor = _scaleFactor = value;
			
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
		
	}
}