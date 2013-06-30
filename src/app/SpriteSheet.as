package app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class SpriteSheet {
		private var _model:AnimationModel;
		private var _data:BitmapData;
		private var _elapsed:Number = 0;
		private var _drawPosition:Point = new Point();

		private var _frameWidth:int;
		private var _frameHeight:int;
		private var _frameIndex:int;
		
		public function set image(image:Bitmap):void {
			_data = image.bitmapData;
		}
		
		public function SpriteSheet(model:AnimationModel) {
			_model = model;
		}
		
		public function draw(data:BitmapData, delta:int, containerBounds:Rectangle):void {
			if (_data == null)
				return;
			_frameWidth = _data.width / _model.cols;
			_frameHeight = _data.height / _model.rows;
			_drawPosition.x = (containerBounds.right - _frameWidth) * 0.5;
			_drawPosition.y = (containerBounds.bottom - _frameHeight) * 0.5;
			_frameIndex = getNextFrameIndex(delta);
			
			var row:int = _frameIndex / _model.cols;
			var col:int = _frameIndex % _model.cols;
			data.copyPixels(_data,
				new Rectangle(_frameWidth * col, _frameHeight * row, _frameWidth, _frameHeight),
				_drawPosition, null, null, false);
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