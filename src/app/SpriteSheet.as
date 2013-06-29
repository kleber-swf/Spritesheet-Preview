package app
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class SpriteSheet
	{
		[Embed(source="/SpriteSheetPreview/src/assets/images/swordguy.png")]
		public var SWORDGUY:Class;
		
		private var _model:AnimationModel;
		
		private var _data:BitmapData;
		
		private var _elapsed:Number = 0;
		
		public function SpriteSheet(model:AnimationModel)
		{
			_model = model;
			_data = new SWORDGUY().bitmapData;
		}
		
		public function draw(data:BitmapData, delta:int):void {
			if (_data == null)
				return;
			var frameWidth:int = _data.width / _model.cols;
			var frameHeight:int = _data.height / _model.rows;
			
			var frameIndex:int = getNextFrameIndex(delta);
			
			var row:int = frameIndex / _model.cols;
			var col:int = frameIndex % _model.cols;
			data.copyPixels(_data,
				new Rectangle(frameWidth * col, frameHeight * row, frameWidth, frameHeight),
				new Point(0, 0), null, null, false);
		}
		
		private function getNextFrameIndex(delta:int):int {
			if (_model.playing) {
				var delay:int = 1000 / _model.fps;
				_elapsed += delta;
				if (_elapsed >= delay) {
					_elapsed = 0;
					var nextFrame:int = (_model.totalFrames + _model.currentFrame + 1) % _model.totalFrames;
					if (!_model.loop && nextFrame == 0 && nextFrame < _model.currentFrame)
						_model.playing = false;
					_model.currentFrame = nextFrame;
				}
			}
			return _model.currentFrame;
		}
	}
}