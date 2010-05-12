/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: FrCollection.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.collections
{
	/**
	 * Collection of objects 
	 * @author Goutam
	 * 
	 */
	public dynamic class FrCollection extends Object
	{
		public function FrCollection()
		{
			super();
		}
		public function getFromCollection(key:String):*
		{
			//return this[key.toLowerCase()];
			return this[key];
		}
		public function addToCollection(key:String,object:*):void
		{
			remove(key);
			this[key]=object;
			//this[key.toLowerCase()]=object;
		}
		public function contains(key:String):Boolean
		{
			return (this.hasOwnProperty(key));
			//return (this.hasOwnProperty(key.toLowerCase()));
		}
		public function remove(key:String):void
		{
			if(this.contains(key))
			{
				this[key]=null;
			}
		}
	}
}