package org.cybersoccer.helpers
{
	import flash.display.Graphics;
	
	public class DrawHelper {
		
		public function DrawHelper() {
		}
		
		public static function drawCell(g:Graphics, color:uint, borderColor:uint, borderWidth:int=1, alpha:Number=1, x:int=0, y:int=0) {
			var radius:Number = ConfigHelper.CELL_RADIUS;
			var xPoint:Number = Math.sqrt(0.75)*radius;
			var yPoint:Number = radius/2;
			var xStart:Number = x;
			var yStart:Number = y;
			g.beginFill(color, alpha);
			if(borderWidth > 0) {
				g.lineStyle(borderWidth, borderColor);
			} 
			g.moveTo(xStart, 		  yStart - radius);
			g.lineTo(xStart + xPoint, yStart - yPoint);
			g.lineTo(xStart + xPoint, yStart + yPoint);
			g.lineTo(xStart, 		  yStart + radius);
			g.lineTo(xStart - xPoint, yStart + yPoint);
			g.lineTo(xStart - xPoint, yStart - yPoint);
			g.lineTo(xStart,		  yStart - radius);
			g.endFill();
		}
		
		/**
		 * Draw rectangle.
		**/
		public static function drawRectangle(g:Graphics, x:int, y:int, width:int, height:int, color:uint) {
			g.beginFill(color);
			g.drawRect(x, y, width, height);
			g.endFill();
		}
		
		/**
		 * Draw circle.
		**/		
		public static function drawCir(g:Graphics, x:int, y:int, radius:int, thickness:int, color:uint) {
			//g.beginFill(color);
			g.lineStyle(thickness, color);
			g.drawCircle(x, y, radius);
			//g.endFill();
		}
		
		public static function drawEmptyCell(g:Graphics):void {
			drawCell(g, ConfigHelper.EMPTY_CELL_COLOR, ConfigHelper.EMPTY_CELL_BORDER_COLOR, 1, 0);
		}
		
		public static function drawSpeedCell(g:Graphics):void {
			drawCell(g, ConfigHelper.SPEED_CELL_COLOR, ConfigHelper.EMPTY_CELL_BORDER_COLOR, 1, 0.6);
		}
		
		public static function drawFirstTeamActiveZone(g:Graphics):void {
			drawEmptyCell(g);
			drawCell(g, ConfigHelper.FIRST_TEAM_FOREGROUND, ConfigHelper.FIRST_TEAM_FOREGROUND, 0, 0.6);
		}
		
		public static function drawSecondTeamActiveZone(g:Graphics):void {
			drawEmptyCell(g);
			drawCell(g, ConfigHelper.SECOND_TEAM_FOREGROUND, ConfigHelper.SECOND_TEAM_FOREGROUND, 0, 0.6);
		}
		
		public static function drawFirstTeamFootballer(g:Graphics):void {
			drawCell(g, ConfigHelper.FIRST_TEAM_FOREGROUND, ConfigHelper.FIRST_TEAM_BACKGROUND);
		}
		
		public static function drawSecondTeamFootballer(g:Graphics):void {
			drawCell(g, ConfigHelper.SECOND_TEAM_FOREGROUND, ConfigHelper.SECOND_TEAM_BACKGROUND);
		}
		
		public static function drawFirstTeamActiveFootballer(g:Graphics):void {
			drawCell(g, ConfigHelper.FIRST_TEAM_FOREGROUND, ConfigHelper.FIRST_TEAM_BACKGROUND);
		}
		
		public static function drawBall(g:Graphics):void {
			drawCell(g, ConfigHelper.BALL_COLOR, ConfigHelper.BALL_BACKGROUND_COLOR);
		}
		
		public static function drawBallPath(g:Graphics):void {
			drawCell(g, ConfigHelper.BALL_PATH_COLOR, ConfigHelper.BALL_PATH_BACKGROUND_COLOR, 1, 0.3);
		}
		
		/**
		 * Draw horizontal white line. 
		**/
		public static function drawHorizontalWhiteLine(g:Graphics, x:int, y:int, size):void {
			drawRectangle(g, x, y, size, 10, 0xFFFFFF);
		}
		
		/**
		 * Draw vertical white line. 
		**/
		public static function drawVerticalWhiteLine(g:Graphics, x:int, y:int, size):void {
			drawRectangle(g, x, y, 10, size, 0xFFFFFF);
		}
		
		public static function drawWhiteCir(g:Graphics, x:int, y:int, radius:int):void {
			drawCir(g, x, y, radius, 10, 0xFFFFFF);
		}
				
		public static function drawGreenRectangle(g:Graphics, width, height):void {
			drawRectangle(g, 0, 0, width, height, ConfigHelper.EMPTY_CELL_COLOR);
		}

	}
}