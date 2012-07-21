package com.yheng.xianyuan.xyXmlUiModule
{
	import com.adobe.utils.StringUtil;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	internal class UnitsManager
	{
		private var _prototypeXML:XML = null;
		
		private var _unitsXML:XML = null;
		
		private var _resAppDomain:ApplicationDomain = null;
		
		private var _componentAppDomain:ApplicationDomain = null;
		
		private var _prototypes:Dictionary/*key id:String, value:Prototype*/ = null;
		
		private var _units:Dictionary/*key id:String, value:Unit*/ = null;
		
		private var _resources:Dictionary/*key id:String, value:Resource*/ = null;
		
		public function UnitsManager()
		{
			
		}
		
		public function newUnit(unitID:String):*
		{
			if(_units[unitID] == null)
			{
				throw new NoSuchObjectException("Has not the unit id \"" + unitID + "\"");
			}
			
			var unit:Unit = _units[unitID];
			var prototype:Prototype = _prototypes[unit.prototype];
			var obj:Object = new (prototype.clazz)();
			for each(var set:UnitSet in unit.setList)
			{
				var prototypeSet:PrototypeSet = getPrototypeSet(prototype, set.name);
				if(set.targetType == UnitSet.RESOURCE)
				{
					var resource:Resource = getResource(set.target);
					unitSet(obj, set.name, prototypeSet.type, resource.bitmapData);
				}
				else if(set.targetType == UnitSet.UNIT)
				{
					unitSet(obj, set.name, prototypeSet.type, newUnit(set.target));
				}
				else if(set.targetType == UnitSet.VALUE)
				{
					unitSet(obj, set.name, prototypeSet.type, set.target);
				}
				else
				{
					throw new IllegalParameterException("Illegal setTargetType \"" + set.targetType + "\"");
				}
			}
			
			return obj;
		}
		
		public function setUnit(obj:Object, setXMLList:XMLList, unitID:String):void
		{
			var unit:Unit = _units[unitID];
			var prototype:Prototype = _prototypes[unit.prototype]
			for each(var setXML:XML in setXMLList)
			{
				var prototypeSet:PrototypeSet = getPrototypeSet(prototype, setXML.@name);
				unitSet(obj, setXML.@name, prototypeSet.type, setXML.@value);
			}
		}
		
		public function initialize(prototypeXML:XML, unitsXML:XML, resAppDomain:ApplicationDomain, componentAppDomain:ApplicationDomain):void
		{
			if(prototypeXML == null)
			{
				throw new NullPointerException("Null input prototype parameter.");
			}
			if(unitsXML == null)
			{
				throw new NullPointerException("Null input unitsXML parameter.");
			}
			if(resAppDomain == null)
			{
				throw new NullPointerException("Null input clazzAppDomain parameter.");
			}
			if(componentAppDomain == null)
			{
				throw new NullPointerException("Null input componentAppDomain parmeter.");
			}
			
			disposeAll();
			
			_resources = new Dictionary();
			_resAppDomain = resAppDomain;
			_componentAppDomain = componentAppDomain;
			_prototypeXML = prototypeXML;
			_unitsXML = unitsXML;
			initializePrototypes();
			initializeUnits();
		}
		
		private function initializePrototypes():void
		{
			_prototypes = new Dictionary();
			var prototypeXMLList:XMLList = _prototypeXML.children();
			for each(var prototypeXML:XML in prototypeXMLList)
			{
				var id:String = prototypeXML.@id;
				var type:String = prototypeXML.@type;
				var clazz:Class = Class(_componentAppDomain.getDefinition(type));
				var setList:Vector.<PrototypeSet> = new Vector.<PrototypeSet>();
				var setXMLList:XMLList = prototypeXML.children();
				for each(var setXML:XML in setXMLList)
				{
					var setName:String = setXML.@name;
					var setType:String = setXML.@type;
					var set:PrototypeSet = new PrototypeSet(setName, setType);
					setList.push(set);
				}
				var prototype:Prototype = new Prototype(id, type, clazz, setList);
				_prototypes[id] = prototype;
			}
		}
		
		private function initializeUnits():void
		{
			_units = new Dictionary();
			var unitXMLList:XMLList = _unitsXML.children();
			for each(var unitXML:XML in unitXMLList)
			{
				var id:String = unitXML.@id;
				var prototype:String = unitXML.@prototype;
				var setList:Vector.<UnitSet> = new Vector.<UnitSet>();
				var setXMLList:XMLList = unitXML.children();
				for each(var setXML:XML in setXMLList)
				{
					var setName:String = setXML.@name;
					var setRes:String = setXML.@res;
					var setUnit:String = setXML.@unit;
					var setValue:String = setXML.@value;
					var setTarget:String = null;
					var setTargetType:String = null;
					if(setRes != "")
					{
						setTarget = setRes;
						setTargetType = UnitSet.RESOURCE;
					}
					else if(setUnit != "")
					{
						setTarget = setUnit;
						setTargetType = UnitSet.UNIT;
					}
					else if(setValue != "")
					{
						setTarget = setValue;
						setTargetType = UnitSet.VALUE;
					}
					else
					{
						throw new IllegalParameterException();
					}
					var set:UnitSet = new UnitSet(setName, setTarget, setTargetType);
					setList.push(set);
				}
				var unit:Unit = new Unit(id, prototype, setList);
				_units[id] = unit;
			}
		}
		
		private function getResource(res:String):Resource
		{
			var resource:Resource = _resources[res];
			if(resource == null)
			{
				var bmpdClazz:Class = Class(_resAppDomain.getDefinition(res));
				resource = new Resource(res, new bmpdClazz());
				_resources[res] = resource;
			}
			
			return resource;
		}
		
		private function getPrototypeSet(prototype:Prototype, name:String):PrototypeSet
		{
			for each(var set:PrototypeSet in prototype.setList)
			{
				if(set.name == name)
				{
					return set;
				}
			}
			
			throw new NoSuchObjectException("Can not find the prototypeSet \"" + name + "\"");
			return null;
		}
		
		private function unitSet(unit:Object, setName:String, setType:String, target:Object):void
		{
			var targetStr:String = String(target);
			var targetNew:Object = targetStr == "true" || targetStr == "false" ? StringUtil.toBoolean(targetStr) : target;
			
			if(setType == PrototypeSet.METHOD)
			{
				unit[setName](targetNew);
			}
			else if(setType == PrototypeSet.PROPERTY)
			{
				unit[setName] = targetNew;
			}
			else if(setType == PrototypeSet.COMPLEX)
			{
				var setNameBlocks:Array = setName.split(".");
				var setNameBlocksLength:int = setNameBlocks.length;
				for (var i:int = 0; i < setNameBlocksLength; i++) 
				{
					var setNameBlock:String = setNameBlocks[i];
					if(i == setNameBlocksLength - 1)
					{
						if(setNameBlock.indexOf("()") == -1)
						{
							unit[setNameBlock] = targetNew;
						}
						else
						{
							unit[setNameBlock.substring(0, setNameBlock.length - 2)](targetNew);
						}
					}
					else
					{
						if(setNameBlock.indexOf("()") == -1)
						{
							unit = unit[setNameBlock];
						}
						else
						{
							unit = unit[setNameBlock.substring(0, setNameBlock.length - 2)]();
						}
					}
				}
			}
			else
			{
				throw new IllegalParameterException("Illegal propertySetType \"" + setType + "\"");
			}
		}
		
		private function disposeAll():void
		{
			_prototypeXML = null;
			_unitsXML = null;
			_resAppDomain = null;
			_componentAppDomain = null;
			
			DestroyUtil.destroyMap(_prototypes);
			_prototypes = null;
			DestroyUtil.destroyMap(_units);
			_units = null;
			
			for each(var resource:Resource in _resources)
			{
				if(resource != null && resource.bitmapData != null)
				{
					resource.bitmapData.dispose();
				}
			}
			
			DestroyUtil.destroyMap(_resources);
			_resources = null;
		}
	}
}