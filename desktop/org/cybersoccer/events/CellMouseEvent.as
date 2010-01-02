package org.cybersoccer.events
{
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CellMouseEvent extends MouseEvent {
		
		private var _point:Point;
		private var _mouseEvent:MouseEvent;
		
		public static const CLICK:String = "Click";
		
		public function CellMouseEvent(point:Point, mouseEvent:MouseEvent, type:String=CLICK, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this._point = point;
			this._mouseEvent = mouseEvent;
		}
		
		public function get point():Point {
			return this._point;
		}
		
		public function get mouseEvent():MouseEvent {
			return this._mouseEvent;
		}
		
	}
}