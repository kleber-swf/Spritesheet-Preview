package app {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	//TODO maybe remove this class and put the behaviour inside the model
	public final class ResourceController {
		private var _image:Bitmap;
		private var _loading:Boolean;
		public var onImageLoadSuccess:Function;
		public var onImageLoadError:Function;
		private var _imageURL:String;
		
		public function get image():Bitmap {
			return _image;
		}
		
		public function get loading():Boolean {
			return _loading;
		}
		
		public function get imageURL():String {
			return _imageURL;
		}
		
		public function set imageURL(value:String):void {
			if (!isValidFileURL(value)) {
				if (onImageLoadError != null)
					onImageLoadError("Invalid image file");
				_imageURL = "";
				return;
			}
			
			_imageURL = value;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(value));
			_loading = true;
		}
		
		private function onLoadError(event:IOErrorEvent):void {
			if (onImageLoadError != null)
				onImageLoadError("I/O Error");
		}
		
		private function onLoadComplete(event:Event):void {
			_image = event.target.content as Bitmap;
			_loading = false;
			if (onImageLoadSuccess != null)
				onImageLoadSuccess(_image);
		}
		
		private function isValidFileURL(url:String):Boolean {
			var file:File;
			try {
				file = new File(url);
			} catch (e:ArgumentError) {
				return false;
			}
			var extension:String = file.extension;
			return file.exists && (extension == "png" || extension == "jpg" || extension == "gif");
		}
	}
}
