package org.cybersoccer.events
{
	import flash.events.Event;

	public class NextFootballerEvent extends Event {
		
		public static const WAIT = "Wait";
		public static const STEP = "Step";
		
		public function NextFootballerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}
}