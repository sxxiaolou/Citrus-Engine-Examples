package multiresolutions {

	import citrus.core.starling.StarlingCitrusEngine;

	import multiresolutions.MultiResolutionsState;
	import multiresolutions.Utils;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import flash.display3D.Context3DProfile;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="960", height="640")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		static public var Assets:AssetManager;
		static public var ScaleFactor:Number;

		public function Main() {
			setUpStarling(true);
		}

		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, viewPort:Rectangle = null, profile:String = "baseline"):void {
			
			ScaleFactor = Utils.FindScaleFactor(stage.stageWidth, stage.stageHeight);

			// -swf-version=21
			if (ScaleFactor >= 4)
				super.setUpStarling(debugMode, antiAliasing, viewPort, Context3DProfile.BASELINE_EXTENDED);
			else
				super.setUpStarling(debugMode, antiAliasing, viewPort, profile);
		}

		override protected function _context3DCreated(evt:Event):void {
			super._context3DCreated(evt);

			Assets = new AssetManager();
			Assets.enqueue("multi-resolutions/assets" + ScaleFactor + "x.png");
			Assets.enqueue("multi-resolutions/assets" + ScaleFactor + "x.xml");

			Assets.verbose = true;

			Assets.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
					state = new MultiResolutionsState();
			});
		}
	}
}