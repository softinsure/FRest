/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrCollection.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.collections
{
	import org.osmf.traits.IDisposable;

	/**
	 * Collection of objects 
	 * @author SoftInsure
	 * 
	 */
	public dynamic class FrCollection extends Object implements IDisposable
	{
		public function dispose():void
		{
			for (var key:String in this)
			{
				remove(key);
			}
		}
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
				delete this[key];
				//this[key]=null;
			}
		}
	}
}