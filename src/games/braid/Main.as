package games.braid
{
	import com.citrusengine.core.StarlingCitrusEngine;
	import flash.display.Sprite;
	import flash.events.Event;
	import games.braid.states.BraidTest;
	
	public class Main extends StarlingCitrusEngine
	{
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setUpStarling(true, 1, stage);
			state = new BraidTest();
		}
	
	}

}