/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrModelsController.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.controllers
{
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.net.FileReference;
	import flash.utils.getDefinitionByName;
	
	import mx.managers.CursorManager;
	
	import org.frest.collections.FrCollection;
	import org.frest.events.FrEventNames;
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;

	/**
	 * controls model transactions
	 * uses: FrModelsController.getInstance() --  singletone class
	 * @author SoftInsure
	 * 
	 */
	public class FrModelsController implements IModelLocator
	{
        private static var modelsController:FrModelsController;
		public var collections:FrCollection=new FrCollection();
		public static function getInstance():FrModelsController
		{
        	if (modelsController == null)
            {
                modelsController = new FrModelsController(generateLock());
			}
            return modelsController;
        }
		/**
		 * get the model to update from model collections by name 
		 * @param modelname
		 * @return 
		 * 
		 */
		public function getModelToUpdate(modelname:String):FrModel
		{
			return collections.getFromCollection(modelname+"ToUpdate") as FrModel;
		}
		/**
		 * add model to update in model collections 
		 * @param model
		 * 
		 */
		public function addModelToUpdate(model:FrModel):void
		{
			collections.addToCollection(FrUtils.getObjectName(model).toLowerCase()+"ToUpdate",model);
		}
		static protected function generateLock():Class
		{
			return SingletonLock;
		}
      	public function FrModelsController(lock:Class)
		{
        	if (!lock is SingletonLock)
            {
            	throw new Error("Error: Instantiation failed: Use FrModelsController.getInstance() instead of new.");
            }
        }
		private function invokeCommand(object:Object, action:String, optsOrOnSuccess:Object, onFailure:Function=null):void
		{
			CursorManager.setBusyCursor();
			var onSuccess:Object=null;
			if (optsOrOnSuccess != null)
			{
				if (optsOrOnSuccess is Function)
				{
					onSuccess=optsOrOnSuccess;
				}
				else
				{
					if (optsOrOnSuccess.hasOwnProperty("onSuccess"))
						onSuccess=optsOrOnSuccess["onSuccess"];
					if (optsOrOnSuccess.hasOwnProperty("onFailure"))
						onFailure=optsOrOnSuccess["onFailure"];
				}
			}
			FrUtils.cairngormDispatchEvent(FrEventNames.CRUD, {"action": action, "model": object, "onSuccess": onSuccess, "onFailure": onFailure});

		}
		private function invokeCommandSearch(object:Object, optsOrOnSuccess:Object, onFailure:Function=null):void
		{
			CursorManager.setBusyCursor();
			var onSuccess:Object=null;
			if (optsOrOnSuccess != null)
			{
				if (optsOrOnSuccess is Function)
				{
					onSuccess=optsOrOnSuccess;
				}
				else
				{
					if (optsOrOnSuccess.hasOwnProperty("onSuccess"))
						onSuccess=optsOrOnSuccess["onSuccess"];
					if (optsOrOnSuccess.hasOwnProperty("onFailure"))
						onFailure=optsOrOnSuccess["onFailure"];
				}
			}
			FrUtils.cairngormDispatchEvent(FrEventNames.DO_SEARCH, {"model": object, "onSuccess": onSuccess, "onFailure": onFailure});

		}
		private function invokeCommandList(object:Object, optsOrOnSuccess:Object, onFailure:Function=null):void
		{
			//CursorManager.setBusyCursor();
			var onSuccess:Object=null;
			if (optsOrOnSuccess != null)
			{
				if (optsOrOnSuccess is Function)
				{
					onSuccess=optsOrOnSuccess;
				}
				else
				{
					if (optsOrOnSuccess.hasOwnProperty("onSuccess"))
						onSuccess=optsOrOnSuccess["onSuccess"];
					if (optsOrOnSuccess.hasOwnProperty("onFailure"))
						onFailure=optsOrOnSuccess["onFailure"];
				}
			}
			FrUtils.cairngormDispatchEvent(FrEventNames.DO_LIST, {"model": object, "onSuccess": onSuccess, "onFailure": onFailure});

		}
		/*
		private function invokeCommandAttach(fileRef:FileReference, object:Object, optsOrOnSuccess:Object, onFailure:Function=null):void
		{
			//CursorManager.setBusyCursor();
			var onSuccess:Object=null;
			if (optsOrOnSuccess != null)
			{
				if (optsOrOnSuccess is Function)
				{
					onSuccess=optsOrOnSuccess;
				}
				else
				{
					if (optsOrOnSuccess.hasOwnProperty("onSuccess"))
						onSuccess=optsOrOnSuccess["onSuccess"];
					if (optsOrOnSuccess.hasOwnProperty("onFailure"))
						onFailure=optsOrOnSuccess["onFailure"];
				}
			}
			FrUtils.cairngormDispatchEvent(FrEventNames.DO_ATTACHMENT,{"fileReference":fileRef,"model": object, "onSuccess": onSuccess, "onFailure": onFailure});
			
		}
		*/
		/**
		 * used to invoke show 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function show(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, "show", optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke create 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function create(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, "create", optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke update 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function update(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, "update", optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke destroy 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function destroy(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, "destroy", optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke reload 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function reload(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, "reload", optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke any available action  
		 * @param action
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function action(action:String,object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommand(object, action, optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke search  
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function search(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommandSearch(object,optsOrOnSuccess,onFailure);
		}
		/**
		 * used to invoke list 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		public function list(object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommandList(object,optsOrOnSuccess,onFailure);
		}
		/**
		 * used to attach file 
		 * @param object
		 * @param optsOrOnSuccess
		 * @param onFailure
		 * 
		 */
		/*
		public function attach(fileRef:FileReference, object:Object, optsOrOnSuccess:Object=null, onFailure:Function=null):void
		{
			invokeCommandAttach(fileRef,object,optsOrOnSuccess,onFailure);
		}
		*/
	}
}
class SingletonLock
{
	public function SingletonLock()
	{
 
	}
}
