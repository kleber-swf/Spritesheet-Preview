package app
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;

	public final class UpdateController
	{
		[Bindable]
		public var version:String;
		private var _appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		private var _url:String;
		
		public function UpdateController(url:String) {
			_url = url;
		}
		
		public function checkForUpdate(onError:Function):void {
			setApplicationVersion();
			_appUpdater.updateURL = _url;
			_appUpdater.isCheckForUpdateVisible = false;
			_appUpdater.addEventListener(UpdateEvent.INITIALIZED, function(e:UpdateEvent):void {_appUpdater.checkNow();});
			_appUpdater.addEventListener(ErrorEvent.ERROR, onError);
			_appUpdater.initialize();
		}
		
		private function setApplicationVersion():void {
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			
			var versionLabel:String = appXML.ns::versionLabel;
			version = appXML.ns::versionNumber + (versionLabel ? "-" + versionLabel : "");
		}
	}
}