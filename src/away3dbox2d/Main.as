package away3dbox2d {
	
	import away3dbox2d.Away3DGameState;
	
	import citrus.core.away3d.Away3DCitrusEngine;

	[SWF(frameRate="60")]

	/**
	* @author Aymeric
	*/
	public class Main extends Away3DCitrusEngine {

		public function Main() {
		}
		
		override public function initialize():void 
		{
			setUpAway3D(true);
			state = new Away3DGameState();
		}
	}
}