package com
{
	import Box2D.Dynamics.b2BodyDef;
	
	import flash.geom.Point;

	public class Utils
	{
		public function Utils()
		{
		}
		
		/**
		 * Receives a point in pixels and returns a body definition with the final
		 * position in Box2D coordinates 
		 * @param pos:Point center of the body
		 * @return b2BodyDef
		 * @see Box2D.Dynamics.b2BodyDef
		 */
		public static function getBoxBodyDef(pos:Point):b2BodyDef
		{
			var bdef:b2BodyDef = new b2BodyDef();
			bdef.position.Set(pos.x / B2DConf.RATIO, pos.y / B2DConf.RATIO);
			
			return bdef;
		}
	}
}