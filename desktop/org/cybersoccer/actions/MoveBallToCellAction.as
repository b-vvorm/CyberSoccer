package org.cybersoccer.actions
{
	import org.cybersoccer.controllers.GameController;
	
	/**
	 * Move ball to cell action.
	**/
	public class MoveBallToCellAction extends AbstractStepsAction {
		
		public function MoveBallToCellAction() {
		}
		
		override public function execute():void {
			GameController.getInstance().switchBallFootballerHandler();
			super.execute();
			GameController.getInstance().activateCurrentFootballer();
		}
		
	}
}