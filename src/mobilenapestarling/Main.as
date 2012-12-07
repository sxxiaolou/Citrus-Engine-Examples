package mobilenapestarling {

	import com.citrusengine.core.StarlingCitrusEngine;
	import com.citrusengine.utils.Mobile;

	import flash.display.Stage;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="#000000", frameRate="60")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		public var compileForMobile:Boolean;
		public var isIpad:Boolean = false;
		
		public function Main() {

			compileForMobile = Mobile.isIOS() ? true : false;
			
			if (compileForMobile) {
				
				// detect if iPad
				isIpad = Mobile.isIpad();
				
				if (isIpad)
					setUpStarling(true, 1, stage, new Rectangle(32, 64, stage.fullScreenWidth, stage.fullScreenHeight));
				else
					setUpStarling(true, 1, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			} else 
				setUpStarling(true);
			
			state = new MobileNapeStarlingGameState();
		}
		
		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, flashStage:Stage = null, viewport:Rectangle = null):void {
			
			super.setUpStarling(debugMode, antiAliasing, flashStage, viewport);
			
			if (compileForMobile) {
				// set iPhone & iPad size, used for Starling contentScaleFactor
				// landscape mode!
				_starling.stage.stageWidth = isIpad ? 512 : 480;
				_starling.stage.stageHeight = isIpad ? 384 : 320;
			}
		}
	}
}
