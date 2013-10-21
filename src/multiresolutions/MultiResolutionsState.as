package multiresolutions {

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState {
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;

		public function MultiResolutionsState() {
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform];
		}

		override public function initialize():void {
			super.initialize();
			
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
			add(box2D);

			ObjectMakerStarling.FromTiledMap(XML(new _Map()), Main.Assets);

			var hero:Hero = getObjectByName("hero") as Hero;

			view.camera.setUp(hero, new Point(stage.stageWidth / 2, stage.stageHeight / 2), new Rectangle(0, 0, 6000, 7000), new Point(.25, .05));
		}

	}
}
