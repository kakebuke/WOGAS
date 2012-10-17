package com
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;

	public class B2BodyGenerator
	{
		private static var _instance:B2BodyGenerator;
		
		private var _world:b2World;
		
		public function B2BodyGenerator(sg:Singleton)
		{
		}
		
		public static function get me():B2BodyGenerator
		{
			if (!_instance) {
				_instance = new B2BodyGenerator(new Singleton());
			} 
			return _instance;
		}
		
		public function init(world:b2World):void 
		{
			_world = world;
		}
		
		/**
		 * Receives a point in pixels and returns a body definition with the final
		 * position in Box2D coordinates 
		 * @param pos:Point center of the body
		 * @return b2BodyDef
		 * @see Box2D.Dynamics.b2BodyDef
		 */
		public function getBodyDefWithPosition(pos:Point):b2BodyDef
		{
			var bdef:b2BodyDef = new b2BodyDef();
			bdef.position.Set(pos.x / B2DConf.RATIO, pos.y / B2DConf.RATIO);
			
			return bdef;
		}
		
		/**
		 * Creates a box polygon shape of a given with and height 
		 * @param width:int
		 * @param height:int 
		 * @return b2PolygonShape
		 * @see Box2D.Collision.Shapes.b2PolygonShape
		 */
		public function getBoxPolygonShape(width:int, height:int):b2PolygonShape
		{
			var pol:b2PolygonShape = new b2PolygonShape();
			pol.SetAsBox( (width / 2) / B2DConf.RATIO, (height / 2) / B2DConf.RATIO );
			
			return pol;
		}
		
		/**
		 * Creates a fixture definition with the parameters specified. If you pass a shape object it will be attached
		 * to it. 
		 * @param density
		 * @param friction
		 * @param restitution
		 * @param shape
		 * @return b2FixtureDef
		 * @see Box2D.Dynamics.b2FixtureDef
		 */
		public function getFixtureDef(density:Number, friction:Number, restitution:Number, shape:b2PolygonShape = null):b2FixtureDef
		{
			var fix:b2FixtureDef = new b2FixtureDef();
			fix.density = density;
			fix.friction = friction;
			fix.restitution = restitution;
			
			if (shape != null) {
				fix.shape = shape;
			}
			
			return fix;
		}
		
		public function getBox(position:Point, width:int, height:int, fixture:b2FixtureDef):b2Body
		{
			var body:b2Body;
			var boxDef:b2BodyDef = getBodyDefWithPosition(position);
			var finalPos:Point = new Point();
			finalPos.x = (position.x + (width / 2));
			finalPos.y = (position.y + (height / 2));
			boxDef.position.Set(  finalPos.x / B2DConf.RATIO, finalPos.y / B2DConf.RATIO ); 
			var boxShape:b2PolygonShape = getBoxPolygonShape(width, height);
			fixture.shape = boxShape;
			body = _world.CreateBody(boxDef);
			body.CreateFixture(fixture);
			
			return body;
		}
	}
}

internal class Singleton{}