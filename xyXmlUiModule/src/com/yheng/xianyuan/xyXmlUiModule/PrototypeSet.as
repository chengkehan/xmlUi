package com.yheng.xianyuan.xyXmlUiModule
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	internal class PrototypeSet implements IDestroy
	{
		public static const PROPERTY:String = "property";
		
		public static const METHOD:String = "method";
		
		public static const COMPLEX:String = "complex";
		
		private var _name:String = null;
		
		private var _type:String = null;
		
		public function PrototypeSet(name:String, type:String)
		{
			_name = name;
			_type = type;
		}

		public function get name():String
		{
			return _name;
		}

		public function get type():String
		{
			return _type;
		}
		
		public function destroy():void
		{
			// Do nothing
		}

	}
}