/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
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
	 * @author Goutam
	 * 
	 */
	public class FrReferences
	{
		//define class references here
		private static var modelClassPath:Array=[];
		public static function initiateReferences():void
		{
		}
		public static function addClassPath(classPath:String):void
		{
			modelClassPath.push(classPath);
		}
		public static function initializeClass(className:String):*
		{
			var clazz:Class=null;
			className=FrUtils.upperCaseFirst(className);
			for each (var classPath:String in modelClassPath)
			{
				clazz = getDefinitionByName(classPath+"."+className) as Class;
				if(clazz!=null)
				{
					return new clazz();
				}
			}
			throw new Error("Class Path for class "+className+" is not defined. Please use FrReferences.addClassPath('XXXX')!");
		}
	}
}