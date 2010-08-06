/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrEventController.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.controllers
{
	import com.adobe.cairngorm.control.FrontController;
	import org.frest.commands.DoCRUDCommand;
	import org.frest.commands.DoListCommand;
	import org.frest.commands.DoSearchCommand;
	import org.frest.events.FrEventNames;

	public class FrEventController extends FrontController
	{
		public function FrEventController()
		{
			initializeCommands()
		}
		private function initializeCommands():void
		{
			addCommand(FrEventNames.DO_SEARCH, DoSearchCommand);
			addCommand(FrEventNames.CRUD, DoCRUDCommand);
			addCommand(FrEventNames.DO_LIST, DoListCommand);
		}
	}
}