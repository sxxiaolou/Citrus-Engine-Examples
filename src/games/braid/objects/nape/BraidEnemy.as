package games.braid.objects.nape {

	import nape.geom.Vec2;

	import com.citrusengine.objects.platformer.nape.Enemy;
	import com.citrusengine.view.starlingview.AnimationSequence;
	
	public class BraidEnemy extends Enemy
	{		
		private var _collideable:Boolean = true;
		
		public function BraidEnemy(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		public function detachPhysics():void
		{
			_body.space = null;
		}
		
		public function attachPhysics():void
		{
			_body.space = _nape.space;
			_body.velocity.x = _body.velocity.y = 0;
		}
		
		override public function update(timeDelta:Number):void
		{			
			var position:Vec2 = _body.position;
			
			//Turn around when they pass their left/right bounds
			if ((!_inverted && position.x < leftBound) || (_inverted && position.x > rightBound))
				turnAround();
			
			var velocity:Vec2 = _body.velocity;
			
			if (!_hurt)
				velocity.x = _inverted ? speed : -speed;
			else
				velocity.x = 0;
			
			_body.velocity = velocity;
			
			updateAnimation();
		}
		
		public function noCollide():void
		{
			_shape.sensorEnabled = true;
		}
		
		public function doCollide():void
		{
			//call it a hack if you want :)
			_shape.sensorEnabled = false;
		}
		
		public function killNow():void
		{
			noCollide();
			//_hurt = true;
			_body.velocity.y -= 150;
			_body.allowRotation = true;
			_body.angularVel = 0.4;
		}
		
		override protected function updateAnimation():void
		{
			_animation = _shape.sensorEnabled ? "monster-dyingMonster" : "monster-walking";
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
		
		public function set animation(value:String):void
		{
			_animation = value;
		}
		
		public function get collideable():Boolean
		{
			return _collideable;
		}
		
		public function set collideable(value:Boolean):void
		{
			_collideable = value;
			_shape.sensorEnabled = !value;
		}
		
		public function get animationFrame():uint
		{
			return (_view as AnimationSequence).mcSequences[_animation].currentFrame;
		}
		
		public function set animationFrame(value:uint):void
		{
			(_view as AnimationSequence).mcSequences[_animation].currentFrame = value;
		}
	
	}
}