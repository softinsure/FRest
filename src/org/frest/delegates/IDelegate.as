/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: IDelegate.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.delegates
{
	public interface IDelegate
	{
		function create(restURL:String, object:*=null, objectID:String=null):void
		function update(restURL:String, object:*=null, objectID:String=null):void
		function destroy(restURL:String, object:*=null, objectID:String=null):void
		function index(restURL:String, object:*=null, objectID:String=null):void
		function show(restURL:String, object:*=null, objectID:String=null):void
		function search(restURL:String, object:*=null, objectID:String=null):void
	}
}