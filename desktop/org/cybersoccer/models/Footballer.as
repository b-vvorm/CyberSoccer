package org.cybersoccer.models {

	public class Footballer {

		//Personal info.
		private var _name:String;
		private var _number:int;
		
		//Skils on questions.
		private var _height:int;
		private var _weight:int;
		
		//Game scils.
		private var _speed:int;
		private var _technical:int;
		private var _fight:int;
		private var _power:int;
		
		//Game info.
		private var _x:int = 0;
		private var _y:int = 0;
		private var _id:int = 0;
		private var _actualSpeed:int;
		private var _withBall:int = 0;
		
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
		
		public function get id():int {
			return this._id;
		}
		
		public function set id(id:int):void {
			this._id = id; 
		}
		
		public function get name():String {
			return this._name;
		}
		
		public function set name(name:String):void {
			this._name = name;
		}
		
		public function get number():int {
			return this._number;
		}
		
		public function set number(number:int):void {
			this._number = number;
		}
		
		public function get height():int {
			return this._height;
		}
		
		public function set height(height:int):void {
			this._height = height;
		}
		
		public function get weight():int {
			return this._weight;
		}
		
		public function set weight(weight:int):void {
			this._weight = weight;
		}
		
		public function get speed():int {
			return this._speed;
		}
		
		public function set speed(speed:int):void {
			this._speed = speed;
		}
		
		public function get actualSpeed():int {
			return this._actualSpeed;
		}
		
		public function set actualSpeed(actualSpeed:int):void {
			this._actualSpeed = actualSpeed;
		}
		
		public function get technical():int {
			return this._technical;
		}
		
		public function set technical(technical:int):void {
			this._technical = technical;
		}
		
		public function get withBall():int {
			return this._withBall;
		}
		
		public function set withBall(withBall:int):void {
			this._withBall = withBall; 
		}
		
		public function get fight():int {
			return this._fight;
		}
		
		public function set fight(fight:int):void {
			this._fight = fight; 
		}
		
		public function get power():int {
			return this._power;
		}
		
		public function set power(power:int):void {
			this._power = power; 
		}
	
	}
}