package org.frest.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.FileReference;
	
	import org.frest.delegates.GenericDelegate;
	import org.frest.utils.FrUtils;

	public class DoAttachmentCommand extends GenericCommand
	{
		private var action:String="";
		private var model:Object="";
		private var fileRef:FileReference;
		private var updArray:Array=[];
		private var sendmethod:String="POST";

		public function DoAttachmentCommand()
		{
			super();
		}
		public override function result(data:Object):void
		{
			if (onSuccess != null)
			{
				onSuccess.call(this, data);
			}
		}
		public override function execute(event:CairngormEvent):void
		{
			if(event.data is Object)
			{
				if(event.data.hasOwnProperty("onSuccess")) onSuccess = event.data["onSuccess"];
				if(event.data.hasOwnProperty("onFailure")) onFailure = event.data["onFailure"];
				if(event.data.hasOwnProperty("model")) model = event.data["model"];
				if(event.data.hasOwnProperty("fileReference")) fileRef = event.data["fileReference"] as FileReference;
				var delegate :GenericDelegate = new GenericDelegate(this);
//				delegate.uploadfile(fileRef,FrUtils.getRestURL(model,"attach"),model);
			}
		}
		public override function fault(info:Object):void
		{
			if (onFailure != null)
			{
				onFailure.call(this, info);
			}
		}
	}
}