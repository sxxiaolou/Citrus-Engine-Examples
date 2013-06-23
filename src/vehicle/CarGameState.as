package vehicle {

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.nape.Hills;
	import citrus.objects.vehicle.nape.Car;
	import citrus.objects.vehicle.nape.Driver;
	import citrus.objects.vehicle.nape.Nugget;
	import citrus.physics.nape.Nape;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Aymeric
	 */
	public class CarGameState extends StarlingState {

		public function CarGameState() {

		}

		override public function initialize():void {
			super.initialize();

			var nape:Nape = new Nape("physics");
			nape.visible = true;
			add(nape);
			
			// We will be happy to have some graphics to make a beautiful demo!!

			var car:Car = new Car("car", {x:200, y:500, nmbrNuggets:5});
			add(car);

			var hills:Hills = new Hills("hills", {rider:car, currentYPoint:600, sliceWidth:50, widthHills:stage.stageWidth * 2, registration:"topLeft"});
			add(hills);

			view.camera.setUp(car, new Point(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 250000, 6000), new Point(.25, .05));
			
			(getFirstObjectByType(Driver) as Driver).onGroundTouched.add(_gameOver);
			
			for each (var nugget:Nugget in car.nuggets)
				nugget.onNuggetLost.addOnce(_aNuggetIsLost);
		}

		private function _gameOver():void {
			
			trace('the car crashed');
		}

		private function _aNuggetIsLost(nugget:Nugget):void {
			
			trace('a nugget is lost');
		}
	}
}
