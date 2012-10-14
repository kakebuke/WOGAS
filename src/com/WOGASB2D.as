package com
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class WOGASB2D extends Sprite
	{
		private const PIXELS_TO_METRE:int = 30;
		private const SWF_HALF_WIDTH:int = 512;
		private const SWF_HEIGHT:int = 768;
		
		private var _world:b2World;
		public var body:b2Body;
		public var throwingVec:Vector.<Point>;
		public var throwingTime:Number;
		
		
		private var _dragging:Boolean = false;
		
		public function WOGASB2D()
		{
			_world = new b2World(new b2Vec2(0, 9.8), true);
			throwingVec = new Vector.<Point>(2);
			
			var groundBodyDef:b2BodyDef= new b2BodyDef();
			groundBodyDef.position.Set(SWF_HALF_WIDTH / PIXELS_TO_METRE, SWF_HEIGHT / PIXELS_TO_METRE - 20 / PIXELS_TO_METRE);
			
			var leftBorderBodyDef:b2BodyDef= new b2BodyDef();
			leftBorderBodyDef.position.Set(SWF_HALF_WIDTH / PIXELS_TO_METRE, SWF_HEIGHT / PIXELS_TO_METRE - 20 / PIXELS_TO_METRE);
			
			var groundBody:b2Body = _world.CreateBody(groundBodyDef);
			
			var groundBox:b2PolygonShape = new b2PolygonShape();
			groundBox.SetAsBox(SWF_HALF_WIDTH / PIXELS_TO_METRE, 20 / PIXELS_TO_METRE);
			
			var groundFixtureDef:b2FixtureDef = new b2FixtureDef();
			groundFixtureDef.shape = groundBox;
			groundFixtureDef.density = 1;
			groundFixtureDef.friction = 1;
			groundFixtureDef.restitution = 0;
			groundBody.CreateFixture(groundFixtureDef);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(SWF_HALF_WIDTH/PIXELS_TO_METRE, 4);
			bodyDef.angle = 180;
			body = _world.CreateBody(bodyDef);
			
			var dynamicBox:b2PolygonShape = new b2PolygonShape();
			dynamicBox.SetAsBox(1,1);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = dynamicBox;
			fixtureDef.density = 1;
			fixtureDef.friction = 4;
			fixtureDef.restitution = 0.4;
			
			body.CreateFixture(fixtureDef);
			
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(PIXELS_TO_METRE);
			debugDraw.SetLineThickness( 1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			_world.SetDebugDraw(debugDraw);
			
			addEventListener(Event.ENTER_FRAME, update);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_dragging = false;
			throwingVec[1] = new Point(mouseX / PIXELS_TO_METRE, mouseY / PIXELS_TO_METRE);
			throwingTime = (getTimer()/1000) - throwingTime;
			body.SetLinearVelocity(_getThrowingVector());
			body.SetActive(true);
		}
		
		private function _getThrowingVector():b2Vec2
		{
			var p:Point = throwingVec[1].subtract(throwingVec[0]);
			return new b2Vec2(p.x / throwingTime, p.y / throwingTime);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			
			var p:b2Vec2 = new b2Vec2(mouseX / PIXELS_TO_METRE, mouseY / PIXELS_TO_METRE);
			if ( body.GetFixtureList().TestPoint(p) )
			{
				body.SetActive(false);
				body.SetLinearVelocity(new b2Vec2(0,0));
				body.SetAngularVelocity(0);
				_dragging = true;
				throwingVec[0] = new Point(mouseX / PIXELS_TO_METRE, mouseY / PIXELS_TO_METRE);
				throwingTime = getTimer() / 1000;
			}
		}
		
		protected function update(event:Event):void
		{
			var timeStep:Number = 1 / 30;
			var velocityIterations:int = 5;
			var positionIterations:int = 2;
			
			_world.Step(timeStep, velocityIterations, positionIterations);
			_world.ClearForces();
			_world.DrawDebugData();
			
			if (_dragging) {
				var p:b2Vec2 = new b2Vec2(mouseX / PIXELS_TO_METRE, mouseY / PIXELS_TO_METRE);
				body.SetPosition(p);
				var p2:Point = new Point(mouseX / PIXELS_TO_METRE, mouseY / PIXELS_TO_METRE);
				if (throwingVec[0].x < 0 && p2.x > 0 || throwingVec[0].x > 0 && throwingVec[0].x < 0) {
					throwingVec[0] = p2;
					throwingTime = getTimer() / 1000;
				}
				if (throwingVec[0].y < 0 && p2.y > 0 || throwingVec[0].y > 0 && throwingVec[0].y < 0) {
					throwingVec[0] = p2;
					throwingTime = getTimer() / 1000;
				}
			}
		}
	}
}