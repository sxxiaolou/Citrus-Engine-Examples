package games.braid {

	import games.braid.states.BraidTest;

	import com.citrusengine.core.StarlingCitrusEngine;
	import com.citrusengine.utils.Mobile;

	import flash.geom.Rectangle;
	
	public class Main extends StarlingCitrusEngine
	{
		
		public function Main():void
		{
			if (Mobile.isAndroid())
				setUpStarling(true, 1, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			else
				setUpStarling(true, 1);
				
			state = new BraidTest();
		}
	
	}

}