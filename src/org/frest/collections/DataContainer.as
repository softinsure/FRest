/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure (This file was created from the original file of Kevin Crawford of NovoLogic)
 * File Name: DataContainer.as
 * Project Name: FRest
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.collections
{
	//import flash.display.MovieClip;
	//import flash.display.Sprite;
	import mx.collections.ArrayCollection;

	/**
	 * This Class is used to store objects with a string key
	 * This file was created from the original file of Kevin Crawford of NovoLogic
	 * and modified acording to project's needs
	 * @author SoftInsure
	 *
	 */
	public class DataContainer extends Object
	{
		private var containerArray:Array;
		private var keysArray:Array;

		/**
		 * Constructor for Class
		 */
		public function DataContainer()
		{
			this.container=new Array();
			this.keys=new Array();
		}

		public function get count():int
		{
			return this.keys.length + 1;
		}

		/**
		 * Sets value for key value pair passed
		 *
		 * @param key:String
		 * @param value:Object
		 * @retrun void
		 */
		public function put(key:String, value:*):void
		{
			if ((key != null) && (value != null))
			{
				if (!this.contains(key))
				{
					this.keys[this.keys.length]=key.toLowerCase();
				}
				this.container[key.toLowerCase()]=value;
			}
		}

		/**
		 * gets value for the provided key as an Object
		 *
		 * @param key:String
		 * @retrun Object
		 */
		public function get(key:String):*
		{
			return this.container[key.toLowerCase()];
		}

		/**
		 * used to remove object from container
		 * @param key
		 * @return
		 *
		 */
		public function remove(key:String):*
		{
			var newkey:String=key.toLowerCase();
			keys.splice(indexByKey(newkey), 1);
			this.container[newkey]=null;
			delete container[newkey];
		}
		/**
		 * get the index of the object
		 * @param key
		 * @return
		 *
		 */
		public function indexByKey(key:String):int
		{
			for (var i:int=0; i < keys.length; i++)
			{
				if (keys[i] == key)
					return i;
			}
			return -1;
		}
		/**
		 * gets value for the provided key as a ArrayCollection
		 *
		 * @param key:String
		 * @retrun ArrayCollection
		 */
		public function getAsArrayCollection(key:String):ArrayCollection
		{
			var ac:ArrayCollection;
			try
			{
				ac=ArrayCollection(this.get(key));
			}

			catch (e:Error)
			{
				ac=new ArrayCollection();
			}

			return ac;
		}
		/**
		 * Returns boolean indicating the DataContainer has data stored for provided key
		 * @param key:String
		 * @return Boolean
		 */
		public function contains(key:String):Boolean
		{
			return (this.container[key.toLowerCase()] != null);
		}
		/**
		 * Returns Boolean indicating if the DataContainer is empty of all data.
		 * @return Boolean
		 */
		public function isEmpty():Boolean
		{
			return (this.keys.length == 0);
		}
		/**
		 * Clears all data from DataContainer
		 * @return void
		 */
		public function empty():void
		{
			this.container=new Array();
			this.keys=new Array();
		}
		/**
		 * Getter for container Array
		 * @return Array
		 * */
		public function get container():Array
		{
			if (containerArray == null)
				containerArray=new Array();
			return containerArray;
		}
		/**
		 * Setter for container Array
		 * @param obj:Array
		 * @return void
		 * */
		public function set container(obj:Array):void
		{
			containerArray=obj;
		}
		/**
		 * Getter for keys Array
		 * @return Array
		 * */
		private function get keys():Array
		{
			if (keysArray == null)
				keysArray=new Array();
			return keysArray;
		}
		/**
		 * Setter for keys Array
		 * @param obj:Array
		 * @return void
		 * */
		private function set keys(obj:Array):void
		{
			keysArray=obj;
		}
	}
}
