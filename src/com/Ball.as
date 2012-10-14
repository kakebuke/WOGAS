package com
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Ball extends Sprite implements UpdatableElement
	{
		public const DIRECTION_RIGHT:int = 1;
		public const DIRECTION_LEFT:int = 2;
		public const DIRECTION_UP:int = 3;
		public const DIRECTION_DOWN:int = 4;
		public const DIRECTION_NONE:int = 0;
		
		
		private var _speed:int; // pixels per second
		private var _direction:int;
		private var _updatable:Boolean;
		
		public function Ball(speed:int = 100, direction:int = DIRECTION_NONE)
		{
			super();
			_speed = speed;
			_direction = direction;
			
			_createBall();
			
			_updatable = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		protected function stopDragging(event:MouseEvent):void
		{
			_updatable = true;
			stopDrag();
		}
		
		protected function startDragging(event:MouseEvent):void
		{
			_updatable = false;
			startDrag(true);
		}		
		
		
		private function _createBall():void
		{
			graphics.beginFill(0xff0000);
			graphics.drawCircle(0,0,10);
			graphics.endFill();
		}
		
		public function update(deltaTime:Number):void
		{
			if (!_updatable) return;
			
			if (!WOGAS.ground.hitTestPoint(bottom.x, bottom.y+1, true)) {
				moveVert(deltaTime);
			} else {
				if (!WOGAS.ground.hitTestPoint(bottom.x + (_speed * deltaTime), bottom.y, true)) {
					moveSide(deltaTime, 1);
				} else { // add comprovacion
					moveSide(deltaTime, -1);
				}
				moveVert(deltaTime);
			}
		}
		
		private function moveSide(deltaTime:Number, dir:int):void
		{
			var newp:Point = new Point(dir * _speed * deltaTime, y); 
			if (canMoveX(newp)) {
				moveX(newp);
			}
		}
		
		private function moveVert(deltaTime:Number):void
		{
			var newp:Point = new Point(x, _speed * deltaTime); 
			if (canMoveY(newp)) {
				moveY(newp);
			} else {
				while (!WOGAS.ground.hitTestPoint(bottom.x, bottom.y+1, true)) {
					y++;
				}
			}
		}
		
		private function canMoveX(newp:Point):Boolean
		{
			return (x + newp.x) > 0 && (x + newp.x) < stage.stageWidth && !WOGAS.ground.hitTestPoint(bottom.x + newp.x, bottom.y, true);
		}
		
		private function moveX(newp:Point):void
		{
			x += newp.x;
		}
		
		private function canMoveY(newp:Point):Boolean
		{
			return (y + newp.y) > 0 && (y + newp.y) < stage.stageHeight && !WOGAS.ground.hitTestPoint(bottom.x, bottom.y + newp.y, true);
		}
		
		private function moveY(newp:Point):void
		{
			y += newp.y;			
		}
		
		public function get bounds():Rectangle
		{
			return getBounds(stage);
		}
		
		public function get bottom():Point
		{
			return new Point(bounds.bottomRight.x - width / 2, bounds.bottomRight.y);
		}
	}
}