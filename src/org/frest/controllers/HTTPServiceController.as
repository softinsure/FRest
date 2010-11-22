/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: HTTPServiceController.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.controllers
{
	//import com.adobe.cairngorm.business.Responder;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.frest.Fr;

	/**
	 * used to send load http requests
	 * @author SoftInsure
	 * 
	 */	
	public class HTTPServiceController implements IServiceController
	{
		public static const GET:int=1;
		public static const POST:int=2;
		public static const PUT:int=3;
		public static const DELETE:int=4;

		public function HTTPServiceController()
		{
		}
		/**
		 * use to send request 
		 * @param requestURL
		 * @param responder
		 * @param requestMathod
		 * @param request
		 * @param sendXML
		 * @param resultFormat
		 * @param useProxy
		 * 
		 */
		public function sendRequest(requestURL:String, responder:IResponder, requestMathod:String=null, request:Object=null, sendXML:Boolean = false, resultFormat:String="e4x", useProxy:Boolean=false):void
		{
			var service:HTTPService=new HTTPService();
			service.url=requestURL;
			service.contentType = sendXML ? "application/xml" : "application/x-www-form-urlencoded";
			service.resultFormat=resultFormat;
			if (requestMathod == null)
			{
				service.method=(request == null) ? "GET" : "POST";
			}
			else if ((requestMathod == "PUT") || (requestMathod == "DELETE"))
			{
				service.method="POST";
				if (request == null)
				{
					request=new Object();
				}
				request["_method"]=requestMathod;
			}
			else
			{
				service.method=requestMathod;
			}
			service.request=request;
			service.useProxy=useProxy;
			try
			{
				//good-old fashioned event handlers
				//Workaround to Flex SDK 3.4 Bug
				service.addEventListener(ResultEvent.RESULT, responder.result); 
				service.addEventListener(FaultEvent.FAULT, responder.fault);
				//Fr.log.debug("sending request to URL:" + service.url + " with method: " + service.method + " and content:" + ((service.request == null) ? "null" : "\r" + service.request.toString()));
				service.send();
			}
			catch (error:ArgumentError)
			{
				throw new Error("An Argument Error has occurred: " + error);
			}
			catch (error:SecurityError)
			{
				throw new Error("An Security Error has occurred: " + error);
			}
			catch (error:Error)
			{
				throw new Error("An Error has occurred: " + error);
			}
		}
		/**
		 * used to load request 
		 * @param requestURL
		 * @param responseCatcher
		 * @param moreArgumentWithCatcher
		 * @param requestMathod
		 * @param dataFormat
		 * 
		 */
		public function loadRequest(requestURL:String, responseCatcher:*, moreArgumentWithCatcher:Array=null, requestMathod:String=null,dataFormat:String="e4x"):void
		{
			var request:URLRequest=new URLRequest(requestURL);
			var loader:URLLoader=new URLLoader();
			if(responseCatcher is Function)
			{
				if (moreArgumentWithCatcher != null)
				{
					loader.addEventListener(Event.COMPLETE, function(event:Event):void{responseCatcher.call(this, event, moreArgumentWithCatcher)});
				}
				else
				{
					loader.addEventListener(Event.COMPLETE, responseCatcher);
				}
			}
			else if(responseCatcher is IResponder)
			{
				loader.addEventListener(ResultEvent.RESULT, responseCatcher.result); 
				loader.addEventListener(FaultEvent.FAULT, responseCatcher.fault);
			}
			if (requestMathod == null || requestMathod == "GET")
			{
				request.method=URLRequestMethod.GET;
			}
			else
			{
				request.method=URLRequestMethod.POST;
			}
			loader.dataFormat=dataFormat;
			try
			{
				loader.load(request);
			}
			catch (error:ArgumentError)
			{
				loader=null;
				throw new Error("An Argument Error has occurred: " + error);
			}
			catch (error:SecurityError)
			{
				loader=null;
				throw new Error("An Security Error has occurred: " + error);
			}
			catch (error:Error)
			{
				loader=null;
				throw new Error("Unable to load URL: " + error);
			}
		}
		/*
		public function uploadFile(fileToUplaod:FileReference,requestURL:String,responseCatcher:*,object:Object=null,upoadDataFieldName:String="filedata"):void
		{
			var request:URLRequest=new URLRequest(requestURL);
			request.method=URLRequestMethod.POST;
			var variables:URLVariables=new URLVariables();
			variables.object=object;
			if(responseCatcher is Function)
			{
				fileToUplaod.addEventListener(Event.COMPLETE, responseCatcher);
			}
			else if(responseCatcher is IResponder)
			{
				fileToUplaod.addEventListener(ResultEvent.RESULT, responseCatcher.result); 
				fileToUplaod.addEventListener(FaultEvent.FAULT, responseCatcher.fault);
			}
			try
			{
				fileToUplaod.upload(request,upoadDataFieldName);
			}
			catch (error:ArgumentError)
			{
				throw new Error("An Argument Error has occurred: " + error);
			}
			catch (error:SecurityError)
			{
				throw new Error("An Security Error has occurred: " + error);
			}
			catch (error:Error)
			{
				throw new Error("Unable to load URL: " + error);
			}
		}
		*/
	}
}