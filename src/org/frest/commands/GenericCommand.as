/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: GenericCommand.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	
	public class GenericCommand implements ICommand, IResponder
	{
		public function GenericCommand(){}
		public function execute(event:CairngormEvent):void{}
		public function result(data:Object):void{}
		public function fault(info:Object):void{}
	}
}