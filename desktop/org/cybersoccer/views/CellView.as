package org.cybersoccer.views
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.cybersoccer.events.CellMouseEvent;
	import org.cybersoccer.helpers.DrawHelper;

	public class CellView extends MovieClip {
		
		private var _xPos:int;
		private var _yPos:int;
		
		public function CellView(xPos:int, yPos:int) {
			DrawHelper.drawEmptyCell(this.graphics);
			this._xPos = xPos;
			this._yPos = yPos;
			addEventListener(MouseEvent.CLICK, onMouseClickHandler);
		}
		
		private function onMouseClickHandler(event:MouseEvent) {
			this.parent.dispatchEvent(new CellMouseEvent(new Point(this._xPos, this._yPos), event));
		}
		
		public function toEmptyCell():void {
			this.graphics.clear();
			DrawHelper.drawEmptyCell(this.graphics);
		}
		
		public function toFirstTeamActiveZone():void {
			this.graphics.clear();
			DrawHelper.drawFirstTeamActiveZone(this.graphics);
		}
		
		public function toSecondTeamActiveZobe():void {
			this.graphics.clear();
			DrawHelper.drawSecondTeamActiveZone(this.graphics);
		}
		
		public function toFirstTeamFootballer():void {
			this.graphics.clear();
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawFirstTeamFootballer(this.graphics);
		}
		
		public function toSecondTeamFootballer():void {
			this.graphics.clear();
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawSecondTeamFootballer(this.graphics);
		}
		
		public function toFirstTeamActiveFootballer():void {
			this.graphics.clear();
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawFirstTeamActiveFootballer(this.graphics);
		}
		
		public function toSpeedCell():void {
			this.graphics.clear();
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawSpeedCell(this.graphics);
		} 
		
		public function toBall():void {
			this.graphics.clear();
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawBall(this.graphics);
		}
		
		public function toBallPath():void {
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DrawHelper.drawBallPath(this.graphics);
		}
		
	}
}