package org.cybersoccer.controllers
{
	import flash.geom.Point;
	
	import org.cybersoccer.actions.IGameAction;
	import org.cybersoccer.events.CellMouseEvent;
	import org.cybersoccer.helpers.ActionsHelper;
	import org.cybersoccer.helpers.ConfigHelper;
	import org.cybersoccer.helpers.GameHelper;
	import org.cybersoccer.helpers.ViewHelper;
	import org.cybersoccer.models.Ball;
	import org.cybersoccer.models.Cell;
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.views.GameArea;

	/**
	 * Used to implement base game api.
	 * 
	 */	
	public class BaseGameController implements IGameController {
		
		protected const FOOTBALLER:String = "FOOTBALLER";
		protected const BALL:String = "BALL";
		protected const INIT_TEAMS = "INIT TEAMS";
		protected const GAME = "GAME";
		
		/*For singleton*/
		private static var _instance:BaseGameController = null;
		protected static var _allowCallConstructor:Boolean = false;
		
		/*Helpers*/
		private var _viewHelper:ViewHelper;
		private var _gameHelper:GameHelper;
		private var _actionsHelper:ActionsHelper;
		
		/*Models*/
		private var _matrix:Array = new Array();
		private var _footballers:Array = new Array();
		private var _ball:Ball = new Ball();
		
		/*Helpfull objects*/
		private var _activeFootballer:Footballer;
		private var _directStack:Array = new Array();
		private var _reverseStack:Array = new Array();
		private var _currentObject:String = FOOTBALLER;
		private var _stage:String;
		private var _currentAction:IGameAction;
		
		public function BaseGameController() {
			if(!_allowCallConstructor) {
	            throw new Error("Use getInstance() method instead");
	        }
			initCellsMatrix();
			this._viewHelper = new ViewHelper(getMatrix());
			this._gameHelper = new GameHelper(getMatrix());
			this._actionsHelper = new ActionsHelper(getMatrix());
			GameArea.getInstance().addEventListener(CellMouseEvent.CLICK, cellMouseClickHandler);
		}

		public function nextFootballerStepHandler():void {
			if(this._directStack.length > 0) {
				changeActiveFootballer(getDirectStack());
			} else if(_directStack.length == 0 && _reverseStack.length > 0) {
				changeActiveFootballer(this._reverseStack);
				//TODO: implement wait button to be invisible.
			} else {
				setDirectStack(getFootballers().slice());
				this._directStack.forEach(function(footballer:Footballer, index:int, array:Array) {footballer.actualSpeed = footballer.speed;});
				changeActiveFootballer(getDirectStack());
				//TODO: implement wait button to be visible.
			}
		}
		
		public function nextFootballerWaitHandler():void {
			if(_directStack.length > 0) {
				this._reverseStack.push(getActiveFootballer());
				changeActiveFootballer(this._directStack);
			} else {
				//TODO: implement wait button to be invisible.
			}
		}
		
		public function switchBallFootballerHandler():void {
			if(this._currentObject == FOOTBALLER && getActiveFootballer().withBall > 0) {
				this._currentObject = BALL;
				getViewHelper().buildBallPath(new Point(getBall().x, getBall().y));
			} else if(this._currentObject == BALL) {
				this._currentObject = FOOTBALLER;
				getViewHelper().destroyBallPath(new Point(getBall().x, getBall().y));
				getViewHelper().activateFootballer(getActiveFootballer());
			}
		}
		
		public function startMatchHandler():void {
			initBall();
			setStage(GAME);
			for each(var footballer:Footballer in getFootballers()) {
				footballer.actualSpeed = footballer.speed;
			}
			setDirectStack(getFootballers().slice());
			setActiveFootballer(getDirectStack().pop());
			activateFootballer();				
		}
		
		public function cellMouseClickHandler(event:CellMouseEvent):void {
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
		 * 
		 */
		private function cellMouseClickFootballerHandler(event:CellMouseEvent):void {
			if(this._stage == this.INIT_TEAMS){
				setCurrentAction(getActionHelper().buildPlaceFootballerAction(getActiveFootballer(), event.point));
				getCurrentAction().execute();
			} else if(this._stage == this.GAME) {
				setCurrentAction(getActionHelper().buildMoveFootballerToCellAction(getActiveFootballer(), event.point));
				getCurrentAction().execute();
			}
		}
		
		/**
		 * Cell mouse click handler for ball.
		 * 
		 */
		private function cellMouseClickBallHandler(event:CellMouseEvent):void {
			var targetPoint:Point = event.point;
			if(getActiveFootballer().withBall && getCell(targetPoint).isCellInActiveZoneOfFootballer(getActiveFootballer().id)) {
				setCurrentAction(getActionHelper().buildMoveBallToActiveZoneCell(targetPoint));
				getCurrentAction().execute();				
			} else if(getActiveFootballer().withBall) {
				setCurrentAction(getActionHelper().buildMoveBallToCell(getBall(), targetPoint));
				getCurrentAction().execute();
			}
		}
		
		/**
		 * Init ball on game area.
		 * 
		 */
		private function initBall():void {
			getBall().point = new Point(15, 10);
			buildBall();
		}
		
		/**
		 * Init cells matrix. 
		 * 
		 */
		private function initCellsMatrix():void {
			for(var y:int = 0; y < ConfigHelper.GAME_AREA_HEIGHT; y++) {
				var line:Array = new Array();
				for(var x:int = 0; x < ConfigHelper.GAME_AREA_WIDTH; x++) {
					line[x] = new Cell(x, y);
				}
				getMatrix()[y]=line;
			}
		}
		
		/**
		 * Change active footballer. 
		 * @param stack currant fotballers stack.
		 * 
		 */
		private function changeActiveFootballer(stack:Array):void {
			if(getActiveFootballer()) {
				deactivateFootballer();
			}
			setActiveFootballer(stack.pop());
			activateFootballer();
		}
		
		/**
		 * Deactivate active footballer. 
		 * 
		 */
		private function deactivateFootballer():void {
			getViewHelper().deactivateFootballer(getActiveFootballer());
		}
		
		/**
		 * Activate first footballer from direct stack. 
		 * 
		 */
		protected function activateFirstFootballer():void {
			setActiveFootballer(getDirectStack().pop());
			activateFootballer();
		}
		
		/**
		 * Activate footballer.
		 * 
		 */
		protected function activateFootballer():void {
			buildFootballer(getActiveFootballer());
			getViewHelper().activateFootballer(getActiveFootballer());
		}
		
		/**
		 * Build footballer.
		**/
		protected function buildFootballer(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			getCell(point).footballer_id = footballer.id;
			buildActiveZone(footballer);
			getViewHelper().buildFootballer(footballer);
		}
		
		/**
		 * Build ball in cell.
		 * 
		 */
		protected function buildBall():void {
			getCell(getBall().point).isBall = true;
			getViewHelper().buildBall(getBall().point);
		}
		
		/**
		 * Destroy ball.
		 * 
		 */
		protected function destroyBall():void {
			getCell(getBall().point).isBall = false;
			this._viewHelper.destroyBall(getBall().point);
		}
		
		/**
		 * Destroy active footballer. 
		 * 
		 */
		protected function destroyFootballer():void {
			var point:Point = getActiveFootballer().point;
			getCell(point).footballer_id = 0;
			destroyActiveZone();
			this._viewHelper.destroyFootballer(getActiveFootballer());
		}
		
		/**
		 * Destroy footballer active zone.
		 * 
		 */
		private function destroyActiveZone():void {
			var point:Point = getActiveFootballer().point;
			var points:Array = this._gameHelper.getCellNeighbors(point);
			for(var i:int = 0; i < points.length; i++) {
				getCell(points[i]).removeFootballerActiveZone(getActiveFootballer().id);
			}
		}
		
		/**
		 * Build footbaler active zone.
		 * 
		 */
		private function buildActiveZone(footballer:Footballer):void {
			var point:Point = new Point(footballer.x, footballer.y);
			var points:Array = getGameHelper().getCellNeighbors(point);
			for(var i:int = 0; i < points.length; i++) {
				getCell(points[i]).putFootballerActiveZone(footballer.id);
			}
		}
		
		/**
		 * Gets cell by coordinate.
		 * 
		 */
		protected function getCell(point:Point):Cell {			
			return getMatrix()[point.y][point.x] as Cell;
		}
		
		/**
		 * Gets footballer by id. 
		 * @param id target footballer id.
		 * @return footballer.
		 * 
		 */
		protected function getFootballerById(id:int):Footballer {
			return getFootballers()[id - 1];
		}
		
		/*Helpers accessors start*/
		protected function getViewHelper():ViewHelper { return this._viewHelper; }
		protected function getGameHelper():GameHelper { return this._gameHelper; }
		protected function getActionHelper():ActionsHelper { return this._actionsHelper; }
		/*Helpers accessors end*/
		
		/*Models accessors start*/
		protected function getFootballers():Array { return this._footballers; }
		protected function addFootballer(footballer:Footballer):void { getFootballers().push(footballer); }
		protected function getMatrix():Array { return this._matrix; }
		protected function getBall():Ball { return this._ball; }
		/*Models accessors end*/
		
		/*Halpfull objects accessors start*/
		protected function getDirectStack():Array { return this._directStack; }
		protected function setDirectStack(footballers:Array):void { this._directStack = footballers; }
		protected function setStage(stage:String):void { this._stage = stage; }
		protected function getActiveFootballer():Footballer { return this._activeFootballer; }
		protected function setActiveFootballer(footballer:Footballer):void { this._activeFootballer = footballer; }
		protected function getCurrentAction():IGameAction { return this._currentAction; }
		protected function setCurrentAction(action:IGameAction):void { this._currentAction = action; }
		/*Halpfull objects accessors end*/
	}
}