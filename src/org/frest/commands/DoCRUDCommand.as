/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: DoCRUDCommand.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	
	import org.frest.Fr;
	import org.frest.delegates.GenericDelegate;
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;

	/**
	 * used to capture cairmgrom events dispatched from model
	 * perform CRUD
	 * extened from GenericCommand
	 * @author SoftInsure
	 * 
	 */
	public class DoCRUDCommand extends GenericCommand
	{
		private var action:String="";
		private var model:Object="";
		private var updArray:Array=[];
		private var sendmethod:String="GET";

		public function DoCRUDCommand()
		{
			super();
		}
		public override function execute(event:CairngormEvent):void
		{
			if(event.data is Object)
			{
				if(event.data.hasOwnProperty("action")) action = event.data["action"];
				if(event.data.hasOwnProperty("onSuccess")) onSuccess = event.data["onSuccess"];
				if(event.data.hasOwnProperty("onFailure")) onFailure = event.data["onFailure"];
				if(event.data.hasOwnProperty("model")) model = event.data["model"];
				if(model !=null && model is FrModel)
				{
					var frmodel:FrModel=(model as FrModel);
					updArray=frmodel.directUpdateArray;
					sendmethod=frmodel.httpSendMethod;
				}
			}
			performCRUD();
		}
		private function  performCRUD():void
		{
			var url:String=FrUtils.getRestURL(model,action)
			var delegate :GenericDelegate = new GenericDelegate(this);
			switch(action.toLowerCase())
        	{
        		case "create":
        			delegate.create(url,Fr.serializer.marshall(model));
        			break;
        		case "update":
					delegate.update(url,Fr.serializer.toUpdateObject(model));
        			break;
				case "directupdate":
					if(updArray.length>0)//something there to update
					{
						delegate.update(url,Fr.serializer.toDirectFieldsUpdateObject(model,updArray));
					}
					else
					{
						CursorManager.removeBusyCursor();						
						throw new Error("directUpdateArray is blank!->");
					}
					break;
        		case "destroy":
        			delegate.destroy(url);
        			break;
        		case "index":
        			delegate.index(url);
        			break;
         		case "show":
        			delegate.show(url);
        			break;
				default:
					if(sendmethod=="POST")
					{
						delegate.otherspost(url,Fr.serializer.marshall(model));
					}
					else
					{
						delegate.others(url);
					}
					break;
        	}
		}
		public override function result(data:Object):void
		{
			if(onSuccess!=null)
			{
				onSuccess.call(this,data);
			}
			else
			{
				throw new Error("Missing onSuccess function in child!->");
				CursorManager.removeBusyCursor();
			}
		}
		public override function fault(info:Object):void
		{
			if(onFailure!=null)
			{
				onFailure.call(this,info);
			}
			else
			{
				throw new Error("Missing onfailure function in child!->"+ObjectUtil.toString(info));
				CursorManager.removeBusyCursor();
			}
		}
	}
}