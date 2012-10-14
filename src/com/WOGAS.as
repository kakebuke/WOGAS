package com
{
	import Box2D.Collision.b2AABB;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.globalization.Collator;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	public class WOGAS extends Sprite
	{
		private var deltaTime:int;
		private var updatables:Vector.<UpdatableElement>;
		
		public static var ground:MovieClip;
		public static var windSpeed:int = 50;
		
		public function WOGAS()
		{
			updatables = new Vector.<UpdatableElement>();
			
			//addChild(ground = _getHitLayer());
			addChild(ground = new Ground());
			ground.y = stage.stageHeight - ground.height;
			
			var ball:Ball = new Ball(300);
			ball.x = 30;
			ball.y = 30;
			
			addChild(ball);
			updatables.push(ball);
			
			deltaTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, update);
			
			stage.addEventListener(MouseEvent.CLICK, testHit);
		}
		
		protected function testHit(event:MouseEvent):void
		{
			var p:Point = new Point(mouseX, mouseY);
			trace("CLICKED ON " + p.toString() + " hit: " + ground.hitTestPoint(p.x, p.y));
		}
		
		/**
		 * Main game loop 
		 * @param event
		 */
		protected function update(event:Event):void
		{
			var elapsed:int = getTimer() - deltaTime;
			deltaTime = getTimer();
			
			for each (var updatable:UpdatableElement in updatables) {
				updatable.update(elapsed / 1000);
			}
		}
		
		private function _getHitLayer():Sprite
		{
			var s:Sprite = new Sprite();
			
			s.graphics.beginFill(0x000000);
			s.graphics.moveTo(0, stage.stageHeight / 3);
			s.graphics.lineTo(stage.stageWidth, stage.stageHeight / 1.8);
			s.graphics.lineTo(stage.stageWidth, stage.stageHeight);
			s.graphics.lineTo(0, stage.stageHeight);
			s.graphics.lineTo(0, stage.stageHeight / 3);
			s.graphics.endFill();
	
			/*s.graphics.beginFill(0x000000);
			s.graphics.drawRect(0, stage.stageHeight / 2, stage.stageWidth, stage.stageHeight / 2);
			s.graphics.endFill();*/
			return s;
		}
	}
}