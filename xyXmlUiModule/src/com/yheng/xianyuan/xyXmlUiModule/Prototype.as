package com.yheng.xianyuan.xyXmlUiModule
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	internal class Prototype implements IDestroy
	{
		private var _id:String = null;
		
		private var _type:String = null;
		
		private var _clazz:Class = null;
		
		private var _setList:Vector.<PrototypeSet> = null;
		
		public function Prototype(id:String, type:String, clazz:Class, setList:Vector.<PrototypeSet>)
		{
			_id = id;
			_type = type;
			_clazz = clazz;
			_setList = setList;
		}

		public function get id():String
		{
			return _id;
		}

		public function get type():String
		{
			return _type;
		}

		public function get clazz():Class
		{
			return _clazz;
		}
		
		public function get setList():Vector.<PrototypeSet>
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