package com
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class WOGASCAMERA extends Sprite
	{
		public static const STAGE_WIDTH:int = 1024;
		public static const STAGE_HEIGHT:int = 768;
		
		private var _world:b2World;
		
		private var _leftWall:b2Body;
		private var _rightWall:b2Body;
		private var _ground:b2Body;
		
		private var environment:Vector.<b2Body>;
		
		private var scene:Rectangle;
		private var viewPort:Rectangle;
		
		public function WOGASCAMERA()
		{
			environment = new Vector.<b2Body>();
			
			_world = new b2World(new b2Vec2(0,9.8), true);
			B2BodyGenerator.me.init(_world);
			
			_leftWall = B2BodyGenerator.me.getBox(
				new Point(0,0), 
				30, 
				STAGE_HEIGHT * 1.5, 
				B2BodyGenerator.me.getFixtureDef(1,.5,.3)
			);
			
			_ground = B2BodyGenerator.me.getBox(
				new Point(0, STAGE_HEIGHT * 1.5), 
				STAGE_WIDTH * 3, 
				30, 
				B2BodyGenerator.me.getFixtureDef(1,.5,.3)
			);
			
			_rightWall = B2BodyGenerator.me.getBox(
				new Point(STAGE_WIDTH * 3, 0), 
				30, 
				STAGE_HEIGHT * 1.5, 
				B2BodyGenerator.me.getFixtureDef(1,.5,.3)
			);
			
			environment.push(_ground, _leftWall, _rightWall);
			
			scene = new Rectangle(0, 0, STAGE_WIDTH * 3, STAGE_HEIGHT * 1.5);
			viewPort = new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			
			_setDebugMode();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function update(event:Event):void
		{
			var timeStep:Number = 1 / 30;
			var velocityIterations:int = 5;
			var positionIterations:int = 2;
			
			var desplx:Number = 10;
			var desply:Number = 5;
			var newPos:b2Vec2;
			for each (var body:b2Body in environment) {
				if ( canScroll(desplx, desply) ) {
					newPos = new b2Vec2(body.GetPosition().x - (desplx / B2DConf.RATIO), body.GetPosition().y - (desply / B2DConf.RATIO));
					viewPort.x += desplx;
					viewPort.y += desply;
				} else if ( canScrollX(desplx) ) {
					newPos = new b2Vec2(body.GetPosition().x - (desplx / B2DConf.RATIO), body.GetPosition().y);
					viewPort.x += desplx;
				} else if ( canScrollY(desply) ) {
					newPos = new b2Vec2(body.GetPosition().x, body.GetPosition().y - (desply / B2DConf.RATIO));
					viewPort.y += desply;
				} else {
					newPos = null;
				}

				if (newPos) {
					body.SetPosition(newPos);
					trace("Body Position: " + body.GetPosition().x * B2DConf.RATIO + ", " + body.GetPosition().y * B2DConf.RATIO);
				}
			}

			_world.Step(timeStep, velocityIterations, positionIterations);
			_world.ClearForces();
			_world.DrawDebugData();
		}
		
		private function canScroll(dx:Number, dy:Number):Boolean
		{
			var can:Boolean = true;
			
			can = canScrollX(dx) && canScrollY(dy);
			
			return can;
		}
		
		private function canScrollX(dx:Number):Boolean
		{
			return viewPort.x + dx > 0 && viewPort.x + viewPort.height + dx < scene.width;
		}
		
		private function canScrollY(dy:Number):Boolean
		{
			return viewPort.y + dy > 0 && viewPort.y + viewPort.height + dy < scene.height;
		}
		
		private function _setDebugMode():void
		{
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite( debugSprite );
			debugDraw.SetDrawScale( B2DConf.RATIO );
			debugDraw.SetLineThickness( 1.0 );
			debugDraw.SetAlpha( 1 );
			debugDraw.SetFillAlpha( 0.4 );
			debugDraw.SetFlags( b2DebugDraw.e_shapeBit );
			_world.SetDebugDraw( debugDraw );
		}
	}
}