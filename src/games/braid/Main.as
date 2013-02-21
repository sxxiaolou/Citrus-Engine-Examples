package games.braid {

	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.Mobile;
	
	import games.braid.BraidDemo;

	import starling.core.Starling;

	import flash.geom.Rectangle;
	
	[SWF(frameRate="60")]

	public class Main extends StarlingCitrusEngine
	{
		
		public function Main():void
		{
			if (Mobile.isAndroid()) {
				
				Starling.handleLostContext = true;
				Starling.multitouchEnabled = true;
				
				setUpStarling(true, 1, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			} else
				setUpStarling(true, 1);
				
			state = new BraidDemo();
		}
	
	}

}