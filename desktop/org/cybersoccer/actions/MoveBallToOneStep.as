package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.MatchController;
	
	/**
	 * Move ball to one step action.
	**/
	public class MoveBallToOneStep implements IGameAction {
		
		private var _point:Point;
		
		public function MoveBallToOneStep(point:Point) {
			this._point = point;
		}

		public function execute():void {
			MatchController.getInstance().hitBall(this._point);
			MatchController.getInstance().takeBall();
			MatchController.getInstance().goal();
		}
		
		public function stop():void {
			//TODO: implement function
		}
		
	}
}