package games.braid.objects.nape {

	import nape.callbacks.CbType;
	import nape.geom.Vec2;

	import com.citrusengine.objects.NapePhysicsObject;
	import com.citrusengine.view.starlingview.AnimationSequence;

	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	public class BraidEnemy extends NapePhysicsObject
	{
		
		public static const BRAID_ENEMY:CbType = new CbType();
		
		[Inspectable(defaultValue="39")]
		public var speed:Number = 39;
		
		[Inspectable(defaultValue="3")]
		public var enemyKillVelocity:Number = 3;
		
		[Inspectable(defaultValue="left",enumeration="left,right")]
		public var startingDirection:String = "left";
		
		[Inspectable(defaultValue="400")]
		public var hurtDuration:Number = 400;
		
		[Inspectable(defaultValue="-100000")]
		public var leftBound:Number = -100000;
		
		[Inspectable(defaultValue="100000")]
		public var rightBound:Number = 100000;
		
		protected var _hurtTimeoutID:Number = 0;
		protected var _hurt:Boolean = false;
		protected var _enemyClass:* = BraidHero;
		protected var _lastXPos:Number;
		protected var _lastTimeTurnedAround:Number = 0;
		protected var _waitTimeBeforeTurningAround:Number = 1000;
		
		//private var _beginContactListener:InteractionListener;
		//private var _endContactListener:InteractionListener;
		
		private var _collideable:Boolean = true;
		
		public function BraidEnemy(name:String, params:Object = null)
		{
			
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			
			super.initialize(poolObjectParams);
			
			if (startingDirection == "left")
				_inverted = false;
		
			//_beginContactListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, BRAID_ENEMY, CbType.ANY_BODY, handleBeginContact);
			//_endContactListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, BRAID_ENEMY, CbType.ANY_BODY, handleEndContact);				
		}
		
		override public function destroy():void
		{
			
			clearTimeout(_hurtTimeoutID);
			
			super.destroy();
		}
		
		public function get enemyClass():*
		{
			return _enemyClass;
		}
		
		[Inspectable(defaultValue="BraidEnemy",type="String")]
		public function set enemyClass(value:*):void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value) as Class;
			else if (value is Class)
				_enemyClass = value;
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
			
			super.update(timeDelta);
			
			var position:Vec2 = _body.position;
			_lastXPos = position.x;
			
			//Turn around when they pass their left/right bounds
			if ((!_inverted && position.x < leftBound) || (_inverted && position.x > rightBound))
				turnAround();
			else
			{
				if (position.x > rightBound)
					position.x = rightBound - 1;
				if (position.x < leftBound)
					position.x = leftBound + 1;
			}
			
			var velocity:Vec2 = _body.velocity;
			
			if (!_hurt)
				velocity.x = _inverted ? speed : -speed;
			else
				velocity.x = 0;
			
			_body.velocity = velocity;
			
			updateAnimation();
		}
		
		public function hurt():void
		{
			
			_hurt = true;
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
		}
		
		public function turnAround():void
		{
			
			_inverted = !_inverted;
			_lastTimeTurnedAround = new Date().time;
		}
		
		override protected function createBody():void
		{
			
			super.createBody();
			
			_body.allowRotation = false;
		}
		
		override protected function createConstraint():void
		{
			
			_body.space = _nape.space;
			_body.cbTypes.add(BRAID_ENEMY);
		}
		
		public function noCollide():void
		{
			_shape.sensorEnabled = true;
		}
		
		public function doCollide():void
		{
			//_shape.fluidEnabled = false;
			_shape.sensorEnabled = false;
			//_body.shapes.foreach(function di(s:Shape) { (s as Shape).fluidEnabled = false ; } );
		}
		
		public function killNow():void
		{
			noCollide();
			//_hurt = true;
			_body.velocity.y -= 150;
			_body.allowRotation = true;
			_body.angularVel = 0.4;
		}
		
		protected function updateAnimation():void
		{
			
			_animation = _shape.sensorEnabled ? "monster-dyingMonster" : "monster-walking";
		}
		
		protected function endHurtState():void
		{
			
			_hurt = false;
			kill = true;
		}
		
		override public function get inverted():Boolean
		{
			return _inverted;
		}
		
		public function set inverted(value:Boolean):void
		{
			_inverted = value;
		}
		
		override public function get animation():String
		{
			return _animation;
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