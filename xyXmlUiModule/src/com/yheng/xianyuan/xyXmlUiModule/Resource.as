package com.yheng.xianyuan.xyXmlUiModule
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;

	internal class Resource implements IDestroy
	{
		private var _id:String = null;
		
		private var _bmpd:BitmapData = null;
		
		public function Resource(id:String, bmpd:BitmapData)
		{
			_id = id;
			_bmpd = bmpd;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bmpd;
		}
		
		public function destroy():void
		{
			_bmpd = null;
		}
	}
}