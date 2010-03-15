package org.cybersoccer.controllers
{
	import flash.geom.Point;
	
	/**
	 * Used to define match api.
	 * 
	 */
	public interface IMatchController {
		/**
		 * Move active footballer to point. 
		 * @param point target point.
		 * 
		 */
		function moveFootballer(point:Point):void;
		
		/**
		 * Move ball with footballer to point. 
		 * @param point target point.
		 * 
		 */		
		function moveBall(point:Point):void;
		
		/**
		 * Try to take a ball.
		 * 
		 */
		function takeBall():void;
		
		/**
		 * Try to loss a ball by active footballer.  
		 * 
		 */		
		function lossBall():void;
		
		/**
		 * Hit ball. 
		 * @param point target point.
		 * 
		 */
		function hitBall(point:Point):void;
		
		/**
		 * Try to rob a ball by active footballer.
		 * 
		 */
		function robBall():void;
		
		/**
		 * Test if goal happens. 
		 * 
		 */
		function goal():void;
		
		/**
		 * Move ball to footballer active zone. 
		 * @param point target point.
		 * 
		 */
		function moveBallToActiveZone(point:Point):void;
		
	}
}