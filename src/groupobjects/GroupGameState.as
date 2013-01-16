package groupobjects {

	import flash.utils.setTimeout;
	import citrus.core.CitrusGroup;
	import citrus.core.starling.StarlingState;
	import citrus.objects.NapePhysicsObject;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;

	import starling.display.BlendMode;
	import starling.display.Quad;

	/**
	 * @author Aymeric
	 */
	public class GroupGameState extends StarlingState {
		
		private const _Box_SIZE:uint = 60;
		
		private var _group:CitrusGroup;

		public function GroupGameState() {
			super();
		}

		override public function initialize():void {

			super.initialize();
			
			var physics:Nape = new Nape("physics");
			physics.visible = true;
			add(physics);
			
			add(new Platform("platform bot", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));
			add(new Platform("platform left", {y:stage.stageHeight / 2, height:stage.stageHeight}));
			add(new Platform("platform right", {x:stage.stageWidth, y:stage.stageHeight / 2, height:stage.stageHeight}));
			
			_group = new CitrusGroup("a group");
			
			var box:NapePhysicsObject;
			for (var i:uint = 0; i < 7; ++i) {
					
				box = new NapePhysicsObject(String(i), {x:_Box_SIZE + Math.random() * (stage.stageWidth - _Box_SIZE), width:_Box_SIZE, height:_Box_SIZE, view:new Quad(_Box_SIZE, _Box_SIZE, Math.random() * 0xFFFFFF)});
				add(box);
				_group.add(box);
			}
			
			setTimeout(_addProperties, 3000);
			
		}

		private function _addProperties():void {
			
			_group.setParamsOnObjects({x:150});
			_group.setParamsOnViews({blendMode:BlendMode.ERASE});
			
		}

	}
}
