package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.MatchController;

	public class PlaceFootballerToCell implements IGameAction {
		
		private var _point:Point;
		
		public function PlaceFootballerToCell(point:Point) {
			this._point = point;
		}

		public function execute():void {
			MatchController.getInstance().placeFootballerToCell(this._point);
		}
		
		public function stop():void {}
		
	}
}