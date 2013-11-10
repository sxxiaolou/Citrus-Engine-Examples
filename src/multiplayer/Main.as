package multiplayer {

	import citrus.core.starling.StarlingCitrusEngine;
	import flash.events.Event;

	[SWF(frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends StarlingCitrusEngine {

		public function Main() {
			
			// for good references on multiplayer
			// https://developer.valvesoftware.com/wiki/Source_Multiplayer_Networking
			// http://gafferongames.com/game-physics/networked-physics/
		}
		
		override protected function handleAddedToStage(e:Event):void
		{
			super.handleAddedToStage(e);
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			state = new MultiPlayerGameState();
		}
	}
}