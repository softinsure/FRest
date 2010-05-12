/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Inspired by RestfulX and pomodo 
 * Author: Goutam 
 * File Name: FrUtils.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.rpc.IResponder;
	import org.frest.controllers.CRUDTransCrontroller;
	import org.frest.controllers.FrModelsController;
	import org.frest.controllers.HTTPServiceController;
	import org.frest.serializers.XMLSerializer;

	 /**
	 * Provides central access to a number of frequently used subsystems, configuration 
	 * options and helpers. Only static functions are available
	 *  
	 * @author Goutam
	 * 
	 */	
	public class Fr
	{
		/*
		public function Fr()
		{
			//TODO: implement function
		}
		*/
		public static var log:ILogger = Log.getLogger("org.frest");
		
		/** default http controller implementation to use */
    	public static var httpController:HTTPServiceController = new HTTPServiceController();
    	public static var serializer:XMLSerializer= new XMLSerializer();
    	public static var models:FrModelsController= FrModelsController.getInstance();
 		public static var crudTransactionQueue:CRUDTransCrontroller= CRUDTransCrontroller.getInstance();
		public static function httpSend(requestURL:String, responder:IResponder, requestMathod:String=null,request:Object=null, sendXML:Boolean=false,resultFormat:String="e4x", useProxy:Boolean=false):void
   		{
      		httpController.sendRequest(requestURL,responder,requestMathod,request,sendXML,resultFormat,useProxy);
    	}
   		public static function httpLoad(requestURL:String, responseCatcher:Function, moreArgumentWithCatcher:Array=null, requestMathod:String=null,dataFormat:String="e4x"):void
   		{
      		httpController.loadRequest(requestURL,responseCatcher,moreArgumentWithCatcher,requestMathod,dataFormat);
    	}
		public static function enableLogging():void {
			var target:TraceTarget = new TraceTarget();
			target.filters = ["org.frest.*"];
			target.level = LogEventLevel.ALL;
			target.includeDate = true;
			target.includeTime = true;
			target.includeCategory = true;
			target.includeLevel = true;
			Log.addTarget(target);
		}	
}
}