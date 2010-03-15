package org.cybersoccer.actions
{
	import org.cybersoccer.controllers.GameController;
	import org.cybersoccer.controllers.MatchController;
	
	/**
	 * Move ball to cell action.
	**/
	public class MoveBallToCellAction extends AbstractStepsAction {
		
		public function MoveBallToCellAction() {
		}
		
		override public function execute():void {
			MatchController.getInstance().switchBallFootballerHandler();
			super.execute();
		}
		
	}
}