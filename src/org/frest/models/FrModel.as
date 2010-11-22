/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrModel.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.models
{
	import flash.net.FileReference;
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	
	import mx.managers.CursorManager;
	
	import org.frest.Fr;
	import org.osmf.traits.IDisposable;

	[Bindable]
	/**
	 * base model model properties to perform rest 
	 * @author SoftInsure
	 * 
	 */
	public class FrModel implements IDisposable
	{
		public function dispose():void
		{
			belongsto=null;
			fieldsToUpdate=null;
			result=null;
		}
		private var lbl:String;

		/**
		 * all models have an id. this is typically unique per class of models
		 */
		[Ignored]
		public var id:int=0;
		[ReadOnly]
		public var session_data:String="";
		private var belongsto:FrModel;
		[Ignored]
		public var error:Boolean=false;
		[Ignored]
		public var loggedout:Boolean=false;
		[Ignored]
		public var sessionexpired:Boolean=false;
		[Ignored]
		public var httpSendMethod:String="GET";
		[Ignored]
		/**
		 * used to stop unmarshaling if required.  by default true 
		 */
		public var doUnmarshall:Boolean=true;
		[Ignored]
		/**
		 * true if any validation error
		 */
		public var validationerror:Boolean=false;
		[Ignored]
		public var message:String="";
		[Ignored]
		public var currentAction:String="";
		[Ignored]
		public var serverError:XML;
		[Ignored]
		public var changed:Boolean=false;
		[Ignored]
		public var useBelongsToPath:Boolean=false;
		[Ignored]
		public var toBeDeleted:Boolean=false;
		[Ignored]
		public var showMessage:Boolean=true;
		[Ignored]
		protected var fieldsToUpdate:Array=[];
		[Ignored]
		protected var canUseBaseCRUDMethods:Boolean=true;

		[Ignored]
		protected var result:Object;

/*		[Ignored]
		public var attachedFile:FileReference;

*/		public function FrModel(label:String="id")
		{
			lbl=label;
		}
		[Ignored]
		public function set belongsTo(model:FrModel):void
		{
			belongsto=model;
		}
		[Ignored]
		public function get internalKey():String
		{
			return getQualifiedClassName(this)+"::"+this.id;
		} 
		[Ignored]
		public function get belongsTo():FrModel
		{
			return belongsto;
		}
		[Ignored]
		public function get hasBelongsTo():Boolean
		{
			return belongsto!=null;
		}
		[Ignored]
		public function performCRUD(transaction:String):void
		{
			switch(transaction.toLowerCase())//do a lowercase
			{
				case "create":
					this.create();
					changed=false;
					break;
				case "directupdate":
					this.directUpdate();
					changed=false;
					break;
				case "update":
					this.update();
					changed=false;
					break;
				case "delete":
					this.destroy();
					changed=false;
					break;
				case "read":
				case "show":
					this.show();
					break;
				case "clone":
					this.action("clone");
					break;
/*				case "attach":
					this.attach();
					break;
*/				default:
					cannotUse();
					break;
			}
		}
		[Ignored]
		public function addFieldsForDirectUpdate(fieldsToUpdateArray:Array):void
		{
			fieldsToUpdate=fieldsToUpdateArray;
		}
		[Ignored]
		public function get directUpdateArray():Array
		{
			return fieldsToUpdate;
		}
		[Ignored]
		public function show(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="show";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.show(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function create(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="create";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.create(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function update(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="update";
			checkCannotUse();
			if(!changed)
			{
				return;
			}
			changed=false;
			//Fr.crudCollection.addTransaction(this);
			//FrUtils.enableApplication=false;
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.update(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function directUpdate(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="directupdate";
			checkCannotUse();
			if(fieldsToUpdate.length<=0)
			{
				CursorManager.removeBusyCursor();
				Fr.crudTransactionQueue.stop();
				throw new Error("directUpdateArray is blank!->");
			}
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.update(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function destroy(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="destroy";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.destroy(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function reload(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="reload";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.reload(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function search(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="search";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.search(this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function action(actionName:String,onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction=actionName;
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.action(actionName,this,onSuccessDo,onFailureDo);
		}
		[Ignored]
		public function list(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="list";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.list(this,onSuccessDo,onFailureDo);
		}
		/*
		[Ignored]
		public function attach(onSuccessDo:Function=null,onFailureDo:Function=null):void
		{
			currentAction="attach";
			checkCannotUse();
			onSuccessDo=onSuccessDo==null?this.onSuccessDo:onSuccessDo;
			onFailureDo=onFailureDo==null?this.onFailureDo:onFailureDo;
			Fr.models.attach(attachedFile,this,onSuccessDo,onFailureDo);
		}
		*/
		[Ignored]
		private function checkCannotUse():void
		{
			if(!canUseBaseCRUDMethods)
			{
				cannotUse();
			}
		}
		[Ignored]
		protected function cannotUse():void
		{
			throw new Error("Method::"+currentAction+" is unavailable for model :"+getQualifiedClassName(this).toString());
		}
		/*
		public function index(optsOronSuccessDo:Object=null, onFailureDo:Function=null):void
		{
			Fr.models.show(this,onSuccessDo,onFailureDo);
		}
		*/
		[Ignored]
		protected function onFailure(event:Object):void
		{
			Fr.crudTransactionQueue.stop();
			//enableApplication();
			error=true;
			message=event.toString();
			CursorManager.removeBusyCursor();
//			Fr.crudCollection.crudError=error;
		}
		[Ignored]
		public var beforeNextTransaction:Function = function (event:Object):void{};
		[Ignored]
		protected function ifNextTransaction(event:Object):void
		{
			if(error)
			{
				Fr.crudTransactionQueue.stop();
			}
			else
			{
				beforeNextTransaction.call(this,event);
				Fr.crudTransactionQueue.doNextTransaction();
			}
		}
		[Ignored]
		private function onFailureDo(event:Object):void
		{
			onFailure(event);
			clearObject(event)
		}
		[Ignored]
		private function onSuccessDo(event:Object):void
		{
			onSuccess(event);
			clearObject(event)
		}
		[Ignored]
		private function clearObject(event:Object):void
		{
			event=null;
		}
		[Ignored]
		protected function onSuccess(event:Object):void
		{
			//Fr.crudCollection.removeTransaction(this);
			//enableApplication();
			error=false;
			serverError=null;
			message="";
			//var result : Object = event.result;
			result = event.result;
			if (result == "badlogin")
			{
				error=true;
			}
			else if (result == "loggedout")
			{
				loggedout=true;
			}
			else if (result == "sessionexpired")
			{
				sessionexpired=true;
			}
			else if (result == "error")
			{
				error=true;
				message="There was an error. Please try again later!";
			}
			else if(result is XML)
			{
				var resultXML : XML = XML(result);
				error=false;
				if(resultXML.hasOwnProperty("name"))
				{
					if(resultXML.name().localName == "errors")
					{
						error=true;
						validationerror=true;
						serverError=resultXML;
					}
				}
				if(resultXML.hasOwnProperty("error"))
				{
					error=true;
					message=String(resultXML.error);
					validationerror=true;
					serverError=resultXML;
				}
				if(!error && doUnmarshall)
				{
					Fr.serializer.unmarshall(resultXML,this);
				}
			}
//			Fr.crudCollection.crudError=error;
			if(currentAction=='directupdate')
			{
				this.fieldsToUpdate=[];
			}
			CursorManager.removeBusyCursor();
			ifNextTransaction(event);
		}
		[Ignored]
		public function toString():String
		{
			return this["id"] == null ? lbl+"_0" : lbl+"_"+this.id.toString();
		}
	}
}