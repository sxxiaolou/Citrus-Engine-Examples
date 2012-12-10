package games.braid.objects.nape
{
	import com.citrusengine.objects.NapePhysicsObject;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	
	public class BraidHero extends NapePhysicsObject
	{
		public var inputChannel:uint = 0;
		protected var _groundContacts:Array = [];
		protected var _onGround:Boolean = false;
		protected var _ducking:Boolean = false;
		protected var _combinedGroundAngle:Number = 0;
		
		private var _beginContactListener:InteractionListener;
		private var _endContactListener:InteractionListener;
		
		public static const BRAID_HERO:CbType = new CbType();
		
		public var camTarget:Object = { x: 0, y: 0 };
		public var dead:Boolean = false;
		
		private var _collideable:Boolean = true;
		
		public function BraidHero(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override protected function createConstraint():void
		{
			
			super.createConstraint();
			
			_beginContactListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, BRAID_HERO, CbType.ANY_BODY, handleBeginContact);
			_endContactListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, BRAID_HERO, CbType.ANY_BODY, handleEndContact);
			_body.cbTypes.add(BRAID_HERO);
			_body.space.listeners.add(_beginContactListener);
			_body.space.listeners.add(_endContactListener);
		}
		
		override protected function createBody():void
		{
			
			super.createBody();
			
			_body.allowRotation = false;
		}
		
		override protected function createMaterial():void
		{
			
			super.createMaterial();
			
			_material.elasticity = 0;
			_material.dynamicFriction = 1.6;
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
		
		public function noCollide():void
		{
			_shape.sensorEnabled = true;
		}
		
		public function doCollide():void
		{
			_shape.sensorEnabled = false;
		}
		
		public function killNow():void
		{
			noCollide();
			_body.velocity.y -= 150;
			dead = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//update cam target:
			
			camTarget.x = _body.position.x;
			camTarget.y = _body.position.y;
			
			if (dead)
			{
				if (_animation == "dying" && animationFrame == 6)
				{
					_animation = "dying_loop";
				}
				else if( _animation != "dying_loop")
					_animation = "dying";
				return;
			}
			
			if (_onGround)
			{
				_animation = "idle";
				//_inverted = false;
				
				if (_ce.input.isDoing("up", inputChannel))
				{
					_animation = "looking_upward";
					camTarget.y = _body.position.y - 200;
				}
				if (_ce.input.isDoing("down", inputChannel))
				{
					_animation = "looking_downward";
					camTarget.y = _body.position.y + 200;
				}
			}
			
			if (_ce.input.isDoing("right", inputChannel))
			{
				if (_onGround)
					_animation = "running";
				_body.velocity.x += 30;
				_inverted = false;
			}
			
			if (_ce.input.isDoing("left", inputChannel))
			{
				if (_onGround)
					_animation = "running";
				_body.velocity.x -= 30;
				_inverted = true;
			}
			
			if (_ce.input.justDid("jump", inputChannel) && _onGround)
			{
				_body.velocity.y -= 500;
				_animation = "jump_prep_straight";
				_onGround = false;
			}
			
			if (velocity.x > 35)
				velocity.x = 35;
			else if (velocity.x < -35)
				velocity.x = -35;
				
			if (body.interactingBodies().length == 0 && _body.velocity.y > 0)
			{
				_animation = "falling_downward";
			}
			
			if (body.position.y > 1200)
			{
				animation = "dying_loop";
			}
		
		}
		
		override public function handleBeginContact(e:InteractionCallback):void
		{
			var body2:Body = e.int2.castBody;
			_groundContacts.push(body2);
			
			if (e.arbiters.length > 0 && e.arbiters.at(0).collisionArbiter && e.int1.castBody.userData.myData == this)
			{
				var angle:Number = e.arbiters.at(0).collisionArbiter.normal.angle * 180 / Math.PI;
				if ((45 < angle) && (angle < 135))
				{
					_onGround = true;
					
					if (body2.userData.myData is BraidEnemy)
						(body2.userData.myData as BraidEnemy).killNow();
					
				}else if ((angle == -180 || angle == 0|| angle == 180) && body2.userData.myData is BraidEnemy)
					killNow();
			}
		}
		
		override public function handleEndContact(e:InteractionCallback):void
		{
			_groundContacts.splice(_groundContacts.indexOf(e.int2.castBody), 1);
			
			if (e.arbiters.length > 0 && e.arbiters.at(0).collisionArbiter)
			{
				var angle:Number = e.arbiters.at(0).collisionArbiter.normal.angle * 180 / Math.PI;
				if ((45 < angle) && (angle < 135))
				{
					_onGround = false;
				}
			}
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
		
		public function get animationFrame():uint
		{
			return (_view as AnimationSequence).mcSequences[_animation].currentFrame;
		}
		
		public function set animationFrame(value:uint):void
		{
			(_view as AnimationSequence).mcSequences[_animation].currentFrame = value;
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
	
	}

}