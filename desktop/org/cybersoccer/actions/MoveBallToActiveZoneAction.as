package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.MatchController;
	
	/**
	 * Move ball to footballer active zone cell.
	**/ 
	public class MoveBallToActiveZoneAction implements IGameAction
	{
		
		private var _point:Point;
		
		public function MoveBallToActiveZoneAction(point:Point) {
			this._point = point;
		}

		public function execute():void {
			MatchController.getInstance().moveBallToActiveZone(this._point);
		}
		
		public function stop():void {
			//TODO: implement function
		}
		
	}
}