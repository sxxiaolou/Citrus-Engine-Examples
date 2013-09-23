package games.superhexagon 
{
	import citrus.core.CitrusEngine;
	import flash.events.Event;
	
	[SWF(backgroundColor="#EAE8E8", frameRate="60", width="800", height="600")]
	public class Main extends CitrusEngine
	{
		
		public function Main():void 
		{
			
		}
		
		override protected function handleAddedToStage(e:Event):void
		{
			super.handleAddedToStage(e);
			state = new SuperHexagon();
		}
	}
	
}