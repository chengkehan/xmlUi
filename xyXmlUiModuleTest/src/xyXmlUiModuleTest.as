package
{
	import com.yheng.xianyuan.xyComponent.control.Button;
	import com.yheng.xianyuan.xyComponent.control.Scale9GridDisplayObject;
	import com.yheng.xianyuan.xyComponent.core.XYComponent;
	import com.yheng.xianyuan.xyXmlUiModule.XyXmlUiModule;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class xyXmlUiModuleTest extends Sprite
	{
		[Embed(source="prototype.xml", mimeType="application/octet-stream")]
		private var PrototypeData:Class;
		
		[Embed(source="units.xml", mimeType="application/octet-stream")]
		private var UnitsData:Class;
		
		[Embed(source="ui_test1.xml", mimeType="application/octet-stream")]
		private var UI_Test1_Data:Class;
		
		private var _loader:Loader = null;
		
		public function xyXmlUiModuleTest()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.load(new URLRequest("resources.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function completeHandler(event:Event):void
		{
			var prototypeBytes:ByteArray = new PrototypeData();
			var prototypeXML:XML = new XML(prototypeBytes.readUTFBytes(prototypeBytes.bytesAvailable));
			
			var unitsBytes:ByteArray = new UnitsData();
			var unitsXML:XML = new XML(unitsBytes.readUTFBytes(unitsBytes.bytesAvailable));
			
			XyXmlUiModule.initialize(prototypeXML, unitsXML, ApplicationDomain.currentDomain, ApplicationDomain.currentDomain);
			
			var uiBytes:ByteArray = new UI_Test1_Data();
			var uiXML:XML = new XML(uiBytes.readUTFBytes(uiBytes.bytesAvailable));
			
			XYComponent.initialize(this);
			var ui:UI_Test1 = new UI_Test1(uiXML);
			addChild(ui);
		}
	}
}