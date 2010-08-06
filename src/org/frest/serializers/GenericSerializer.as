/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GenericSerializer.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.serializers
{
	import org.frest.models.FrModel;
	import org.frest.models.FrReferences;
	import org.frest.utils.FrUtils;


	public class GenericSerializer implements ISerializer
	{
		protected static var types:Object={"int": "integer", "uint": "integer", "Boolean": "boolean", "String": "string", "Number": "double", "Date": "date", "DateTime": "datetime"}

		public function GenericSerializer()
		{
		}
		protected function getType(node:XML):String
		{
			if (node == null)
				return types["String"];

			var type:String=node.@type;
			var result:String=types[type];
			if (FrUtils.isDateTime(node))
			{
				return types["DateTime"];
			}
			else if(result==null)
			{
				var vArray:Array=type.split("::");
				if(vArray.length>0)
				{
					return vArray[vArray.length - 1];
				}
				else
				{
					return types["String"];
				}
			}
			else
			{
				return result;
			}
		}
		protected function initializeModel(id:String, modelName:String):Object
		{
			var model:Object=FrReferences.initializeClass(FrUtils.toCamelCase(modelName));
			model["id"]=id;
			return model;
		}
		public function marshall(object:Object, recursive:Boolean=false):Object
		{
			return null;
		}
		public function unmarshall(fromObject:Object, toObject:FrModel, disconnected:Boolean=false):Object
		{
			return null;
		}
	}
}