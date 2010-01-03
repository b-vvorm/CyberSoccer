package org.cybersoccer.helpers
{
	import flash.geom.Point;
	
	import org.cybersoccer.models.Cell;
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.views.GameArea;
	
	/**
	 * Used to present helpers methods to modify views.
	 **/
	public class ViewHelper {
		
		private var _matrix:Array;
		private var _gameHelper:GameHelper;
		
		public function ViewHelper(matrix:Array) {
			this._matrix = matrix;
			this._gameHelper = new GameHelper(this._matrix);
		}
		
		/**
		 * Build footballer.
		**/
		public function buildFootballer(footballer:Footballer):void {
			if(footballer.id <= 5) {
				GameArea.getInstance().drawFirstTeamFootballer(new Point(footballer.x, footballer.y));				
			} else {
				GameArea.getInstance().drawSecondTeamFootballer(new Point(footballer.x, footballer.y));
			}
			buildActiveZone(footballer);
		}
		
		/**
		 * Destroy footballer.
		**/
		public function destroyFootballer(footballer:Footballer):void {
			destroySpeedZone(footballer);
			destroyActiveZone(footballer);
			GameArea.getInstance().erseFootballer(new Point(footballer.x, footballer.y));
			repairCells([new Point(footballer.x, footballer.y)]);
		}
		
		/**
		 * Repair cells.
		**/
		public function repairCells(points:Array) {
			var filteredPoints:Array = filterPoints(points, validateCellForRepairActiveZone);
			for each(var point:Point in filteredPoints) {
				if(getCell(point).activeZoneFootballerId() <= 5) {
					GameArea.getInstance().drawFirstTeamActiveZone([point]);
				} else {
					GameArea.getInstance().drawSecondTeamActiveZone([point]);
				}
			}
			filteredPoints = filterPoints(points, validateCellForRepairBall);			
			if(filteredPoints.length >= 1) {
				GameArea.getInstance().drawBall(filteredPoints[0]);
			}
			filteredPoints = filterPoints(points, validateCellForRepairFootballer);
			for each(point in filteredPoints) {	
				if(getCell(point).footballer_id <= 5) {
					GameArea.getInstance().drawFirstTeamFootballer(point);
				} else {
					GameArea.getInstance().drawSecondTeamFootballer(point);
				}
			}
		}
		
		/**
		 * Deactivate footballer.
		**/
		public function deactivateFootballer(footballer:Footballer):void {
			destroySpeedZone(footballer);
			buildFootballer(footballer);
		}
		
		/**
		 * Activate footballer.
		**/
		public function activateFootballer(footballer:Footballer):void {
			buildSpeedZone(footballer);
			buildFootballer(footballer);
		}
		
		/**
		 * Build ball.
		**/
		public function buildBall(point:Point) {
			GameArea.getInstance().drawBall(point);
		}
		
		/**
		 * Destroy ball.
		**/
		public function destroyBall(point:Point) {
			GameArea.getInstance().erseBall(point);
			repairCells([point]);
		}
		
		/**
		 * Build ball path.
		**/ 
		public function buildBallPath(point:Point) {
			GameArea.getInstance().drawBallPath(this._gameHelper.buildBallPath(point));			
		}
		
		/**
		 * Destroy ball path.
		**/ 
		public function destroyBallPath(point:Point) {
			var pathPoints:Array = this._gameHelper.buildBallPath(point);
			GameArea.getInstance().erseBallPath(pathPoints);
			repairCells(pathPoints);
		}
		
		/**
		 * Destroy speed zone.
		**/
		private function destroySpeedZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getSpeedZoneForFootballer(point, footballer.actualSpeed, footballer.withBall > 0);
			GameArea.getInstance().erseSpeedZone(filterPoints(points, validateCellForSpeedZone));
		}
		
		/**
		 * Destroy footballer active zone.
		**/
		private function destroyActiveZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getCellNeighbors(point);
			GameArea.getInstance().erseActiveZone(filterPoints(points, validateCellForActiveZone));
			repairCells(points);
		}
		
		/**
		 * Build footballer speed zone.
		**/
		private function buildSpeedZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getSpeedZoneForFootballer(point, footballer.actualSpeed, footballer.withBall > 0);
			GameArea.getInstance().drawSpeedZone(filterPoints(points, validateCellForSpeedZone));
		}
		
		/**
		 * Build footballer active zone.
		**/
		private function buildActiveZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getCellNeighbors(point);
			if(footballer.id <= 5) {
				GameArea.getInstance().drawFirstTeamActiveZone(filterPoints(points, validateCellForActiveZone));
			} else {
				GameArea.getInstance().drawSecondTeamActiveZone(filterPoints(points, validateCellForActiveZone));
			}
		}
		
		/**
		 * Filter points array.
		**/
		private function filterPoints(points:Array, validateFunction:Function):Array {
			var result:Array = new Array();
			for(var i:int=0; i<points.length; i++) {
				if(validateFunction.apply(this, [points[i]])) {
					result.push(points[i]);
				}
			}
			return result;
		}
		
		/**
		 * Validate cells to repair active zone.
		**/
		private function validateCellForRepairActiveZone(point:Point):Boolean {
			return getCell(point).isCellInActiveZone() && getCell(point).footballer_id == 0;
		}
		
		/**
		 * Validate cell to repair ball.
		**/
		private function validateCellForRepairBall(point:Point):Boolean {
			return getCell(point).isBall && getCell(point).footballer_id == 0;
		}
		
		/**
		 * Validate cell to repair footballer. 
		**/
		private function validateCellForRepairFootballer(point:Point):Boolean {
			return getCell(point).footballer_id > 0;
		}
		
		/**
		 * Validate cell to draw in active zone.
		**/
		private function validateCellForActiveZone(point:Point):Boolean {
			return getCell(point).footballer_id == 0 
				&& !getCell(point).isBall;
		}
		
		/**
		 * Validate cell to draw in speed zone.
		**/
		private function validateCellForSpeedZone(point:Point):Boolean {
			return !getCell(point).isCellInActiveZone()
				&& getCell(point).footballer_id == 0
				&& !getCell(point).isBall;
		}
		
		/**
		 * Gets cell by coordinate.
		**/ 
		private function getCell(point:Point):Cell {
			return this._matrix[point.y][point.x] as Cell;
		}
	}
}