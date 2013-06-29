package app
{
	import flash.filesystem.File;

	//TODO maybe remove this class and put the behaviour inside the model
	public final class ResourceController
	{
		private var _model:AnimationModel;
		
		public function ResourceController(animationModel:AnimationModel) {
			_model = animationModel;
		}
		
		public function set imageURL(value:String):void {
			if (!isValidFileURL(value))
				return;
			
			_model.url = value;
			trace(value);
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