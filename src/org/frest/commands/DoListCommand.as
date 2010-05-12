/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: DoListCommand.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import org.frest.Fr;
	import org.frest.delegates.GenericDelegate;
	import org.frest.utils.FrUtils;

	/**
	 * used to capture cairmgrom events dispatched from model
	 * perform list (index)
	 * extened from GenericCommand
	 * @author Goutam
	 * 
	 */
	public class DoListCommand extends GenericCommand
	{
		public function DoListCommand()
		{
			super();
		}
		public var onSuccess:Function = function (event:Object):void{}
		public var onFailure:Function = function (event:Object):void{}
		private var action:String="";
		private var model:Object="";
		public override function execute(event:CairngormEvent):void
		{
			if(event.data is Object)
			{
				if(event.data.hasOwnProperty("onSuccess")) onSuccess = event.data["onSuccess"];
				if(event.data.hasOwnProperty("onFailure")) onFailure = event.data["onFailure"];
				if(event.data.hasOwnProperty("model")) model = event.data["model"];
			}
			var delegate :GenericDelegate = new GenericDelegate(this);
			delegate.list(FrUtils.getRestURL(model,"index"),Fr.serializer.marshall(model));
		}
		public override function result(data:Object):void
		{
			if(onSuccess!=null)
			{
				onSuccess.call(this,data);
			}
		}
		
		public override function fault(info:Object):void
		{
			if(onFailure!=null)
			{
				onFailure.call(this,info);
			}
		}
	}
}