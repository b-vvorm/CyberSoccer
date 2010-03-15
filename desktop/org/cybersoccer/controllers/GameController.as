package org.cybersoccer.controllers
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.cybersoccer.actions.IGameAction;
	import org.cybersoccer.events.CellMouseEvent;
	import org.cybersoccer.helpers.ActionsHelper;
	import org.cybersoccer.helpers.ConfigHelper;
	import org.cybersoccer.helpers.GameHelper;
	import org.cybersoccer.helpers.ParseHelper;
	import org.cybersoccer.helpers.ViewHelper;
	import org.cybersoccer.models.Cell;
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.models.Team;
	import org.cybersoccer.models.Ball;
	import org.cybersoccer.views.GameArea;
	
	/**
	 * Used to controll game process.
	**/
	public class GameController {
		
		private const FOOTBALLER:String = "FOOTBALLER";
		private const BALL:String = "BALL";
		private const FIRST_TEAM = "manutd";
		private const SECOND_TEAM = "chelsea";
		private const INIT_TEAMS = "INIT TEAMS";
		private const GAME = "GAME";
		
		/*Helpers*/
		private var _viewHelper:ViewHelper;
		private var _gameHelper:GameHelper;
		private var _actionsHelper:ActionsHelper;
		
		/*Models*/
		private var _matrix:Array = new Array();
		private var _footballers:Array = new Array();
		private var _ball:Ball;
		
		/*Helpfull objects*/
		private var _activeFootballer:Footballer;
		private var _directStack:Array = new Array();
		private var _reverseStack:Array = new Array();
		private var _currentAction:IGameAction;
		private var _currentObject:String = FOOTBALLER;
		private var _stage:String;
		
		/*For singleton*/
		private static var _instance:GameController = null;
		private static var _allowCallConstructor:Boolean = false;
		
		/**
		 * Get instance of game controller.
		**/
		public static function getInstance():GameController {
			if(_instance == null) {
				_allowCallConstructor = true;
				_instance = new GameController();
				_allowCallConstructor = false;
	        }
	        return _instance;
	    }
		
		public function GameController() {
			if(!_allowCallConstructor) {
	            throw new Error("Use getInstance() method instead");
	        }
	        initTeamsStage();
			initCellsMatrix();
			this._viewHelper = new ViewHelper(this._matrix);
			this._gameHelper = new GameHelper(this._matrix);
			this._actionsHelper = new ActionsHelper(this._matrix);
			GameArea.getInstance().addEventListener(CellMouseEvent.CLICK, cellMouseClickHandler);
			Team.loadByName(FIRST_TEAM, placeFirstTeam);
		}
		
		/**
		 * Cell mouse click handler.
		**/
		private function cellMouseClickHandler(event:CellMouseEvent):void {
			if(event.mouseEvent.altKey) {
				var cell:Cell = getCell(event.point);
				trace(cell.toString());	
			} else if(this._currentObject == FOOTBALLER){
				cellMouseClickFootballerHandler(event);
			} else if(this._currentObject == BALL){
				cellMouseClickBallHandler(event);
			}
		}
		
		/**
		 * Cell mouse click handler for footballer.
		**/
		private function cellMouseClickFootballerHandler(event:CellMouseEvent):void {
			if(this._stage == this.INIT_TEAMS){
				this._currentAction = this._actionsHelper.buildPlaceFootballerAction(this._activeFootballer, event.point);
				this._currentAction.execute();
			} else if(this._stage == this.GAME) {
				this._currentAction = this._actionsHelper.buildMoveFootballerToCellAction(this._activeFootballer, event.point);
				this._currentAction.execute();
			}
		}
		
		/**
		 * Cell mouse click handler for ball.
		**/
		private function cellMouseClickBallHandler(event:CellMouseEvent):void {
			var targetPoint:Point = event.point;
			if(this._activeFootballer.withBall && getCell(targetPoint).isCellInActiveZoneOfFootballer(this._activeFootballer.id)) {
				this._currentAction = this._actionsHelper.buildMoveBallToActiveZoneCell(targetPoint);
				this._currentAction.execute();				
			} else if(this._activeFootballer.withBall) {
				this._currentAction = this._actionsHelper.buildMoveBallToCell(this._ball, targetPoint);
				this._currentAction.execute();
			}
		}
		
		/**
		 * Build ball in cell.
		**/
		public function buildBall():void {
			var point:Point = new Point(this._ball.x, this._ball.y);
			this._ball.x = point.x;
			this._ball.y = point.y;
			getCell(point).isBall = true;
			this._viewHelper.buildBall(point);
		}
		
		/**
		 * Destroy ball.
		**/
		public function destroyBall():void {
			var point:Point = new Point(this._ball.x, this._ball.y);
			getCell(point).isBall = false;
			this._viewHelper.destroyBall(point);
		}
		
		/**
		 * Move ball to footballer activa zone.
		**/
		public function moveBallToActiveZone(point:Point):void {
			this._viewHelper.destroyBallPath(new Point(this._ball.x, this._ball.y));
			destroyBall();
			this._ball.x = point.x;
			this._ball.y = point.y;
			var footballerPoint:Point = new Point(this._activeFootballer.x, this._activeFootballer.y);
			this._activeFootballer.withBall = this._gameHelper.getNumberOfNeighborForPoint(point, footballerPoint);
			this._viewHelper.activateFootballer(this._activeFootballer);
			buildBall();
			this._viewHelper.buildBallPath(new Point(this._ball.x, this._ball.y));
		}
		
		/**
		 * Move ball cell.
		**/
		public function moveBallToCell(point:Point):void {
			destroyBall();
			this._ball.x = point.x;
			this._ball.y = point.y;
			var footballerPoint:Point = new Point(this._activeFootballer.x, this._activeFootballer.y);
			this._activeFootballer.withBall = this._gameHelper.getNumberOfNeighborForPoint(point, footballerPoint);
			buildBall();
			if(getCell(point).isCellInActiveZone() && !getCell(point).isCellInActiveZoneOfFootballer(this._activeFootballer.id)) {
				this._currentAction.stop();
				var footballer:Footballer = getFootballerById(getCell(point).activeZoneFootballerId());
				footballerPoint = new Point(footballer.x, footballer.y);
				footballer.withBall = this._gameHelper.getNumberOfNeighborForPoint(point, footballerPoint);
			}
		}
		
		/**
		 * Move active footballer to cell. 
		 * @param point target point.
		 * 
		 */		
		public function moveActiveFootballerToCell(point:Point):void {
			destroyFootballer(this._activeFootballer);
			this._activeFootballer.x = point.x;
			this._activeFootballer.y = point.y;
			if(this._activeFootballer.actualSpeed > 0) {
				this._activeFootballer.actualSpeed--;				
			}
			activateFootballer(this._activeFootballer);
		}
		
		/**
		 * Build footballer.
		**/
		public function buildFootballer(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			getCell(point).footballer_id = footballer.id;
			buildActiveZone(footballer);
			this._viewHelper.buildFootballer(footballer);
			if(footballer.withBall > 0) {
				var buildPoint:Point = this._gameHelper.getNeighborPoint(footballer.withBall, point);
				this._ball.x = buildPoint.x;
				this._ball.y = buildPoint.y;
				buildBall();
				if(lossBall(buildPoint)) {
					this._currentAction.stop();
				}
			}
		}
		
		/**
		 * Activate footballer.
		**/
		public function activateFootballer(footballer:Footballer):void {
			buildFootballer(footballer);
			this._viewHelper.activateFootballer(footballer);
		}
		
		/**
		 * Activate current footballer.
		**/
		public function activateCurrentFootballer():void {
			activateFootballer(this._activeFootballer);
		}
		
		/**
		 * Destroy footballer.
		**/
		public function destroyFootballer(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			getCell(point).footballer_id = 0;
			destroyActiveZone(footballer);
			if(footballer.withBall > 0) {
				destroyBall();
			}
			this._viewHelper.destroyFootballer(footballer);
		}
		
		/**
		 * Deactivate footballer.
		**/
		public function deactivateFootballer(footballer:Footballer):void {
			this._viewHelper.deactivateFootballer(footballer);
		}
		
		/**
		 * Next footballer step handler.
		**/
		public function nextFootballerStepHandler():void {
			if(_directStack.length > 0) {
				changeActiveFootballer();
			} else if(_directStack.length == 0 && _reverseStack.length > 0) {
				changeActiveFootballer();
				//waitButton.visible = false;
			} else {
				_directStack = this._footballers.slice();
				if(this._stage == GAME) {
					this._directStack.forEach(function(footballer:Footballer, index:int, array:Array) {	
						footballer.actualSpeed = footballer.speed;
					});
				}
				changeActiveFootballer();
				//waitButton.visible = true;
			}
		}
		
		/**
		 * Next footballer wait handler.
		**/
		public function nextFootballerWaitHandler():void {
			if(_directStack.length > 0) {
				_reverseStack.push(this._activeFootballer);
				changeActiveFootballer();
			} else {
				//waitButton.visible = false;
			}
		}
		
		/**
		 * Switch between footballer wait handler.
		**/
		public function switchBallFootballerHandler():void {
			if(this._currentObject == FOOTBALLER && this._activeFootballer.withBall > 0) {
				this._currentObject = BALL;
				this._viewHelper.buildBallPath(new Point(this._ball.x, this._ball.y));
			} else if(this._currentObject == BALL) {
				this._currentObject = FOOTBALLER;
				this._viewHelper.destroyBallPath(new Point(this._ball.x, this._ball.y));
				this._viewHelper.activateFootballer(this._activeFootballer);
			}
		}
		
		/**
		 * Change active footballer.
		**/
		private function changeActiveFootballer():void {
			if(this._activeFootballer) {
				deactivateFootballer(this._activeFootballer);
			}
			if(_directStack.length > 0) {
				this._activeFootballer = _directStack.pop();
			} else if(_reverseStack.length > 0) {
				this._activeFootballer = _reverseStack.pop();
			}
			activateFootballer(this._activeFootballer);
		}
		
		/**
		 * Build game area matrix.
		**/ 
		private function initCellsMatrix():void {
			for(var y:int = 0; y < ConfigHelper.GAME_AREA_HEIGHT; y++) {
				var line:Array = new Array();
				for(var x:int = 0; x < ConfigHelper.GAME_AREA_WIDTH; x++) {
					line[x] = new Cell(x, y);
				}
				this._matrix[y]=line;
			}
		}
		
		/**
		 * Build footbaler active zone.
		**/
		private function buildActiveZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getCellNeighbors(point);
			for(var i:int = 0; i < points.length; i++) {
				if(!footballer.withBall && getCell(points[i]).isBall) {
					if(takeBall(getCell(points[i]))) {
						this._currentAction.stop();
						footballer.withBall = i+1;
					}
				}
				getCell(points[i]).putFootballerActiveZone(footballer.id);
			}
		}
		
		/**
		 * Return true if active footballer loss a ball, othrwise return true. 
		 * @param cell cell with ball. 
		 * @return true if active footballer loss a ball, othrwise return true.
		 * 
		 */
		private function lossBall(point:Point):Boolean {
			var cell:Cell = getCell(point);
			var conflictedFootballers:Array = cell.getFootballerIds().map(function(id:int, index:int, arr:Array) {return getFootballerById(id)});
			if(conflictedFootballers.length < 2) {
				return false;
			}
			for each(var footballer:Footballer in conflictedFootballers) {
				if(this._activeFootballer.id != footballer.id && this._activeFootballer.technical < footballer.fight) {
					this._activeFootballer.withBall = 0;
					footballer.withBall = this._gameHelper.getNumberOfNeighborForPoint(cell.toPoint(), footballer.point);
					return true;
				}
			}
			return false;
		}

		/**
		 * Return true if active footballer can take a ball, otherwice retrun false.
		**/
		private function takeBall(cell:Cell):Boolean {
			if(!cell.isCellInActiveZone()) {
				return true;
			} else {
				var conflictedFootballers:Array = cell.getFootballerIds().map(function(id:int, index:int, arr:Array) {return getFootballerById(id)});
				for each(var footballer:Footballer in conflictedFootballers) {
					if(this._activeFootballer.id != footballer.id && this._activeFootballer.fight > footballer.fight) {
						footballer.withBall = 0;
						return true;							
					}
				}
				return false;
			}
		}
			
		/**
		 * Destroy footballer active zone.
		**/
		private function destroyActiveZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = this._gameHelper.getCellNeighbors(point);
			for(var i:int = 0; i < points.length; i++) {
				getCell(points[i]).removeFootballerActiveZone(footballer.id);
			}
		}
		
		/**
		 * Gets cell by coordinate.
		**/ 
		private function getCell(point:Point):Cell {
			return this._matrix[point.y][point.x] as Cell;
		}
		
		/**
		 * Gets footballer by id.
		**/
		private function getFootballerById(id:int):Footballer {
			for(var i:int=0; i<this._footballers.length; i++) {
				if(this._footballers[i].id == id) {
					return this._footballers[i];
				}
			}
			return null;
		}
		
		/**
		 * Init ball on game area.
		**/
		private function initBall():void {
			this._ball = new Ball();
			this._ball.x = 15;
			this._ball.y = 10;
			buildBall();
		}
		
		/**
		 * Init teams.
		**/
		private function initGame():void {
//			for(var i:int=0; i<5; i++) {
//				var footballer:Footballer = new Footballer();
//				footballer.x = i*3 + 6;
//				footballer.y = i*3 + 5;
//				footballer.id = i+1;
//				footballer.speed = 10;
//				footballer.actualSpeed = 10;
//				this._footballers.push(footballer);
//				buildFootballer(footballer);
//			}
			
			initBall();
			this._directStack = this._footballers.slice();
			this._activeFootballer = this._directStack.pop();
			activateFootballer(this._activeFootballer);
		}
		
		/** 
		 * Start game.
		 */		
		private function startGame():void {
			for each(var footballer:Footballer in this._footballers) {
				footballer.actualSpeed = footballer.speed;
			}
			this._directStack = this._footballers.slice();
			this._activeFootballer = this._directStack.pop();
			activateFootballer(this._activeFootballer);						
		}
		
		/**
		 * Place first team on the left side of game area.
		 */		
		private function placeFirstTeam(e:Event):void {
			var team:Team = ParseHelper.parseTeam(new XML(e.target.data));
			var x:int = 2;
			var y:int = 2;
			var id:int = 1;
			for each(var footballer:Footballer in team.footballers) {
				footballer.x = x;
				footballer.y = y;
				footballer.id = id;
				footballer.actualSpeed = 0;
				y = y + 4;
				id = id + 1;
				this._footballers.push(footballer);
				buildFootballer(footballer);
			}
			Team.loadByName(SECOND_TEAM, placeSecondTeam);
		}
		
		/**
		 * Place second team on the right side of game area.
		 */				
		private function placeSecondTeam(e:Event):void {
			var team:Team = ParseHelper.parseTeam(new XML(e.target.data));
			var x:int = ConfigHelper.GAME_AREA_WIDTH - 3;
			var y:int = ConfigHelper.GAME_AREA_HEIGHT - 3;
			var id = 6;
			for each(var footballer:Footballer in team.footballers) {
				footballer.x = x;
				footballer.y = y;
				footballer.id = id;
				footballer.actualSpeed = 0;
				y = y - 4;
				id = id + 1;
				this._footballers.push(footballer);
				buildFootballer(footballer);
			}
			initGame();
		}
		
		/**
		 * Set game stage to "init teams".
		 */
		public function initTeamsStage():void {
			this._stage = INIT_TEAMS;
		}
		
		/** 
		 * Set game stage to "game".
		 */		
		public function game():void {
			this._stage = GAME;
			startGame();
		}
		
	}
}