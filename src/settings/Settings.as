package settings {
	import flash.net.SharedObject;
	
	public final class Settings {
		public static const WINDOW_X:String = "window.x";
		public static const WINDOW_Y:String = "window.y";
		public static const WINDOW_WIDTH:String = "window.width";
		public static const WINDOW_HEIGHT:String = "window.height";
		public static const WINDOW_STATE:String = "window.state";
		
		public static const OPTION_SAVE_WINDOW_STATE:String = "option.saveWindowState";
		public static const OPTION_SAVE_LAST_FILE:String = "option.saveLastFile";
		public static const OPTION_LAST_FILE_URL:String = "option.lastFileUrl";
		public static const OPTION_LAST_FILE_ROWS:String = "option.lastFileRows";
		public static const OPTION_LAST_FILE_COLS:String = "option.lastFileCols";
		public static const OPTION_CHECK_FOR_UPDATES:String = "option.checkUpdates";
		
		private static const PATH:String = "com.ffcreations.SpriteSheetPreview";
		private static var _options:SharedObject;
		
		public static function get(key:String, defaultValue:*):* {
			if (_options.data.hasOwnProperty(key))
				return _options.data[key];
			return defaultValue;
		}
		
		public static function getString(key:String, defaultValue:String):String {
			return get(key, defaultValue) as String;
		}
		
		public static function getInt(key:String, defaultValue:int):int {
			var s:Number = parseInt(get(key, defaultValue));
			if (isNaN(s))
				return defaultValue;
			return int(s);
		}
		
		public static function getNumber(key:String, defaultValue:Number):Number {
			var s:Number = parseInt(get(key, defaultValue));
			if (isNaN(s))
				return defaultValue;
			return s;
		}
		
		public static function getBoolean(key:String, defaultValue:Boolean):Boolean {
			return get(key, defaultValue);
		}
		
		public static function set(key:String, value:*):void {
			_options.data[key] = value;
		}
		
		public static function open():void {
			_options = SharedObject.getLocal(PATH);
		}
		
		public static function save():void {
			_options.flush();
		}
	}
}
