/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrReferences.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.models
{
	import flash.utils.getDefinitionByName;
	
	import org.frest.utils.FrUtils;
	
	/**
	 * adding class reference and class path for initialization by class name
	 * @author SoftInsure
	 * 
	 */
	public class FrReferences
	{
		//define class references here
		private var modelClassPath:Array=[];
		private static var iCtl:FrReferences;
/*		public static function initiateReferences():void
		{
		}
*/		public function addClassPath(classPath:String):void
		{
			iCtl.modelClassPath.push(classPath);
		}
		public function initializeClass(className:String):*
		{
			var clazz:Class=null;
			var hasPath:Boolean=false;
			className=FrUtils.upperCaseFirst(className);
			for each (var classPath:String in iCtl.modelClassPath)
			{
				try
				{
					clazz = getDefinitionByName(classPath+"."+className) as Class;
					if(clazz!=null)
					{
						hasPath=true;
						return new clazz();
					}
				}
				catch (e:Error)
				{
					continue;
				}
			}
			if(!hasPath)
			{
				throw new Error("Class Path for class "+className+" is not defined. Please use FrReferences.addClassPath('XXXX')!");
			}
		}
		static protected function generateLock():Class
		{
			return SingletonLock;
		}
		public static function getInstance():FrReferences
		{
			if (iCtl == null)
			{
				iCtl = new FrReferences(generateLock());
			}
			return iCtl;
		}
		public function FrReferences(lock:Class)
		{
			if (!lock is SingletonLock)
			{
				throw new Error("Error: Instantiation failed: Use FrReferences.getInstance() instead of new.");
			}
		}
	}
}
class SingletonLock
{
	public function SingletonLock()
	{
	}
}