package org.cybersoccer.helpers
{
	import flash.geom.Point;
	
	import org.cybersoccer.models.Cell;
	import org.cybersoccer.models.Footballer;
	
	/**
	 * Used to implement all calc algorithms.
	**/  
	public class GameHelper {
		
		private var _matrix:Array = new Array();
		
		public function GameHelper(matrix:Array) {
			this._matrix = matrix;
		}
		
		/**
		 * Get footballer speed zone for footballer with/without ball.
		**/
		public function getSpeedZoneForFootballer(first:Point, speed:int, withBall:Boolean):Array {
			if(withBall) {
				return getSpeedZoneCells(first, speed, footballerWithBallFilter);
			} else {
				return getSpeedZoneCells(first, speed, footballerWithoutBallFilter);				
			}
		}
		
		/**
		 * Get footballer speed zone.
		**/
		public function getSpeedZoneCells(first:Point, speed:int, filter:Function):Array {
			initCellsFotSpeedZone();
			var speedZone:Array = new Array();
			var queue:Array = new Array();
			getCell(first).value = 1;
			queue.push(first);
			while(queue.length > 0) {
				var point:Point = queue.shift();				
				var cellValue = getCell(point).value;
				speedZone.push(point);
				if(cellValue == speed + 1) {
					continue;
				}				
				var neighbors:Array = getCellNeighbors(point);
				for(var i:int=0; i<neighbors.length; i++) {
					addCellToQueue(neighbors[i], cellValue, queue, filter);
				}
			}
			return speedZone;
		}
		
		/**
		 * Gets footballer path to target point.
		**/
		public function getPath(footballer:Footballer, target:Point):Array {
			getSpeedZoneForFootballer(new Point(footballer.x, footballer.y), footballer.speed, footballer.withBall > 0);
			var pathArray:Array = new Array();
			if(getCell(target).value == 0 || getCell(target).value == -2) {
				return pathArray;
			}
			pathArray.push(target);
			while(getCell(target).value != 2) {				
				var cellValue = getCell(target).value;
				var neighbors:Array = getCellNeighbors(target);
				for(var i:int=0; i<neighbors.length; i++) {
					if(getCell(neighbors[i]).value == cellValue - 1) {
						target = neighbors[i];
						pathArray.push(target);
						break;
					}
				}
			}
			return pathArray.reverse();
		}
		
		/**
		 * Gets cell neighbors.
		**/
		public function getCellNeighbors(point:Point):Array {
			var x:int = point.x;
			var y:int = point.y;
			var cells:Array = new Array();
			var dx:int = (1+Math.pow(-1, y%2))/2;
			if(validateCellRange(new Point(x-1, y)))      cells.push(new Point(x-1, y));
			if(validateCellRange(new Point(x+1, y)))      cells.push(new Point(x+1, y));
			if(validateCellRange(new Point(x+dx, y-1)))   cells.push(new Point(x+dx, y-1));
			if(validateCellRange(new Point(x+dx, y+1)))   cells.push(new Point(x+dx, y+1));
			if(validateCellRange(new Point(x-1+dx, y+1))) cells.push(new Point(x-1+dx, y+1));
			if(validateCellRange(new Point(x-1+dx, y-1))) cells.push(new Point(x-1+dx, y-1));
			return cells;
		}
		
		public function getNumberOfNeighborForPoint(neighbor:Point, point:Point):int {
			var x:int = point.x;
			var y:int = point.y;
			var nX:int = neighbor.x;
			var nY:int = neighbor.y;
			var dx:int = (1+Math.pow(-1, y%2))/2;
			if(nX == x-1 && nY == y && validateCellRange(new Point(x-1, y))){
				return 1;
			}else if(nX == x+1 && nY == y && validateCellRange(new Point(x+1, y))){
				return 2;	
			}else if(nX == x+dx && nY == y-1 && validateCellRange(new Point(x+dx, y-1))){
				return 3;
			}else if(nX == x+dx && nY == y+1 && validateCellRange(new Point(x+dx, y+1))){
				return 4;
			}else if(nX == x-1+dx && nY == y+1 && validateCellRange(new Point(x-1+dx, y+1))){
				return 5;
			}else if(nX == x-1+dx && nY == y-1 && validateCellRange(new Point(x-1+dx, y-1))){
				return 6;
			}else {
				return 0;
			}
		}
		
		/**
		 * Gets footballer neighbor point by it's number.
		**/
		public function getNeighborPoint(num:int, point:Point):Point {
			var x:int = point.x;
			var y:int = point.y;
			var dx:int = (1+Math.pow(-1, y%2))/2;
			if(num == 1 && validateCellRange(new Point(x-1, y))){
				return new Point(x-1, y);
			}else if(num == 2 && validateCellRange(new Point(x+1, y))){
				return new Point(x+1, y);	
			}else if(num == 3 && validateCellRange(new Point(x+dx, y-1))){
				return new Point(x+dx, y-1);
			}else if(num == 4 && validateCellRange(new Point(x+dx, y+1))){
				return new Point(x+dx, y+1);
			}else if(num == 5 && validateCellRange(new Point(x-1+dx, y+1))){
				return new Point(x-1+dx, y+1);
			}else if(num == 6 && validateCellRange(new Point(x-1+dx, y-1))){
				return new Point(x-1+dx, y-1);
			}else {
				return null;
			}
		}
		
		/**
		 * Gets ball path to target point.
		**/
		public function getBallPathToPoint(ballPoint:Point, targetPoint:Point):Array {
			var path:Array = new Array();
			if(!isPointsContainPoint(buildBallPath(ballPoint), targetPoint)) {
				return path;
			}
			var ballX:int = ballPoint.x;
			var ballY:int = ballPoint.y;
			var targetX:int = targetPoint.x;
			var targetY:int = targetPoint.y;
			if(ballX > targetX && ballY > targetY) {
				buildOneSideBallPath(ballPoint, path, -1,  1, 0);
			}
			if(ballX < targetX && ballY < targetY) {
				buildOneSideBallPath(ballPoint, path,  1, -1, 1);
			}
			if(ballX > targetX && ballY < targetY) {
				buildOneSideBallPath(ballPoint, path, -1, -1, 0);
			}
			if(ballX < targetX && ballY > targetY) {
				buildOneSideBallPath(ballPoint, path,  1,  1, 1);
			}
			if(ballX > targetX && ballY == targetY) {
				buildHorBeforeSideBallPath(ballPoint, path);
				path = path.reverse();
			}
			if(ballX < targetX && ballY == targetY) {
				buildHorAfterSideBallPath(ballPoint, path);
			}
			return path;
		}
		
		/**
		 * Build ball path cells array.
		**/ 
		public function buildBallPath(point:Point):Array {
			var x:int = point.x;
			var y:int = point.y;
			var pathPoints:Array = new Array();
			buildHorAfterSideBallPath(point, pathPoints);
			buildHorBeforeSideBallPath(point, pathPoints);
			var dx:int = (1+Math.pow(-1, y%2))/2;
			var d:int = dx;
			buildOneSideBallPath(point, pathPoints, -1,  1, 0);
			buildOneSideBallPath(point, pathPoints,  1, -1, 1);
			buildOneSideBallPath(point, pathPoints, -1, -1, 0);
			buildOneSideBallPath(point, pathPoints,  1,  1, 1);
			return pathPoints;
		}
		
		/**
		 * Build horisontal side of ball path before ball.
		**/
		private function buildHorBeforeSideBallPath(point:Point, pathPoints:Array):void {
			var x:int = point.x;
			var y:int = point.y;
			var i:int = 0;
			var rule:Boolean = false;
			while(validateCellRange(new Point(i, y)) && i < x){
				pathPoints.push(new Point(i, y));
				i++;
			}
		}
		
		/**
		 * Build horisontal side of ball path after ball.
		**/
		private function buildHorAfterSideBallPath(point:Point, pathPoints:Array):void {
			var x:int = point.x;
			var y:int = point.y;
			var i:int = x;
			var rule:Boolean = false;
			while(validateCellRange(new Point(i, y))){
				pathPoints.push(new Point(i, y));
				i++;
			}
		}
		
		/**
		 * Build one side ball path.
		**/
		private function buildOneSideBallPath(point:Point, pathPoints:Array, fX:int, fY:int, df:int):void {
			var x:int = point.x;
			var y:int = point.y;
			var i:int = 0;
			var dx:int = (1+Math.pow(-1, y%2))/2;
			var d:int = dx;
			while(validateCellRange(new Point(x - fX*(dx - d), y - fY*i))){
				pathPoints.push(new Point(x - fX*(dx - d), y - fY*i));
				i++;
				d = d + (1+Math.pow(-1, (y + df + i)%2))/2;
			}
		}
		
		/**
		 * Add cell to queue.
		**/
		private function addCellToQueue(point:Point, cellValue:int, queue:Array, filter:Function):void {
			var cell:Cell = getCell(point); 
			if(filter.apply(this, [cell.value])) {
				cell.value = cellValue + 1;
				queue.push(point);
			}
		}
		
		/**
		 * Filter footballer cells. 
		**/
		private function footballerWithBallFilter(value:int):Boolean {
			return value == 0 || value == -2;
		}
		
		/**
		 * Filter footballer ans ball cells. 
		**/
		private function footballerWithoutBallFilter(value:int):Boolean {
			return value == 0;
		}
		
		/**
		 * Init cells matrix to calculate speed zone.
		**/
		private function initCellsFotSpeedZone():void {
			this._matrix.forEach(function(cells:Array, index:int, array:Array){
				cells.forEach(function(cell:Cell, index:int, array:Array){
					if(cell.footballer_id > 0) {
						cell.value = -1;
					} else if(cell.isBall) {
						cell.value = -2;
					} else {
						cell.value = 0;
					}
				})
			})			
		}
		
		/**
		 * Validate cell on range.
		**/
		private function validateCellRange(point:Point):Boolean {
			return  point.x >= 0 &&
					point.y >= 0 &&
					point.x < ConfigHelper.GAME_AREA_WIDTH &&
					point.y < ConfigHelper.GAME_AREA_HEIGHT;
		}
		
		/**
		 * Gets cell by coordinate.
		**/ 
		private function getCell(point:Point):Cell {
			return this._matrix[point.y][point.x] as Cell;
		}
		
		/**
		 * Return true if point contains in points array, otherwise return false.
		**/
		public function isPointsContainPoint(points:Array, point:Point) {
			var x:int = point.x;
			var y:int = point.y;
			for(var i:int = 0; i < points.length; i++) {
				var selectedPoint:Point = points[i] as Point; 
				if(selectedPoint.x == x && selectedPoint.y == y) {
					return true;
				}
			}
			return false;
		}
	}
}