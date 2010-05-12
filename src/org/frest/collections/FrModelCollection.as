/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: FrModelCollection.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.collections
{
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;
	/**
	 * dynamic model collection container extended from FrCollection 
	 * @author Goutam
	 * 
	 */
	public dynamic class FrModelCollection extends FrCollection
	{
		private var idMatch:Array=[];
		private var newModels:Array=[];
		public function FrModelCollection()
		{
			super();
		}
		private function newModel(model:FrModel):Boolean
		{
			return (model.id==0);
		}
		/**
		 * get FrModel from collection by key 
		 * @param key
		 * @return 
		 * 
		 */
		public function getModelByKey(key:String):FrModel
		{
			return this.getFromCollection(key);
		}
		/*
		public function ifExists(object:Object):Boolean
		{
			return this.contains(FrUtils.uniqueID(object));
		}
		*/
		/**
		 * get FrModel by model id from the collection 
		 * @param ID
		 * @return 
		 * 
		 */
		public function getModelByModelID(ID:String):FrModel
		{
			if(idMatch[ID]!=null)
			{
				return this.getFromCollection(idMatch[ID]);
			}
			else
			{
				return null;
			}
		}
		/**
		 * used to clear models having no id (id=0) 
		 * 
		 */
		public function clearNewModels():void
		{
			for each (var key:String in newModels)
			{
				remove(key);
			}
		}
		/**
		 * used to add model to collection 
		 * @param model
		 * 
		 */
		public function addModel(model:Object):void
		{
			var key:String = FrUtils.uniqueID(model);
			var id:String = model["id"].toString();
			if(!newModel(model as FrModel))
			{
				idMatch[id]=key;
			}
			else
			{
				newModels.push(key);
			}
			this.addToCollection(key,model);
		}
	}
}