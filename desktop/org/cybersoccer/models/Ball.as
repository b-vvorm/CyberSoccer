package org.cybersoccer.models
{
	import flash.geom.Point;
	
	public class Ball {
		
		private var _x:int;
		private var _y:int;
		
		public function Ball() {
		}
		
		public function get x():int {
			return this._x;
		}
		
		public function set x(x:int):void {
			this._x = x; 
		}
		
		public function get y():int {
			return this._y;
		}
		
		public function set y(y:int):void {
			this._y = y; 
		}
		
		public function get point():Point {
			return new Point(this._x, this._y);
		} 
		
		public function set point(point:Point):void {
			this._x = point.x;
			this._y = point.y;
		}

	}
}