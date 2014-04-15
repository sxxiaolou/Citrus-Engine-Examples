package stage3dinteroperation {

	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import away3dbox2d.Away3DGameState;
	import citrus.core.away3d.Away3DCitrusEngine;
	import flash.events.Event;
	import starling.core.Starling;

	[SWF(frameRate="60",backgroundColor="0xCCCCCC")]

	/**
	 * @author Aymeric
	 */
	public class Main extends Away3DCitrusEngine {
		
		public var stage3DManager:Stage3DManager;
		public var stage3DProxy:Stage3DProxy;
		
		public var starlingSceneBack:Starling;
		public var starlingSceneFront:Starling;

		public function Main() {
		}
		
		override public function initialize():void
		{
			stage3DManager = Stage3DManager.getInstance(stage);

			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.color = 0x00000000;
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, _onContextCreated);
			stage3DProxy.antiAlias = 8;
		}

		private function _onContextCreated(evt:Stage3DEvent):void {
			
			setUpAway3D(true, 4, null, stage3DProxy);

			state = new Away3DGameState();
			
			starlingSceneBack = new Starling(StarlingBG, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
			starlingSceneFront = new Starling(StarlingFront, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
		}

		override protected function handleEnterFrame(e:Event):void {
			starlingSceneBack.nextFrame();
			super.handleEnterFrame(e);
			starlingSceneFront.nextFrame();
		}
		
		override protected function handleStageResize(e:Event):void
		{
			super.handleStageResize(e);
			if (stage3DProxy)
			{
				stage3DProxy.configureBackBuffer(stage.stageWidth, stage.stageHeight, _antiAliasing, stage3DProxy.enableDepthAndStencil);
			}
			if (starlingSceneBack && starlingSceneFront)
			{
				starlingSceneBack.stage.stageWidth = starlingSceneBack.viewPort.width = stage.stageWidth;
				starlingSceneBack.stage.stageHeight = starlingSceneBack.viewPort.height = stage.stageHeight;
				
				starlingSceneFront.stage.stageWidth = starlingSceneFront.viewPort.width = stage.stageWidth;
				starlingSceneFront.stage.stageHeight = starlingSceneFront.viewPort.height = stage.stageHeight;
			}
		}
	}
}
