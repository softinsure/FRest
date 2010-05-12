/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: GenericDelegate.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.delegates
{
	import mx.rpc.IResponder;
	
	import org.frest.Fr;

	public class GenericDelegate implements IDelegate
	{
		private var _responder : IResponder;
		public function GenericDelegate(responder:IResponder)
		{
			_responder=responder;
		}

		public function create(restURL:String, object:*=null, objectID:String=null):void
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