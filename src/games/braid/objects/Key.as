package games.braid.objects {

	import nape.callbacks.InteractionCallback;

	import com.citrusengine.objects.NapePhysicsObject;
	import com.citrusengine.objects.platformer.nape.Coin;
	import com.citrusengine.physics.nape.NapeUtils;
	
	public class Key extends Coin {

		public function Key(name:String, params:Object = null) {

			super(name, params);
		}
		
		override public function handleBeginContact(interactionCallback:InteractionCallback):void {
			
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