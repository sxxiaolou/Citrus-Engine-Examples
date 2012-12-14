package games.braid {

	import citrus.core.StarlingCitrusEngine;
	import citrus.utils.Mobile;

	import flash.geom.Rectangle;

	public class Main extends StarlingCitrusEngine
	{
		
		public function Main():void
		{
			if (Mobile.isAndroid())
				setUpStarling(true, 1, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			else
				setUpStarling(true, 1);
				
			state = new BraidDemo();
		}
	
	}

}