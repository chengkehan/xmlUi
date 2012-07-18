package com.yheng.xianyuan.xyXmlUiModule
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	internal class Unit implements IDestroy
	{
		private var _id:String = null;
		
		private var _prototype:String = null;
		
		private var _setList:Vector.<UnitSet> = null;
		
		public function Unit(id:String, prototype:String, setList:Vector.<UnitSet>)
		{
			_id = id;
			_prototype = prototype;
			_setList = setList;
		}

		public function get id():String
		{
			return _id;
		}

		public function get prototype():String
		{
			return _prototype;
		}

		public function get setList():Vector.<UnitSet>
		{
			return _setList;
		}
		
		public function destroy():void
		{
			DestroyUtil.destroyVector(_setList);
			_setList = null;
		}
	}
}