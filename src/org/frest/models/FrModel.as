/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: FrModel.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.models
{
	import flash.utils.getQualifiedClassName;
	
	import mx.managers.CursorManager;
	
	import org.frest.Fr;

	[Bindable]
	/**
	 * base model model properties to perform rest 
	 * @author Goutam
	 * 
	 */
	public class FrModel
	{
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
		protected var showMessage:Boolean=true;
		[Ignored]
		protected var fieldsToUpdate:Array=[];

		[Ignored]
		protected var result:Object;

		public function FrModel(label:String="id")
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
				default:
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
		public function show(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="show";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.show(this,onSuccess,onFailure);
		}
		[Ignored]
		public function create(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="create";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.create(this,onSuccess,onFailure);
		}
		[Ignored]
		public function update(onSuccess:Function=null,onFailure:Function=null):void
		{
			if(!changed)
			{
				return;
			}
			changed=false;
			currentAction="update";
			//Fr.crudCollection.addTransaction(this);
			//FrUtils.enableApplication=false;
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.update(this,onSuccess,onFailure);
		}
		[Ignored]
		public function directUpdate(onSuccess:Function=null,onFailure:Function=null):void
		{
			if(fieldsToUpdate.length<=0)
			{
				CursorManager.removeBusyCursor();
				Fr.crudTransactionQueue.stop();
				throw new Error("directUpdateArray is blank!->");
			}
			currentAction="directupdate";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.update(this,onSuccess,onFailure);
		}
		[Ignored]
		public function destroy(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="destroy";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.destroy(this,onSuccess,onFailure);
		}
		[Ignored]
		public function reload(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="reload";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.reload(this,onSuccess,onFailure);
		}
		[Ignored]
		public function search(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="search";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.search(this,onSuccess,onFailure);
		}
		[Ignored]
		public function action(actionName:String,onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction=actionName;
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.action(actionName,this,onSuccess,onFailure);
		}
		[Ignored]
		public function list(onSuccess:Function=null,onFailure:Function=null):void
		{
			currentAction="list";
			onSuccess=onSuccess==null?this.onSuccess:onSuccess;
			onFailure=onFailure==null?this.onFailure:onFailure;
			Fr.models.list(this,onSuccess,onFailure);
		}
		[Ignored]
		protected function cannotUse():void
		{
			throw new Error("This method is unavailable for this model!!");
		}
		/*
		public function index(optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			Fr.models.show(this,onSuccess,onFailure);
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