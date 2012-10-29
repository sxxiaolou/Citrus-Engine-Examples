package games.tinywings {

	import com.citrusengine.core.StarlingState;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.physics.nape.Nape;

	import flash.geom.Rectangle;

	/**
	 * @author Aymeric
	 */
	public class TinyWingsGameState extends StarlingState {
		
		private var _nape:Nape;
		private var _hero:BirdHero;
		
		private var _hillsTexture:HillsTexture;

		public function TinyWingsGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();

			_nape = new Nape("nape");
			//_nape.visible = true;
			add(_nape);
			
			_hero = new BirdHero("hero", {radius:20});
			add(_hero);
			
			_hillsTexture = new HillsTexture();

			var hills:HillsManagingGraphics = new HillsManagingGraphics("hills", {sliceHeight:200, sliceWidth:70, currentYPoint:350, registration:"topLeft", view:_hillsTexture});
			add(hills);

			view.setupCamera(_hero, new MathVector(stage.stageWidth /2, stage.stageHeight / 2), new Rectangle(0, 0, int.MAX_VALUE, int.MAX_VALUE), new MathVector(.25, .05));
		}
			
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			_hillsTexture.update();
		}
	}
}
