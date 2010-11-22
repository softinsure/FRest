/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
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
		function loadRequest(requestURL:String, responseCatcher:*, moreArgumentWithCatcher:Array=null, requestMathod:String=null, dataFormat:String="e4x"):void
	}
}