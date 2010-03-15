package org.cybersoccer.controllers
{
	import flash.geom.Point;
	
	/**
	 * Used to define init game api.
	 * 
	 */
	public interface IInitController {
		
		/**
		 * Place both team at the game area. 
		 * 
		 */
		function placeTeams():void
		
		/**
		 * Move active footballer to cell. 
		 * @param cell target cell.
		 * 
		 */
		function placeFootballerToCell(point:Point):void
		
	}
}