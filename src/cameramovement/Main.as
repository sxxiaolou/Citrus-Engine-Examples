package cameramovement {
	
	import cameramovement.CameraMovement;
	import flash.events.Event;

	import citrus.core.starling.StarlingCitrusEngine;
	
	import flash.display.Sprite;

	[SWF(frameRate="60",width="800", height="600")]
	
	public class Main extends StarlingCitrusEngine {
		
		//this will be the flash debug sprite for the camera.
		public var debugSpriteRectangle:Sprite = new Sprite();
		
		public function Main() {
			
			addChild(debugSpriteRectangle);
		}
		
		override protected function handleAddedToStage(e:Event):void
		{
			super.handleAddedToStage(e);
			setUpStarling(true, 1);
		}
		
		override public function handleStarlingReady():void
		{
			state = new CameraMovement(debugSpriteRectangle);
		}
	}
}
