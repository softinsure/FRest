/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: IServiceController.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.controllers
{
	import mx.rpc.IResponder;

	public interface IServiceController
	{
		function sendRequest(requestURL:String, responder:IResponder, requestMathod:String=null, request:Object=null,sendXML:Boolean=false, resultFormat:String="e4x", useProxy:Boolean=false):void
		function loadRequest(requestURL:String, responseCatcher:Function, moreArgumentWithCatcher:Array=null, requestMathod:String=null, dataFormat:String="e4x"):void
	}
}