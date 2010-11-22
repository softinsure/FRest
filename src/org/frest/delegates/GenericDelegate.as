/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: GenericDelegate.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.delegates
{
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	
	import mx.containers.utilityClasses.PostScaleAdapter;
	import mx.rpc.IResponder;
	
	import org.frest.Fr;
	import org.osmf.traits.IDisposable;

	public class GenericDelegate implements IDelegate, IDisposable
	{
		public function dispose():void
		{
			_responder=null;
		}
		private var _responder : IResponder;
		public function GenericDelegate(responder:IResponder)
		{
			_responder=responder;
		}
/*		public function uploadfile(fileToUpload:FileReference,restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.uploadFile(fileToUpload,restURL,_responder,object);
		}
*/		public function create(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"POST",object,true);
		}

		public function update(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"PUT",object);
		}

		public function destroy(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"DELETE");
		}

		public function index(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder);
		}
		public function show(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder);
		}
		public function others(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder);
		}
		public function search(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"POST",object,true);
		}
		public function list(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"POST",object,true);
		}
		public function otherspost(restURL:String, object:*=null, objectID:String=null):void
		{
			Fr.httpSend(restURL,_responder,"POST",object,true);
		}
	}
}