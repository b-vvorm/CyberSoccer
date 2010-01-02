package org.cybersoccer.actions
{
	import flash.geom.Point;
	
	import org.cybersoccer.controllers.GameController;
	import org.cybersoccer.helpers.ViewHelper;
	import org.cybersoccer.models.Footballer;
	
	/**
	 * Move footballer to one step.
	**/ 
	public class MoveFootballerToOneStep implements IGameAction {
		
		private var _footballer:Footballer;
		private var _point:Point;
		
		public function MoveFootballerToOneStep(footballer:Footballer, point:Point) {
			this._footballer = footballer;
			this._point = point;
		}

		public function execute():void {
			GameController.getInstance().destroyFootballer(this._footballer);
			this._footballer.x = this._point.x;
			this._footballer.y = this._point.y;
			this._footballer.actualSpeed--;
			GameController.getInstance().activateFootballer(this._footballer);
		}
		
		public function stop():void {
		}
		
	}
}