package org.cybersoccer.models {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class Team {

		private var _name:String;
		private var _footballers:Array = new Array();
		
		public function get name():String {
			return this._name;
		}
		
		public function set name(name:String):void {
			this._name = name;
		}
		
		public function get footballers():Array {
			return this._footballers;
		}
		
		public function pushFootballer(footballer:Footballer):void {
			this._footballers.push(footballer);
		}
		
		/**
		 * Load team by name. 
		 * @param name team name.
		 * @param resultHandler result handler function.
		 * 
		 */		
		public static function loadByName(name:String, resultHandler:Function):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, resultHandler);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest("teams/"+name+".team"));
		}
	}

}