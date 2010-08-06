/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: CRUDCollections.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.collections
{
	import flash.utils.getQualifiedClassName;
	/**
	 * A collection of CRUD objects that are used for a chain of transaction 
	 * @author SoftInsure
	 * 
	 */
	public dynamic class CRUDCollections extends Object
	{
		private static var crudCollections:CRUDCollections;
		private var transCount:int=0;
		private var error:Boolean=false;
		public static function getInstance():CRUDCollections{
			if (crudCollections == null)
			{
				crudCollections = new CRUDCollections();
			}
			return crudCollections;
		}
		public function CRUDCollections() {
			if (crudCollections != null)
			{
				throw new Error("Only one crudCollections instance may be instantiated.");
			}
		}
		private function contains(key:String):Boolean
		{
			return (this[key] != null);
		}
		/**
		 * determines if any object has pending transaction in this collection 
		 * @param object
		 * @return 
		 * 
		 */
		public function hasTransaction(object:Object):Boolean
		{
			return this.contains(internalKey(object));
		}
		/**
		 * determines if ther is pending transaction in this collection
		 * @return 
		 * 
		 */
		public function get hasAnyTransaction():Boolean
		{
			return transCount>0;
		}
		public function set crudError(value:Boolean):void
		{
			if(transCount<0)
			{
				error=value;
			}
			else
			{
				if(!error)
				{
					error=value;
				}
			}
		}
		public function get crudError():Boolean
		{
			return error;
		}
		private function internalKey(object:Object):String
		{
			return getQualifiedClassName(object)+"::"+object["id"];
		} 
		/**
		 * used to add objects in queue CRUD 
		 * @param object
		 * 
		 */
		public function addTransaction(object:Object):void
		{
			removeTransaction(object);
			this[internalKey(object)]=object;
			if(transCount<=0)
			{
				error=false;
			}
			transCount++;
		}
		/**
		 * used to remove objcets from CRUD transaction queue 
		 * @param object
		 * 
		 */
		public function removeTransaction(object:Object):void
		{
			var key:String=internalKey(object);
			if(this.contains(key))
			{
				transCount--;
				this[key]=null;
			}
		}
	}
}