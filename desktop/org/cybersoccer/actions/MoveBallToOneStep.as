package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.GameController;
	
	/**
	 * Move ball to one step action.
	**/
	public class MoveBallToOneStep implements IGameAction {
		
		private var _point:Point;
		
		public function MoveBallToOneStep(point:Point) {
			this._point = point;
		}

		public function execute():void {
			GameController.getInstance().moveBallToCell(this._point);
		}
		
		public function stop():void {
			//TODO: implement function
		}
		
	}
}