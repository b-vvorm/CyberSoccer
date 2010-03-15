package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.MatchController;
	
	/**
	 * Move footballer to one step.
	**/ 
	public class MoveFootballerToOneStep implements IGameAction {
		
		private var _point:Point;
		
		public function MoveFootballerToOneStep(point:Point) {
			this._point = point;
		}

		public function execute():void {
			MatchController.getInstance().moveFootballer(this._point);
			MatchController.getInstance().moveBall(this._point);
			MatchController.getInstance().lossBall();
			MatchController.getInstance().robBall();
		}
		
		public function stop():void {
		}
		
	}
}