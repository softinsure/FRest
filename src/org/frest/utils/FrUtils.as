/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: FrUtils.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.utils
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.utils.DateUtil;
	
	import flash.events.TimerEvent;
	import flash.geom.Utils3D;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import org.common.utils.XDateUtil;
	import org.frest.models.FrModel;
	
	import spark.components.Application;

	public class FrUtils
	{
		public function FrUtils()
		{
		}
		public static function get applicationUsed():Application
		{
			return FlexGlobals.topLevelApplication as Application;
		}
		public static function set applicationUsed(application:Application):void
		{
			FlexGlobals.topLevelApplication=application;
		}
		/*
		public static function setSessionTimer(functionToCall:Function):void
		{
			applicationUsed.systemManager.addEventListener(FlexEvent.IDLE,functionToCall);
		}
		*/
		public static function addParentID(parent:Object,child:Object):void
		{
			var pid:String=FrUtils.toSnakeCase(FrUtils.getObjectName(parent))+"_id";
			if(child.hasOwnProperty(pid) && parent.hasOwnProperty("id"))
			{
				child[pid]=parent["id"];
			}
		}
		public static function addBelongsToID(child:Object,belongsto:Object):void
		{
			var bid:String=FrUtils.toSnakeCase(FrUtils.getObjectName(belongsto))+"_id";
			if(child.hasOwnProperty(bid) && belongsto.hasOwnProperty("id"))
			{
				child[bid]=belongsto["id"];
			}
			
		}
		/*
		public static function set enableApplication(value:Boolean):void
		{
			applicationUsed.enabled=value;
		}
		*/
		public static function isEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		public static function base64EncodeString(data:*):String
		{
			var base64:Base64Encoder = new Base64Encoder();
			if(data is ByteArray)
			{
				base64.encodeBytes(data);
			}
			else 
			{
				base64.encode(data);
			}
			return base64.toString();
		}
		public static function base64EDecodeString(encoded:String):ByteArray
		{
			var base64:Base64Decoder = new Base64Decoder();
			base64.decode(encoded);
			return base64.toByteArray();
		}
		public static function isReadOnly(attribute:XML):Boolean
		{
			return getAttributeAnnotation(attribute, "ReadOnly").length() > 0;
		}
		public static function isBelongsTo(attribute:XML):Boolean
		{
			return getAttributeAnnotation(attribute, "BelongsTo").length() > 0;
		}

		/**
		 * Checks if the node is annotated with [HasMany]
		 */
		public static function isHasMany(attribute:XML):Boolean
		{
			return getAttributeAnnotation(attribute, "HasMany").length() > 0;
		}

		/**
		 * Checks if the node is annotated with [HasOne]
		 */
		public static function isHasOne(attribute:XML):Boolean
		{
			return getAttributeAnnotation(attribute, "HasOne").length() > 0;
		}

		/**
		 * Checks if the node is annotated with [Ignored]
		 */
		public static function isIgnored(attribute:XML):Boolean
		{
			var ignore:Boolean=getAttributeAnnotation(attribute, "Ignored").length() > 0;
/*			if(!ignore && attribute[attribute.@name].toString().length==0)
			{
				//check for ingnore blank
				ignore=getAttributeAnnotation(attribute, "IgnoredBlank").length() > 0;
			}
*/			return ignore;
		}
		public static function isIgnoredBlank(attribute:XML,val:String):Boolean
		{
			return val.length==0 && getAttributeAnnotation(attribute, "IgnoredBlank").length() > 0;
		}
		/**
		 * Checks if the node is annotated with [DateTime]
		 */
		public static function isDateTime(attribute:XML):Boolean
		{
			return getAttributeAnnotation(attribute, "DateTime").length() > 0;
		}

		/**
		 * Converts a string to CamelCase from snake_case
		 */
		public static function toCamelCase(string:String):String
		{
			return string.replace(/_[a-z]/g, function x():String
				{
					return (arguments[0] as String).slice(1).toUpperCase();
				});
		}

		/**
		 * Converts a string to snake_case from CamelCase
		 */
		public static function toSnakeCase(string:String):String
		{
			return lowerCaseFirst(string).replace(/[A-Z]/g, function x():String
				{
					return "_" + (arguments[0] as String).toLowerCase();
				});
		}

		/**
		 * Lower cases first letter in a string leaving the rest of it alone
		 */
		public static function lowerCaseFirst(string:String):String
		{
			return string.charAt(0).toLowerCase() + string.slice(1);
		}

		/**
		 * Upper cases first letter in a string leaving the rest of it alone
		 */
		public static function upperCaseFirst(string:String):String
		{
			return string.charAt(0).toUpperCase() + string.slice(1);
		}
		/**
		 * Convert from ISO date representation to an actual AS3 Date object
		 */
		public static function isoToDate(value:String):Date
		{
			var dateStr:String=value;
			dateStr=dateStr.replace(/-/g, "/");
			dateStr=dateStr.replace("T", " ");
			dateStr=dateStr.replace("Z", " GMT-0000");
			dateStr=dateStr.replace("UTC", " GMT-0000");
			return new Date(Date.parse(dateStr));
		}
		/**
		 * Casts a variable to specific type from a string, while trying to do the right thing
		 * based on targetType description.
		 */
		public static function castByMetaData(object:Object,property:String,value:Object):*
		{
			var castmore:Boolean=true;
			if (value == null)
				return value;
			if (ObjectUtil.hasMetadata(object,property,"Base64"))
			{
				value=base64EDecodeString(String(value));
				castmore=false;
			}
			if (ObjectUtil.hasMetadata(object,property,"Xml"))
			{
				value=XML(value);
				castmore=false;
			}
			if(!castmore)
				return value;
			if (ObjectUtil.hasMetadata(object, property, "Boolean"))
			{
				value=String(value).toLowerCase();
				return (value == "true" || value == 1) ? true : false;
			}
			/*
			else if (ObjectUtil.hasMetadata(object, property, "Date"))
			{
				var date:String=(value as String).replace(/-/g, "/");
				return new Date(Date.parse(date));
			}
			*/
			else if (ObjectUtil.hasMetadata(object, property, "DateTime"))
			{
				if(object[property] is Date)
				{
					if(value is Date)
						return value;
					var datetime:String=(value as String).replace(" ", "T");
					try
					{
						return DateUtil.parseW3CDTF(datetime);
					}
					catch (e:Error)
					{
						return new Date(Date.parse(datetime.replace(/-/g, "/").replace("T", " ")));
					}
				}
				else
				{
					return XDateUtil.formatDate(String(value));
				}
			}
			else
			{
				return value;
			}
		}
		public static function cast(targetType:String, value:Object):*
		{
			if (value == null || !(value is String))
				return value;
			targetType=targetType.toLowerCase();
			if (targetType == "boolean")
			{
				value=String(value).toLowerCase();
				return (value == "true" || value == 1) ? true : false;
			}
			else if (targetType == "date")
			{
				var date:String=(value as String).replace(/-/g, "/");
				return new Date(Date.parse(date));
			}
			else if (targetType == "datetime")
			{
				var datetime:String=(value as String).replace(" ", "T");
				try
				{
					return DateUtil.parseW3CDTF(datetime);
				}
				catch (e:Error)
				{
					return new Date(Date.parse(datetime.replace(/-/g, "/").replace("T", " ")));
				}
			}
			else
			{
				return String(value).replace("\\x3A", ":").split("\\n").join("\n");
			}
		}

		/**
		 * Convert a specific object to its string representation
		 */
		public static function uncast(object:Object, property:String):*
		{
			if (object[property] == null)
				return null;

			if (object[property] is Date || XDateUtil.isDate(object[property]))
			{
				if (ObjectUtil.hasMetadata(object, property, "DateTime"))
				{
					if(object[property] is Date)
					{
						return DateUtil.toW3CDTF(object[property] as Date);
					}
					else
					{
						return XDateUtil.formatDate(String(object[property]),"YYYY-MM-DD");
					}
				}
				else
				{
					return XDateUtil.formatDate(String(object[property]),"YYYY-MM-DD");
				}
			}
			else if (object[property] is Number)
			{
				var num:Number=Number(object[property]);
				if (isNaN(num))
				{
					return null;
				}
				else
				{
					return num.toString();
				}
			}
			else
			{
				return String(object[property]);
			}
		}

		public static function getObjectName(model:Object):String
		{
			var vArray:Array=getQualifiedClassName(model).split("::");
			return vArray[vArray.length - 1];
		}
		public static function internalKey(object:Object):String
		{
			return getQualifiedClassName(object)+"::"+object["id"];
		}
		public static function uniqueID(object:Object):String
		{
			return UIDUtil.getUID(object);
		}
		public static function getResourceName(object:Object):String
		{
			return describeResource(object).arg.(@key == "name").@value;
		}
		public static function getResourceXMlRoot(object:Object):String
		{
			return describeResource(object).arg.(@key == "xmlroot").@value;
		}
		public static function getRestURL(object:Object,action:String):String
		{
			var belongstopath:String=getBelongsToPath(object);
			var url:String=rootPath+getResourcePathPrefix(object)+belongstopath+getResourceName(object);
			if(url=="/")
			{
				throw new Error('missing tag Resource(name="XXXXXXXX")] for model '+getObjectName(object));
			}
			//if(FrUtils.isEmpty(belongstopath))
			//{
				switch(action.toLowerCase())//do a lowercase
	        	{
	        		case "show":
	        		case "update":
	        		case "destroy":
					case "clone":
					case "directupdate":
						/*
						if(FrUtils.isEmpty(belongstopath))
						{
							url=url+"/"+object.id+".xml";
						}
						else
						{
							url=url+"/"+action.toLowerCase()+"/"+object.id+".xml";
						}
						*/
						//url=url+"/"+action.toLowerCase()+"/"+object.id+".xml";
	        			//break;
						url=url+"/"+action.toLowerCase()+"/"+object.id+".xml";
	 					break;
					case "index":
					case "new":
					case "create":
					case "search":
						url=url+".xml";
						break;
/*					case "attach":
						url=url+"/create";
						break;
*/	        		default:
						if(object.id>0)
						{
							url=url+"/"+action.toLowerCase()+"/"+object.id+".xml";
						}
						else if(object.id<0)//if is set to negetive, pass action in the url
						{
							url=url+"/"+action.toLowerCase()+"/noid.xml";
						}
						else
						{
							url=url+".xml";
						}
						break;
	        	}
	   		//}
	   		//else
	   		//{
	   			//url=url+".xml";
	   		//}		
        	return url;
		}
		public static function getBelongsToPath(object:Object):String
		{
			var path:String="";
			var model:FrModel=object as FrModel;
			while(model.hasBelongsTo && model.useBelongsToPath)
			{
				model=model.belongsTo;
				path=getResourceName(model)+"/"+model.id+"/"+path;
			}
			return path;
		}
		public static function getResourcePathPrefix(object:Object):String
		{
			var value:String=describeResource(object).arg.(@key == "pathPrefix").@value;
			if (!isEmpty(value))
			{
				value=value + "/";
			}
			return value;
		}
		public static function get rootPath():String
		{
			var value:String= "/";
			return value;
		}

		public static function getAttributeAnnotation(attribute:XML, annotationName:String):XMLList
		{
			return attribute.metadata.(@name == annotationName);
		}

		public static function describeResource(object:Object):XMLList
		{
			return (object is Class) ? describeType(object).factory.metadata.(@name == "Resource") : describeType(object).metadata.(@name == "Resource");
		}
		public static function cairngormDispatchEvent(
		eventName : String , data : Object = null) : void
		{
			var event : CairngormEvent = new CairngormEvent(eventName);
			event.data = data;
			event.dispatch();
		}

	}
}