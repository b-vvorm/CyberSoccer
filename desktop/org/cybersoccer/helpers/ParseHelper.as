package org.cybersoccer.helpers
{
	import org.cybersoccer.models.Footballer;
	import org.cybersoccer.models.Team;
	
	public class ParseHelper {
		
		public function ParseHelper() {
		}
		
		/**
		 * Parse team from xml. 
		 * @param teamXML team on xml format.
		 * @return team instance.
		 */		
		public static function parseTeam(teamXML:XML):Team {
			var team:Team = new Team();
			team.name = teamXML.name;
			for each(var footballerXML:XML in teamXML.footballers.elements()) {
				var footballer:Footballer = new Footballer();
				footballer.name = footballerXML.name;
				footballer.number = footballerXML.number;
				footballer.speed = footballerXML.speed;
				footballer.technical = footballerXML.technical;
				footballer.fight = footballerXML.fight;
				footballer.power = footballerXML.power;
				team.pushFootballer(footballer);
			}
			return team;
		}

	}
}