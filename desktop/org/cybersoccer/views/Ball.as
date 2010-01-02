package org.cybersoccer.views
{
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

	}
}