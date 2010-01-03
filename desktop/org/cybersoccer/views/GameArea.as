package org.cybersoccer.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.cybersoccer.helpers.ConfigHelper;
	import org.cybersoccer.helpers.DrawHelper;


	/**
	 * Used to represent game area model.
	 **/
	public class GameArea extends MovieClip {
		
		private var _cells:Array = new Array();		
		private static var _instance:GameArea = null;
		private static var _allowCallConstructor:Boolean = false;

	    public function GameArea() {
	        if(!_allowCallConstructor) {
	            throw new Error("Use getInstance() method instead");
	        }
	        buildCellsMatrix();
	    }

		/**
		 * Get instance of game area.
		**/
		public static function getInstance():GameArea {
			if(_instance == null) {
				_allowCallConstructor = true;
				_instance = new GameArea();
				_allowCallConstructor = false;
	        }
	        return _instance;
	    }
		
		/**
		 * Draw active zone for footballer from first team.
		 * @param points active zone points.
		 **/
		public function drawFirstTeamActiveZone(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toFirstTeamActiveZone();
			}
		}
				
		/**
		 * Draw active zone for footballer from second team.
		 * @param points active zone points.
		 */		
		public function drawSecondTeamActiveZone(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toSecondTeamActiveZobe();
			}
		}
		
		/**
		 * Erse footballer active zone.
		 **/
		public function erseActiveZone(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toEmptyCell();
			}
		}
		
		/**
		 * Erse footballer active zone.
		 **/
		public function erseSpeedZone(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toEmptyCell();
			}
		}
		
		/**
		 * Erse footballer.
		 **/
		public function erseFootballer(point:Point):void {
			getCell(point).toEmptyCell();
		}
		
		/**
		 * Draw first team footballer.
		 **/
		public function drawFirstTeamFootballer(point:Point):void {
			getCell(point).toFirstTeamFootballer();
		}
		
		/**
		 * Draw second team footballer.
		 **/
		public function drawSecondTeamFootballer(point:Point):void {
			getCell(point).toSecondTeamFootballer();
		}
		
		/**
		 * Draw footballer speed zone.
		 **/
		public function drawSpeedZone(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toSpeedCell();
			}
		}		
		
		/**
		 * Draw ball.
		**/
		public function drawBall(point:Point):void {
			getCell(point).toBall();
		}
		
		/**
		 * Erse ball.
		**/
		public function erseBall(point:Point):void {
			getCell(point).toEmptyCell();
		}
		
		/**
		 * Draw ball path.
		**/ 
		public function drawBallPath(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toBallPath();
			}
		} 
		
		/**
		 * Erse ball path.
		**/ 
		public function erseBallPath(points:Array):void {
			for(var i:int=0; i<points.length; i++) {
				getCell(points[i]).toEmptyCell();
			}
		}
		
		/**
		 * Draw marking.
		**/
		public function drawMarking():void {
			var radius:Number = ConfigHelper.CELL_RADIUS;
			var dX:Number = Math.sqrt(0.75)*radius/2;
			var dY:Number = radius/2;
			var w:int = this.width - dX*2;
			var h:int = this.height - dY*2;
			var gates_width:int = dY*4*6;
			
			DrawHelper.drawGreenRectangle(this.graphics, this.width, this.height);
			
			//Border.
			DrawHelper.drawHorizontalWhiteLine(this.graphics, dX*3, dY, w - dX*2);
			DrawHelper.drawVerticalWhiteLine(this.graphics, dX*3, dY, h);
			DrawHelper.drawHorizontalWhiteLine(this.graphics, dX*3, h, w - dX*2);
			DrawHelper.drawVerticalWhiteLine(this.graphics, w, dY, h);
			
			//Gates.
			DrawHelper.drawVerticalWhiteLine(this.graphics, dX*3 - 10, dY*4*5, gates_width);
			DrawHelper.drawVerticalWhiteLine(this.graphics, w+10, dY*4*5, gates_width);
			
			//Center.
			DrawHelper.drawVerticalWhiteLine(this.graphics, w/2 + dX + 5, dY, h);			
			DrawHelper.drawWhiteCir(this.graphics, w/2 + dX + 10, h/2 + 10, 10);
			DrawHelper.drawWhiteCir(this.graphics, w/2 + dX + 10, h/2 + 10, w/10);
		}
		
		/**
		 * Gets cell views array.
		 **/
		public function get cells():Array {
			return this._cells;
		}		
		
		/**
		 * Build game area matrix.
		**/ 
		private function buildCellsMatrix():void {
			var radius:Number = ConfigHelper.CELL_RADIUS;
			var dX:Number = Math.sqrt(0.75)*radius;
			var dY:Number = radius; 
			var firstType:Boolean = true;
			for(var y:Number = 0; y < ConfigHelper.GAME_AREA_HEIGHT; y++) {
				var line:Array = new Array();
				for(var x:Number = 0; x < ConfigHelper.GAME_AREA_WIDTH; x++) {
					var cell:CellView = new CellView(x, y);
					if(firstType) {
						cell.x = x*2*dX + dX + dX;
					} else {
						cell.x = x*2*dX + dX;
					}
					cell.y = radius*y*1.5 + dY;
					line[x] = cell;
					addChild(cell);
				}
				this._cells[y] = line;
				firstType = !firstType;
			}
		}
		
		/**
		 * Get cell by coordinate
		**/
		private function getCell(point:Point):CellView {
			return this._cells[point.y][point.x];			
		}
	}
}