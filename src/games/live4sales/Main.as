package games.live4sales {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.Mobile;
	import flash.events.Event;

	import flash.geom.Rectangle;

	[SWF(backgroundColor="#000000", frameRate="60")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		public var compileForMobile:Boolean;
		public var isIpad:Boolean = false;
		
		public function Main() {

		}
		
		override protected function handleAddedToStage(e:Event):void
		{
				setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			// select Box2D or Nape demo
			state = new NapeLive4Sales();
			//state = new Box2DLive4Sales();
		}
	}
}
