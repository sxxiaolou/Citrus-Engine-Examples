package multiresolutions {

	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.tmx.TmxMap;
	import citrus.utils.objectmakers.tmx.TmxObject;
	import citrus.utils.objectmakers.tmx.TmxObjectGroup;
	import citrus.utils.objectmakers.tmx.TmxPropertySet;
	import citrus.utils.objectmakers.tmx.TmxTileSet;
	import citrus.view.starlingview.AnimationSequence;

	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.textures.Texture;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Aymeric
	 */
	public class MultiResolutionsState extends StarlingState {
		
		[Embed(source="/../embed/tiledmap/multi-resolutions/map.tmx", mimeType="application/octet-stream")]
		private const _Map:Class;
		
		private var _hero:Hero;

		public function MultiResolutionsState() {
			super();
			
			// Useful for not forgetting to import object from the Level Editor
			var objects:Array = [Hero, Platform, Sensor, Coin];
		}

		override public function initialize():void {
			super.initialize();
			
			var box2D:Box2D = new Box2D("box2D");
			// box2D.visible = true;
			add(box2D);

			FromTiledMap(XML(new _Map()), Assets.assets);

			_hero = getFirstObjectByType(Hero) as Hero;
			_hero.registration = "topLeft";
			_hero.view = new AnimationSequence(Assets.assets, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			_hero.offsetX = -_hero.view.width * 0.5;
			_hero.offsetY = -_hero.view.height * 0.5; 

			view.camera.setUp(_hero, new Point(_ce.screenWidth / 2, _ce.screenHeight / 2), new Rectangle(0, 0, 6000, 7000), new Point(.25, .05));
		}
		
		public static function FromTiledMap(levelXML:XML, atlas:*, addToCurrentState:Boolean = true):Array {

			var ce:CitrusEngine = CitrusEngine.getInstance();
			var params:Object;

			var objects:Array = [];

			var tmx:TmxMap = new TmxMap(levelXML);

			var citrusSprite:CitrusSprite;

			var mapTiles:Array;
			var mapTilesX:uint, mapTilesY:uint;

			for (var layer_num:uint = 0; layer_num < tmx.layers_ordered.length; ++layer_num) {
				
				var layer:String = tmx.layers_ordered[layer_num];
				mapTiles = tmx.getLayer(layer).tileGIDs;

				mapTilesX = mapTiles.length;

				var qb:QuadBatch = new QuadBatch();

				for each (var tileSet:TmxTileSet in tmx.tileSets) {

					for (var i:uint = 0; i < mapTilesX; ++i) {

						mapTilesY = mapTiles[i].length;

						for (var j:uint = 0; j < mapTilesY; ++j) {

							if (mapTiles[i][j] != 0) {

								var tileID:uint = mapTiles[i][j];
								var tileProps:TmxPropertySet = tileSet.getProperties(tileID - 1);
								var name:String = tileProps["name"];
								// TODO : look into an other atlas if the texture isn't found.
								var texture:Texture = atlas.getTexture(name);

								var image:Image = new Image(texture);
								image.x = j * tmx.tileWidth * Assets.ScaleFactor;
								image.y = i * tmx.tileHeight * Assets.ScaleFactor;
								
								qb.addImage(image);
							}
						}
					}
				}

				params = {};

				params.view = qb;

				for (var param:String in tmx.getLayer(layer).properties)
					params[param] = tmx.getLayer(layer).properties[param];

				citrusSprite = new CitrusSprite(layer, params);
				objects.push(citrusSprite);
			}

			var objectClass:Class;
			var object:CitrusObject;

			for each (var group:TmxObjectGroup in tmx.objectGroups) {

				for each (var objectTmx:TmxObject in group.objects) {

					objectClass = getDefinitionByName(objectTmx.type) as Class;

					params = {};

					for (param in objectTmx.custom)
						params[param] = objectTmx.custom[param];

					params.x = objectTmx.x * Assets.ScaleFactor + objectTmx.width * Assets.ScaleFactor *  0.5;
					params.y = objectTmx.y * Assets.ScaleFactor + objectTmx.height * Assets.ScaleFactor * 0.5;
					params.width = objectTmx.width * Assets.ScaleFactor;
					params.height = objectTmx.height * Assets.ScaleFactor;
					params.rotation = objectTmx.rotation;
					
					if (objectTmx.custom && objectTmx.custom["view"])
						params.view = atlas.getTexture(objectTmx.custom["view"]);
					
					// Polygon/Polyline support
					if (objectTmx.shapeType != null) {
						//params.shapeType = objectTmx.shapeType;
						params.points = objectTmx.points;
					}

					object = new objectClass(objectTmx.name, params);
					objects.push(object);
				}
			}

			if (addToCurrentState)
				for each (object in objects) ce.state.add(object);

			return objects;
        }

	}
}
