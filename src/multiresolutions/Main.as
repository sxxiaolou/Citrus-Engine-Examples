package multiresolutions {

	import citrus.core.starling.StarlingCitrusEngine;

	import multiresolutions.Assets;
	import multiresolutions.Constants;
	import multiresolutions.MultiResolutionsState;
	import multiresolutions.Utils;

	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="#86f8ff", frameRate="60", width="480", height="320")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		public function Main() {
			
		}
			
		override protected function handleAddedToStage(e:flash.events.Event):void {
			super.handleAddedToStage(e);
			
			setUpStarling(true, 1, RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, screenWidth, screenHeight), ScaleMode.SHOW_ALL));
		}

		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, viewPort:Rectangle = null, profile:String = "baseline"):void {
			
			Assets.ScaleFactor = Utils.FindScaleFactor(screenWidth, screenHeight);

			// -swf-version=21
			if (Assets.ScaleFactor >= 4)
				super.setUpStarling(debugMode, antiAliasing, viewPort, Context3DProfile.BASELINE_EXTENDED);
			else
				super.setUpStarling(debugMode, antiAliasing, viewPort, profile);
				
			_starling.stage.stageWidth = Constants.GameWidth;
            _starling.stage.stageHeight = Constants.GameHeight;
		}

		override protected function _context3DCreated(evt:starling.events.Event):void {
			super._context3DCreated(evt);

			Assets.assets = new AssetManager();
			
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