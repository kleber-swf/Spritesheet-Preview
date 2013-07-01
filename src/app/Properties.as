package app {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public final class Properties {
		private static const FILE:String = "config.cfg";
		
		private var _properties:Object = new Object();
		
		public function getInt(key:String, defaultValue:int):int {
			var stringValue:String = _properties.hasOwnProperty(key) ? _properties[key] : null;
			if (!stringValue)
				return defaultValue;
			var value:Number = parseInt(stringValue);
			return isNaN(value) ? defaultValue : value;
		}
		
		public function set(key:String, value:*):void {
			_properties[key] = value.toString();
		}
		
		public function Properties() {
			var file:File = File.applicationStorageDirectory.resolvePath(FILE);
			if (!file.exists) {
				setupDefaultProperties();
				return;
			}
			var stream:FileStream = new FileStream();
			try {
				stream.open(file, FileMode.READ);
				loadProperties(stream.readUTFBytes(stream.bytesAvailable));
			} finally {
				stream.close();
			}
		}
		
		private function loadProperties(stream:String):void {
			var lines:Array = stream.split("\n");
			for (var i:int = 0; i < lines.length; i++) {
				var line:Array = lines[i].split('=');
				if (line.length != 2)
					continue;
				_properties[line[0]] = line[1];
			}
		}
		
		private function setupDefaultProperties():void {
			_properties['window.width'] = '780';
			_properties['window.height'] = '520';
		}
		
		public function saveAndClose():void {
			var content:String = "";
			for (var s:String in _properties)
				content += s + "=" + _properties[s] + "\n";
			
			var file:File = File.applicationStorageDirectory.resolvePath(FILE);
			var stream:FileStream = new FileStream();
			try {
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(content);
			} finally {
				stream.close();
			}
		
		}
	}
}
