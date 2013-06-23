package vehicle {

	import citrus.core.starling.StarlingCitrusEngine;
	
	import vehicle.CarGameState;

	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="550", height="400")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {

			setUpStarling(true);

			state = new CarGameState();
		}
	}
}