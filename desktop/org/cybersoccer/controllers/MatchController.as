package org.cybersoccer.controllers
{
	import flash.geom.Point;
	
	import org.cybersoccer.models.Cell;
	import org.cybersoccer.models.Footballer;
	
	public class MatchController extends InitController implements IMatchController {
		
		/*For singleton*/
		private static var _instance:MatchController = null;
		
		/**
		 * Get instance of match controller.
		**/
		public static function getInstance():MatchController {
			if(_instance == null) {
				_allowCallConstructor = true;
				_instance = new MatchController();
				_allowCallConstructor = false;
	        }
	        return _instance;
	    }
		
		public function MatchController() {
			super();
		}
		
		public function moveFootballer(point:Point):void {
			destroyFootballer();
			getActiveFootballer().point = point;
			getActiveFootballer().decreaseActualSpeed();
			activateFootballer();
			
		}
		
		public function moveBall(point:Point):void {
			if(getActiveFootballer().withBall > 0) {
				destroyBall();
				getBall().point = getGameHelper().getNeighborPoint(getActiveFootballer().withBall, point);
				buildBall();
			}
		}
		
		public function robBall():void {
			if(getActiveFootballer().withBall > 0) return;
			var points:Array = getGameHelper().getCellNeighbors(getActiveFootballer().point);
			for(var i:int = 0; i < points.length; i++) {
				var cell:Cell = getCell(points[i]);
				var ids:Array = cell.getFootballerIds().filter(function(id:int, index:int, arr:Array){return id != getActiveFootballer().id;});
				if(cell.isBall) {
					if(ids.length > 0) {
						if(!takeUnfreeBall(ids)) return;
					}
					getCurrentAction().stop();
					getActiveFootballer().withBall = i + 1;
					return;
				}
			}
		}
		
		public function lossBall():void {
			if(getActiveFootballer().withBall == 0) return;
			var points:Array = getGameHelper().getCellNeighbors(getActiveFootballer().point);
			var cell:Cell = getCell(points[getActiveFootballer().withBall - 1]);
			var ids:Array = cell.getFootballerIds().filter(function(id:int, index:int, arr:Array){return id != getActiveFootballer().id;});
			for each(var id:int in ids) {
				var footballer:Footballer = getFootballerById(id);
				if(!tryToLossBall(footballer)) continue;
				detachBallFromFootballer(getActiveFootballer());
				getCurrentAction().stop();
				attachBallToFootballer(footballer);
			}
		}
		
		public function hitBall(point:Point):void {
			getActiveFootballer().withBall = 0;
			destroyBall();
			getBall().point = point;
			buildBall();
			activateFootballer();
		}
		
		public function takeBall():void {
			var cell:Cell = getCell(getBall().point);
			var ids:Array = cell.getFootballerIds().filter(function(id:int, index:int, arr:Array){return id != getActiveFootballer().id;});
			if(ids.length == 0) return;
			var footballer:Footballer = getFootballerById(ids[0]);
			attachBallToFootballer(footballer);
			getCurrentAction().stop();
		}
		
		public function moveBallToActiveZone(point:Point):void {
			getViewHelper().destroyBallPath(getBall().point);
			destroyBall();
			getBall().point = point;
			attachBallToFootballer(getActiveFootballer());
			buildBall();
			activateFootballer();
			getViewHelper().buildBallPath(getBall().point);
		}
		
		public function goal():void {
			var x:int = getBall().point.x;
			var y:int = getBall().point.y;
			if(x == 0 && y >= 7 && y <= 13) {
				getCurrentAction().stop();
				trace("Second team scored a goal");
			} else if(x == 30 && y >= 7 && y <= 13) {
				getCurrentAction().stop();
				trace("First team scored a goal");
			}
		}
		
		/**
		 * Take unfree ball. 
		 * @param ids ids of footballers who can have a ball.
		 * @return true if take ball success, otherwice false. 
		 * 
		 */
		private function takeUnfreeBall(ids:Array):Boolean {
			for each(var id:int in ids) {
				var footballer:Footballer = getFootballerById(id);
				if(footballer.withBall > 0) {
					if (!tryToTakeBall(footballer)) return false;
					detachBallFromFootballer(footballer);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Try to take ball. 
		 * @param footballer who can loss his ball.
		 * @return true if take ball success, otherwice false.
		 * 
		 */
		private function tryToTakeBall(footballer:Footballer):Boolean {
			return getActiveFootballer().fight > footballer.fight;
		}
		
		/**
		 * Try to loss ball. 
		 * @param footballer footballer who can take active footballer's ball.
		 * @return true if loss ball success, otherwice false.
		 * 
		 */
		private function tryToLossBall(footballer:Footballer):Boolean {
			return getActiveFootballer().technical < footballer.fight;
		}
		
		/**
		 * Attach ball to given footballer. 
		 * @param footballer given footballer.
		 * 
		 */
		private function attachBallToFootballer(footballer:Footballer):void {
			footballer.withBall = getGameHelper().getNumberOfNeighborForPoint(getBall().point, footballer.point);
		}
		
		/**
		 * Detach ball from given footballer. 
		 * @param footballer given footballer.
		 * 
		 */
		private function detachBallFromFootballer(footballer:Footballer):void {
			footballer.withBall = 0;
		}
		
	}
}