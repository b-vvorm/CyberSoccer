package org.cybersoccer.models
{
	public dynamic class Cell {
		
		private var _x:int = 0;
		private var _y:int = 0;
		
		private var _footballer_id:int = 0;
		private var _activeZone:uint = 0;
		private var _isBall:Boolean = false;
		
		public function Cell(x:int=0, y:int=0) {
			this._x = x;
			this._y = y;
		}
		
		public function toString():String {
			return "X: " + this._x
					+ "; Y: " + this._y
					+ "; Footballer: " + this._footballer_id
					+ "; ActiveZone: " + this._activeZone.toString(2);
					+ "; Is Ball: " + this._isBall;
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
		
		public function get footballer_id():int {
			return this._footballer_id;
		}
		
		public function set footballer_id(footballer_id:int):void {
			this._footballer_id = footballer_id; 
		}
		
		public function putFootballerActiveZone(id:int):void {
			this._activeZone = this._activeZone |(1<<(id-1));
		}
		
		public function removeFootballerActiveZone(id:int):void {
			this._activeZone = this._activeZone-(1<<(id-1));
		}
		
		public function isCellInActiveZone():Boolean {
			return this._activeZone > 0;
		}
		
		/**
		 * Return true if this cell is in active zone of footballer with id, otherwise return false.
		**/
		public function isCellInActiveZoneOfFootballer(id:int) {
			return (this._activeZone >> (id - 1)).toString(2) == "1";
		}
		
		/**
		 * Return first footballer id for this active zone cell.
		**/
		public function activeZoneFootballerId():int {
			for(var i:int=0; i<=10; i++) {
				if((this._activeZone >> (i)).toString(2) == "1") {
					return i + 1;
				}
			}
			return 0;
		}
		
		public function get isBall():Boolean {
			return this._isBall;
		}
		
		public function set isBall(isBall:Boolean):void {
			this._isBall = isBall;
		}

	}
}