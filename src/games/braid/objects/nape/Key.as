package games.braid.objects.nape {

	import nape.callbacks.InteractionCallback;

	import com.citrusengine.objects.NapePhysicsObject;
	import com.citrusengine.objects.platformer.nape.Sensor;
	import com.citrusengine.physics.nape.NapeUtils;

	import flash.utils.getDefinitionByName;
	
	public class Key extends Sensor {

		protected var _collectorClass:Class = BraidHero;

		public function Key(name:String, params:Object = null) {

			super(name, params);
		}
		
		[Inspectable(defaultValue="com.citrusengine.objects.platformer.nape.Hero")]
		public function set collectorClass(value:*):void {
			
			if (value is String)
				_collectorClass = getDefinitionByName(value as String) as Class;
			else if (value is Class)
				_collectorClass = value;
		}
		
		override public function handleBeginContact(interactionCallback:InteractionCallback):void {
			
			super.handleBeginContact(interactionCallback);
			
			var other:NapePhysicsObject = NapeUtils.CollisionGetOther(this, interactionCallback);
			
			if (_collectorClass && other is _collectorClass)
				(other as BraidHero) .keySlot = this;
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
	}
}