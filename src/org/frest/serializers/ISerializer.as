/*******************************************************************************
 * Copyright  2010-2011 SoftInsure. All rights reserved.
 * Author: SoftInsure 
 * File Name: ISerializer.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ****************************************************************************/
package org.frest.serializers
{
	import org.frest.models.FrModel;


	public interface ISerializer
	{
		function marshall(object:Object, recursive:Boolean=false):Object;
		function unmarshall(fromObject:Object, toObject:FrModel, disconnected:Boolean=false):Object;
	}
}