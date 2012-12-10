package games.braid.objects.nape {
	
	import flash.utils.getDefinitionByName;
	import com.citrusengine.objects.platformer.nape.Sensor;
	import nape.callbacks.InteractionCallback;

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
			
			if (_collectorClass && interactionCallback.int2.userData.myData is _collectorClass) {
				interactionCallback.int2.userData.myData.keySlot = this;
			}
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
	}
}