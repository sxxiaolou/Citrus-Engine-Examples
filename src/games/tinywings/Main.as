package games.tinywings {

	import com.citrusengine.core.StarlingCitrusEngine;

	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {

		public function Main() {
			
			setUpStarling(true);
			
			state = new TinyWingsGameState();
		}
	}
}
