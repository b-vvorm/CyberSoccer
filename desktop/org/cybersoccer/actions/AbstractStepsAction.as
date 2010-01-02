package org.cybersoccer.actions
{
	/**
	 * Common action for steps based actions.
	**/
	public class AbstractStepsAction implements IGameAction {
		
		private var _steps:Array = new Array();
		private var _isStop:Boolean = false;
		
		public function AbstractStepsAction()
		{
			//TODO: implement function
		}

		/**
		 * Add one step action to steps array.
		**/ 
		public function addOneStepAction(action:IGameAction):void {
			this._steps.push(action);
		}
		
		/**
		 * Remove one step action from steps array.
		**/ 
		public function removeOneStepAction(action:MoveFootballerToOneStep):void {
			this._steps[this._steps.indexOf(action)] = null;
		}
		
		/**
		 * Pop one step action from steps array.
		**/ 
		public function popOneStepAction():void {
			this._steps.pop();
		}

		public function execute():void {
			for(var i:int=0; i<this._steps.length; i++) {
				if(!this._isStop) {
					this._steps[i].execute();					
				}
			}
		}
		
		public function stop():void {
			this._isStop = true;
		}
		
	}
}