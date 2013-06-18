package spine {

	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;

	import spine.starling.SkeletonAnimationSprite;
	import spine.starling.StarlingAtlasAttachmentLoader;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;

	/**
	 * @author Aymeric
	 */
	public class SpineState extends StarlingState {

		[Embed(source="/../embed/spine/spineboy.xml",mimeType="application/octet-stream")]
		static public const SpineBoyAtlasXml:Class;

		[Embed(source="/../embed/spine/spineboy.png")]
		static public const SpineBoyAtlasTexture:Class;

		[Embed(source="/../embed/spine/spineboy.json",mimeType="application/octet-stream")]
		static public const SpineBoyJson:Class;

		private var _skeleton:SkeletonAnimationSprite;

		[Embed(source="/../embed/Hero.xml", mimeType="application/octet-stream")]
		private const _heroConfig:Class;

		[Embed(source="/../embed/Hero.png")]
		private const _heroPng:Class;

		public function SpineState() {
			super();
		}

		override public function initialize():void {
			super.initialize();

			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);
			
			add(new Platform("platform bottom", {x:stage.stageWidth / 2, y:stage.stageHeight, width:stage.stageWidth}));

			var texture:Texture = Texture.fromBitmap(new SpineBoyAtlasTexture());
			var xml:XML = XML(new SpineBoyAtlasXml());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);

			var json:SkeletonJson = new SkeletonJson(new StarlingAtlasAttachmentLoader(atlas));
			var skeletonData:SkeletonData = json.readSkeletonData(new SpineBoyJson());

			var stateData:AnimationStateData = new AnimationStateData(skeletonData);
			_skeleton = new SkeletonAnimationSprite(skeletonData);
			_skeleton.setAnimationStateData(stateData);
			
			var spineBoy:Hero = new Hero("SpineBoy", {x:150, width:140, height:200, offsetY:20, view:_skeleton});
			add(spineBoy);

			var bitmap:Bitmap = new _heroPng();
			texture = Texture.fromBitmap(bitmap);
			xml = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);

			var patch:Hero = new Hero("patch", {x:300, width:60, height:135, view:new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle")});
			add(patch);
		}

	}
}
