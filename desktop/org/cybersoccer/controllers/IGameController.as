package org.cybersoccer.controllers
{
	import org.cybersoccer.events.CellMouseEvent;
	
	/**
	 * Used to define game api.
	 * 
	 */	
	public interface IGameController {
		
		/**
		 * Handle click to next footballer step button. 
		 * 
		 */
		function nextFootballerStepHandler():void;
		
		/**
		 * Handle click to wait footballer wait button. 
		 * 
		 */
		function nextFootballerWaitHandler():void;
		
		/**
		 * Handle click to switch footballer/ball button. 
		 * 
		 */
		function switchBallFootballerHandler():void;
		
		/**
		 * Handle click to start match handler.  
		 * 
		 */
		function startMatchHandler():void;
		
		/**
		 * Handle click to any cell of game area. 
		 * 
		 */
		function cellMouseClickHandler(event:CellMouseEvent):void;
		
	}
}