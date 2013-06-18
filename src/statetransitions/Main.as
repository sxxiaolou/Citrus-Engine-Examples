package statetransitions {

	import citrus.core.starling.StarlingCitrusEngine;
	
	import statetransitions.StarlingDemoStateTransition;

	[SWF(frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {

			setUpStarling(true);
			
			sound.addSound("Hurt", {sound:"sounds/hurt.mp3"});
			sound.addSound("Kill", {sound:"sounds/kill.mp3"});

			state = new StarlingDemoStateTransition();
		}
	}
}