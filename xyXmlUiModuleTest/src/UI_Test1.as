package
{
	import com.yheng.xianyuan.xyXmlUiModule.XyXmlUiModule;
	
	public class UI_Test1 extends XyXmlUiModule
	{
		public function UI_Test1(uiXML:XML)
		{
			super(uiXML);
			
			trace(getItem("btn"));
			trace(getItem("label"));
			trace(getItem("none"));
		}
	}
}