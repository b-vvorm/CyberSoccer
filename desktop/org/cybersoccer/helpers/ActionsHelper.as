package org.cybersoccer.helpers
{
	import flash.geom.Point;
	
	import org.cybersoccer.actions.MoveBallToActiveZoneAction;
	import org.cybersoccer.actions.MoveBallToCellAction;
	import org.cybersoccer.actions.MoveBallToOneStep;
	import org.cybersoccer.actions.MoveFootballerToCellAction;
	import org.cybersoccer.actions.MoveFootballerToOneStep;
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.views.Ball;
	
	/**
	 * Used to present methods to build any game actions.
	**/ 
	public class ActionsHelper {
		
		private var _matrix:Array;
		private var _gameHelper:GameHelper;
		
		public function ActionsHelper(matrix:Array) {
			this._matrix = matrix;
			this._gameHelper = new GameHelper(matrix);
		}

		/**
		 * Build move footballer to cell action.
		**/ 
		public function buildMoveFootballerToCellAction(footballer:Footballer, point:Point):MoveFootballerToCellAction {
			var action:MoveFootballerToCellAction = new MoveFootballerToCellAction();
			var pathPoints:Array = this._gameHelper.getPath(footballer, point);
			if(footballer.actualSpeed == 0) {
				return action;
			}
			for(var i:int=0; i<pathPoints.length; i++) {
				action.addOneStepAction(new MoveFootballerToOneStep(footballer, pathPoints[i]));				
			}
			return action;
		}
		
		/**
		 * Build action to move ball to footballer active zone.
		**/
		public function buildMoveBallToActiveZoneCell(point:Point):MoveBallToActiveZoneAction {
			return new MoveBallToActiveZoneAction(point);
		}
		
		/**
		 * Build move ball to cell.
		**/
		public function buildMoveBallToCell(ball:Ball, point:Point):MoveBallToCellAction {
			var action:MoveBallToCellAction = new MoveBallToCellAction();
			var pathPoints:Array = this._gameHelper.getBallPathToPoint(new Point(ball.x, ball.y), point);
			for(var i:int=0; i < pathPoints.length; i++) {
				action.addOneStepAction(new MoveBallToOneStep(pathPoints[i]));
			}
			return action;
		}
		
		/**
		 * Build action to place footballer in point during teams initialization stage.
		 * @param footballer footballer.
		 * @param point target point.
		 * @return action.
		 */		
		public function buildPlaceFootballerAction(footballer:Footballer, point:Point):MoveFootballerToOneStep {
			var x:int = point.x;
			var y:int = point.y;
			if(footballer.isFirstTeam() && x <= ConfigHelper.GAME_AREA_WIDTH/2) {
				return new MoveFootballerToOneStep(footballer, point);
			} else if(!footballer.isFirstTeam() && x >= ConfigHelper.GAME_AREA_WIDTH/2) {
				return new MoveFootballerToOneStep(footballer, point);
			} else {
				return new MoveFootballerToOneStep(footballer, new Point(footballer.x, footballer.y));
			}
		}

	}
}