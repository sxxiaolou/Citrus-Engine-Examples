package tiledmap.starling {

	import com.citrusengine.core.StarlingCitrusEngine;

	[SWF(backgroundColor="#000000", frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {
			
			setUpStarling(true);

			state = new StarlingTiledMapGameState();
		}
	}
}