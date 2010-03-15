package org.cybersoccer.controllers
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.cybersoccer.helpers.ConfigHelper;
	import org.cybersoccer.helpers.ParseHelper;
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.models.Team;

	public class InitController extends BaseGameController implements IInitController {
		
		private const FIRST_TEAM = "manutd";
		private const SECOND_TEAM = "chelsea";
		
		/*For singleton*/
		private static var _instance:InitController = null;
		
		/**
		 * Get instance of init controller.
		**/
		public static function getInstance():InitController {
			if(_instance == null) {
				_allowCallConstructor = true;
				_instance = new InitController();
				_allowCallConstructor = false;
	        }
	        return _instance;
	    }
	    
		public function placeTeams():void {
			Team.loadByName(FIRST_TEAM, placeFirstTeam);			
		}
		
		public function placeFootballerToCell(point:Point):void {
			destroyFootballer();
			getActiveFootballer().x = point.x;
			getActiveFootballer().y = point.y;
			activateFootballer();
		}
		
		public function InitController() {
			super();
			setStage(INIT_TEAMS);
		}
		
		/**
		 * Place second team on the left side of game area. 
		 * @param e event.
		 * 
		 */
		private function placeFirstTeam(e:Event):void {
			placeTeam(new XML(e.target.data), 2, 2, 1);
			Team.loadByName(SECOND_TEAM, placeSecondTeam);
		}
		
		/**
		 * Place second team on the right side of game area.
		 */				
		private function placeSecondTeam(e:Event):void {
			placeTeam(new XML(e.target.data), ConfigHelper.GAME_AREA_WIDTH - 3, 2, 6);
			setDirectStack(getFootballers().slice());
			activateFirstFootballer();
		}
		
		/**
		 * Place team on th game area. 
		 * @param xml team xml.
		 * @param x first x position.
		 * @param y first y position.
		 * @param id first footballer id.
		 * 
		 */
		private function placeTeam(xml:XML, x:int, y:int, id:int):void {
			var team:Team = ParseHelper.parseTeam(xml);
			for each(var footballer:Footballer in team.footballers) {
				placeFootballer(footballer, x, y, id);
				y = y + 4;
				id = id + 1;
			}
		}
		
		/**
		 * Place footballer on the game area.
		 * @param footbaler footballer to place. 
		 * @param x the x coordinate.
		 * @param y the y coordinate.
		 * @param id the footballer id.
		 * 
		 */
		private function placeFootballer(footballer:Footballer, x:int, y:int, id:int):void {
			footballer.x = x;
			footballer.y = y;
			footballer.id = id;
			footballer.actualSpeed = 0;
			addFootballer(footballer);
			buildFootballer(footballer);
		}
		
	}
}