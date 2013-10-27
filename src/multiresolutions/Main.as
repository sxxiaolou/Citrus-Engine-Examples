package multiresolutions {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	import flash.events.Event;
	import multiresolutions.Assets;
	import multiresolutions.MultiResolutionsState;
	import multiresolutions.Utils;
	import starling.events.Event;
	import starling.utils.AssetManager;

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
			
		override protected function handleAddedToStage(e:flash.events.Event):void {
			super.handleAddedToStage(e);
			
			scaleFactor = Utils.FindScaleFactor(_screenWidth, _screenHeight);
			
			setUpStarling(true, 1, null);
		}

		override protected function _context3DCreated(evt:starling.events.Event):void {
			super._context3DCreated(evt);
			
			Assets.assets = new AssetManager(scaleFactor);
			
			Assets.assets.enqueue("multi-resolutions/assets" + scaleFactor + "x.png");
			Assets.assets.enqueue("multi-resolutions/assets" + scaleFactor + "x.xml");

			Assets.assets.verbose = true;

			Assets.assets.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
					state = new MultiResolutionsState();
			});
		}
	}
}