package org.cybersoccer.actions
{
	public interface IGameAction {
		
		/**
		 * Execute game action.
		 **/ 
		function execute():void;
		
		/**
		 * Stoping game action.
		**/
		function stop():void;
		
	}
}