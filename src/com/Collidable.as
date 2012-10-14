package com
{
	import flash.display.DisplayObject;

	public interface Collidable
	{
		function checkCollisions(obj:DisplayObject):Boolean
	}
}