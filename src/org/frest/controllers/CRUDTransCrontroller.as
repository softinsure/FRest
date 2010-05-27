/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: CRUDTransController.as 
 * Project Name: FRest 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.frest.controllers
{
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;
	/**
	 * controls CRUD transaction and singletone class
	 * uses: CRUDTransCrontroller.getInstance()
	 * @author Goutam
	 * 
	 */
	public class CRUDTransCrontroller
	{
		protected var modelQueue:Array=[];
		protected var transType:Array=[];
		protected var pModel:Array=[];
		private static var crudTransaction:CRUDTransCrontroller;
		private var complete:Boolean=true;
		private var oldAfterTrans:Function;
		public static function getInstance():CRUDTransCrontroller{
			if (crudTransaction == null)
			{
				crudTransaction = new CRUDTransCrontroller();
			}
			return crudTransaction;
		}
		/**
		 * used to check if all transactions are completed 
		 * @return 
		 * 
		 */
		public function get completed():Boolean
		{
			return complete;
		}
		public function CRUDTransCrontroller()
		{
			if (crudTransaction != null)
			{
				throw new Error("Only one CRUDTransCrontroller instance may be instantiated.");
			}
		}
		/**
		 * used this function variable to assign after transaction method 
		 */
		public var actionAfterAllTransactions:Function = function ():void{};
		/**
		 * used to add model for transaction in the queue
		 *  
		 * @param model 
		 * @param type : transaction type like 'create', update'
		 * @param parent : belongs to model
		 * 
		 */
		public function addModelToQueue(model:FrModel,type:String,parent:Object=null):void
		{
			modelQueue.push(model);
			transType.push(type);
			pModel.push(parent as FrModel);
		}
		/**
		 * used to add model for immediate transaction in the queue 
		 * during the wholle transaction process
		 * @param model
		 * @param type
		 * @param parent
		 * 
		 */
		public function addModelAsFirstElementOfQueue(model:FrModel,type:String,parent:Object=null):void
		{
			modelQueue.unshift(model);
			transType.unshift(type);
			pModel.unshift(parent as FrModel);
		}
		/**
		 * used to trigger next transaction in the queue 
		 * 
		 */
		public function doNextTransaction():void
		{
			if(this.hasAnyTransaction)
			{
				var parent:FrModel=pModel.shift() as FrModel;
				var model:FrModel=modelQueue.shift() as FrModel;
				if(parent!=null)
				{
					FrUtils.addParentID(parent,model);
				}
				complete=false;
				model.performCRUD(transType.shift());
			}
			else
			{
				complete=true;
				if(actionAfterAllTransactions!=null)
				{
					oldAfterTrans=actionAfterAllTransactions;
					actionAfterAllTransactions.call(this);
					if(oldAfterTrans==actionAfterAllTransactions)
					{
						actionAfterAllTransactions=null;
						oldAfterTrans=null;
					}
				}
			}
		}
		/**
		 * used to check if there is any transaction 
		 * @return 
		 * 
		 */
		public function get hasAnyTransaction():Boolean
		{
			return modelQueue.length>0;
		}
		/**
		 * clears all pending transactions from the queue 
		 * 
		 */
		public function clearModelQueue():void
		{
			modelQueue=[];
			transType=[];
			actionAfterAllTransactions=null;
			complete=true;
		}
		/**
		 * stop transactions 
		 * 
		 */
		public function stop():void
		{
			modelQueue=[];
			transType=[];
			actionAfterAllTransactions=null;
			complete=false;
		}
	}
}