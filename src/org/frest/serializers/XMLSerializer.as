/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: XMLSerializer.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.serializers
{
	import flash.utils.describeType;
	
	import mx.messaging.channels.StreamingAMFChannel;
	import mx.utils.ObjectUtil;
	
	import org.frest.Fr;
	import org.frest.collections.FrModelCollection;
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;

	public class XMLSerializer extends GenericSerializer
	{
		public function XMLSerializer()
		{
		}
		public override function marshall(object:Object, recursive:Boolean=false):Object
		{
			return objectToXML(object);
		}

		public override function unmarshall(fromObject:Object, toObject:FrModel, disconnected:Boolean=false):Object
		{
			if (fromObject is FrModel)
			{
				toObject=fromObject as FrModel;
				return toObject;
			}
			try
			{
				xmlToObject(toObject,XML(fromObject));
			}
			catch (e:Error)
			{
				throw new Error("'" + fromObject + "' not not been unmarshalled. Error: " + e.getStackTrace());
			}
			return null;
		}
		public function objectToXML(object:Object,parent:Object=null,recursive:Boolean=false):XML
		{
			var name:String=FrUtils.getResourceXMlRoot(object);
			var array:Array=new Array();
			if(name == "")
			{
				name=FrUtils.toSnakeCase(FrUtils.getObjectName(object));
			}
			var name2:String=name;
			if(parent)
			{
				var pName:String=FrUtils.toSnakeCase(FrUtils.getObjectName(parent));
				name=name+"_attributes";
				if(!FrUtils.isEmpty(parent["id"]) && parent["id"]!=0)
				{
					array.push(("<" + pName + "_id>" + parent["id"] + "</" + pName + "_id>"));
				}
				else
				{
					array.push("<" + pName + "_id/>");
				}
			}
			for each (var node:XML in describeType(object)..accessor)
			{
				if (FrUtils.isIgnored(node))
					continue;
				if (FrUtils.isReadOnly(node))
					continue;
				var nodeName:String=node.@name;
				var type:String=getType(node);
				var snakeName:String=FrUtils.toSnakeCase(nodeName);
				if(object[nodeName] != null)
				{
					//check if has many
					if(FrUtils.isHasMany(node))
					{
						var embedded:Array = new Array;
						for each (var item:FrModel in object[nodeName])
						{
							if(item!=null && item.changed)
							{
								if(!recursive || (!FrUtils.isEmpty(item["id"]) && item["id"]!=0))
								{
									Fr.crudTransactionQueue.addModelToQueue(item,item.toBeDeleted?"delete":item.id==0?"create":"update",object);
								}
								else
								{
									embedded.push(objectToXML(item,object).toXMLString(),recursive);
								}
							}
						}
						if(embedded.length>0)
						{
							array.push(("<" + snakeName + "_attributes type=\"array\">" +embedded.join("") + "</" + snakeName + "_attributes>"));
						}
					}
					//check if has one
					else if(FrUtils.isHasOne(node))
					{
						var model:FrModel=object[nodeName];
						if(model!=null && model.changed)
						{
							//if(!FrUtils.isEmpty(model["id"]) && model["id"]!=0)
							if(!recursive || (!FrUtils.isEmpty(model["id"]) && model["id"]!=0))
							{
								Fr.crudTransactionQueue.addModelToQueue(model,model.toBeDeleted?"delete":model.id==0?"create":"update",object);
							}
							else
							{
								array.push(objectToXML(model,object).toXMLString(),recursive);
							}
						}
					}
					else
					{
						var val:*=FrUtils.uncast(object, nodeName);
						if(val is String)
						{
							if(FrUtils.isIgnoredBlank(node,String(val)))
							{
								continue;
							}
						}
						if (ObjectUtil.hasMetadata(object,nodeName,"Base64"))
						{
							val=FrUtils.base64EncodeString(val);
						}
						array.push(("<" + snakeName + " type=\"" + type + "\">" + val + "</" + snakeName + ">"));
					}
				}
				else
				{
					if(!(FrUtils.isHasOne(node) || FrUtils.isHasMany(node)))
					{
						array.push("<" + snakeName + "/>");
					}
				}
			}
			/*
			var nestedArray:Array=new Array();
			if(parent)
			{
				//nestedArray.push("<id>" + object["id"] + "</id>");
				nestedArray.push(("<" + name2 +  " type=\"array\">" +array.join("") + "</" + name2 + ">"));
			}
			else
			{
				nestedArray=array;
			}
			*/
			return new XML("<" + name + ">" + array.join("") + "</" + name + ">")
		}
		private function objName(object:Object):String
		{
			var name:String=FrUtils.getResourceXMlRoot(object);
			if(name == "")
			{
				name=FrUtils.toSnakeCase(FrUtils.getObjectName(object));
			}
			return name;			
		}
		public function toDirectFieldsUpdateObject(object:Object,fieldsToUpadate:Array):Object
		{
			var name:String=FrUtils.getResourceXMlRoot(object);
			if(name == "")
			{
				name=FrUtils.toSnakeCase(FrUtils.getObjectName(object));
			}
			var obj:Object=new Object();
			for each (var fieldName:String in fieldsToUpadate)
			{
				if (ObjectUtil.hasMetadata(object,fieldName,"Ignored"))
					continue;
				var snakeName:String=FrUtils.toSnakeCase(fieldName);
				if(object[fieldName] != null)
				{
					var val:*=FrUtils.uncast(object, fieldName);
					if(val is String)
					{
						if(String(val).length==0 && ObjectUtil.hasMetadata(object,fieldName,"IgnoredBlank"))
						{
							continue;
						}
					}
					if (ObjectUtil.hasMetadata(object,fieldName,"Base64"))
					{
						val=FrUtils.base64EncodeString(val);
					}
					obj[name + "[" + snakeName + "]"]=val;
				}
				else
				{
					obj[name + "[" + snakeName + "]"]="";
				}
			}
			obj[name + "[id]"]=object["id"];
			return obj;
		}
			
		public function toUpdateObject(object:Object,parent:Object=null):Object
		{
			var name:String=FrUtils.getResourceXMlRoot(object);
			if(name == "")
			{
				name=FrUtils.toSnakeCase(FrUtils.getObjectName(object));
			}
			var obj:Object=new Object();
			for each (var node:XML in describeType(object)..accessor)
			{
				if (FrUtils.isIgnored(node))
					continue;
				if (FrUtils.isReadOnly(node))
					continue;
				var nodeName:String=node.@name;
				var type:String=node.@type;
				var snakeName:String=FrUtils.toSnakeCase(nodeName);
				//check if has one
				if(FrUtils.isHasOne(node))
				{
					var model:FrModel=object[nodeName];
					if(model!=null && model.changed)
					{
						Fr.crudTransactionQueue.addModelToQueue(model,model.toBeDeleted?"delete":model.id==0?"create":"update",object);
					}
				}
				else if(FrUtils.isHasMany(node))
				{
					for each (var model2:FrModel in object[nodeName])
					{
						if(model2!=null && model2.changed)
						{
							Fr.crudTransactionQueue.addModelToQueue(model2,model2.toBeDeleted?"delete":model2.id==0?"create":"update",object);
						}
					}
				}
				else if(object[nodeName] != null)
				{
					var val:*=FrUtils.uncast(object, nodeName);
					if(val is String)
					{
						if(FrUtils.isIgnoredBlank(node,String(val)))
						{
							continue;
						}
					}
					if (ObjectUtil.hasMetadata(object,nodeName,"Base64"))
					{
						val=FrUtils.base64EncodeString(val);
					}
					obj[name + "[" + snakeName + "]"]=val;
				}
				else
				{
					obj[name + "[" + snakeName + "]"]="";
				}
			}
			return obj;
		}
		
		protected function processArrayObjects(model:Object, modelCollection:FrModelCollection,nestedElements:XMLList, belongsTo:Object=null):FrModelCollection
		{
			var newCollection:Boolean=false;
			if(modelCollection==null)
			{
				newCollection=true;
				modelCollection= new FrModelCollection();
			}
			//var counter:int=1;
			for each (var nestedElement:XML in nestedElements)
			{
				var found:Boolean=false;
				var nestedName:String=nestedElement.localName();
				//var nodeID:String=String(nestedElement.id);
				var obj:Object=null;
				if(!newCollection)
				{
					obj=modelCollection.getModelByModelID(String(nestedElement.id));
					if(obj!=null)
					{
						found=true;
					}
				}
				if(!found)
				{
					obj=initializeModel(String(nestedElement.id),nestedElement.localName());
					//modelCollection.addModel(obj);
				}
				FrUtils.addParentID(model,obj);
				xmlToObject(obj,nestedElement);
				if(!found)
				{
					modelCollection.addModel(obj);
				}
				if(!newCollection)
				{
					modelCollection.clearNewModels();
				}
			}
			return modelCollection;
		}
		private function setChildModel(model:Object,target:String,targetName:String,element:XML,belongsTo:Boolean=false):void
		{
			//check existing model
			if(model[target]==null)
			{
				model[target]=initializeModel(String(element.id),targetName);
			}
			xmlToObject(model[target],element);
			if(belongsTo)
			{
				FrUtils.addBelongsToID(model,model[target]);
			}
			else
			{
				FrUtils.addParentID(model,model[target]);
			}
		}
		protected function xmlToObject(model:Object, modelXML:XML):Object
		{
			if (model != null)
			{
				var modelXMLList:XMLList;
				if (modelXML.@type == "array")
				{
					modelXMLList=modelXML.children().children();
				}
				else
				{
					modelXMLList=modelXML.children();
				}
				for each (var element:XML in modelXMLList)
				{
					var targetName:String=element.localName();
					var targetNameCamel:String=FrUtils.toCamelCase(targetName);
					if(targetName!="" && (model.hasOwnProperty(targetName)||model.hasOwnProperty(targetNameCamel)))
					{
						var camelCase:Boolean=model.hasOwnProperty(targetNameCamel);
						var target:String=camelCase?targetNameCamel:targetName;
						if (targetName.search(/.+\$/) == -1)
						{
							//check if has many
							if(element.@type == "array")
							{
								//has many model collection
								//collection name should be camel case
								model[target]=processArrayObjects(model, model[target] as FrModelCollection, element.children());
							}
							else if(ObjectUtil.hasMetadata(model,target,"HasOne"))
							{
								//check existing model
								setChildModel(model,target,targetName,element);
							}
							else if(ObjectUtil.hasMetadata(model,target,"BelongsTo"))
							{
								//check existing model
								setChildModel(model,target,targetName,element,true);
							}
							else if(element.text().length() == 1)
							{
							//base64 check
							var val:*=FrUtils.cast(element.@type, element.toString());
							val=FrUtils.castByMetaData(model,targetName,val);
							model[targetName]=val;
							}
						}
					}
				}
			}
			return model;
		}

	}
}