package com.yheng.xianyuan.xyXmlUiModule
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	internal class UnitSet implements IDestroy
	{
		public static const RESOURCE:String = "res";
		
		public static const UNIT:String = "unit";
		
		public static const VALUE:String = "value";
		
		private var _name:String = null;
		
		private var _target:String = null;
		
		private var _targetType:String = null;
		
		public function UnitSet(name:String, target:String, targetType:String)
		{
			_name = name;
			_target = target;
			_targetType = targetType
		}

		public function get name():String
		{
			return _name;
		}

		public function get invoke():String
		{
			return _target;
		}

		public function get target():String
		{
			return _target;
		}
		
		public function get targetType():String
		{
			return _targetType;
		}

		public function destroy():void
		{
			// Do nothing
		}
	}
}