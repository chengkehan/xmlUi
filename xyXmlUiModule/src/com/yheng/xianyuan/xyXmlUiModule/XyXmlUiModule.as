package com.yheng.xianyuan.xyXmlUiModule
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	
	public class XyXmlUiModule extends Sprite
	{
		private var _items:Dictionary/*key id:String, value obj:DisplayObject*/ = null;
		
		public function XyXmlUiModule(uiXML:XML)
		{
			if(uiXML == null)
			{
				throw new NullPointerException("Null input uiXML parameter.");
			}
			
			initialize(uiXML);
		}
		
		public function containsItem(id:String):Boolean
		{
			return _items[id] != null;
		}
		
		public function getItem(id:String):*
		{
			return _items[id];
		}
		
		private function initialize(uiXML:XML):void
		{
			_items = new Dictionary();
			var itemXMLList:XMLList = uiXML.children();
			for each(var itemXML:XML in itemXMLList)
			{
				var item:* = _unitsManager.newUnit(itemXML.@unit);
				var itemID:String = itemXML.@id;
				
				if(containsItem(itemID))
				{
					throw new IllegalOperationException("Repeating item id \"" + itemID + "\"");
				}
				_items[itemID] = item;
				
				_unitsManager.setUnit(item, itemXML.children(), itemXML.@unit);
				addChild(item);
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// Static
		//------------------------------------------------------------------------------------------------------------------------------
		
		private static const _unitsManager:UnitsManager = new UnitsManager();
		
		public static function initialize(prototypeXML:XML, unitsXML:XML, clazzAppDomain:ApplicationDomain, componentAppDomain:ApplicationDomain):void
		{
			_unitsManager.initialize(prototypeXML, unitsXML, clazzAppDomain, componentAppDomain);
		}
	}
}