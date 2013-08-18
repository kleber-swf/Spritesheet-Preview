package app {
	import flash.events.EventDispatcher;
	
	[Bindable]
	public final class AnimationModel extends EventDispatcher {
		private var _rows:int = 1;
		private var _cols:int = 1;
		private var _fps:int = 20;
		private var _totalFrames:int = 0;
		private var _startFrame:int = 0;
		private var _endFrame:int = 0;
		private var _frames:Array;
		
		public var loop:Boolean = true;
		public var pingpong:Boolean = false;
		public var playing:Boolean = false;
		public var currentFrame:int = 0;
		
		public function get startFrame():int {
			return _startFrame;
		}
		
		public function set startFrame(value:int):void {
			if (value > _endFrame)
				value = _endFrame;
			_startFrame = value;
			if (currentFrame < _startFrame)
				currentFrame = _startFrame;
			createFrameList();
		}
		
		private function createFrameList():void {
			_frames = new Array();
			for (var i:int = startFrame; i <= endFrame; i++)
				_frames.push(i);
		}
		
		public function get endFrame():int {
			return _endFrame;
		}
		
		public function set endFrame(value:int):void {
			if (value < _startFrame)
				value = _startFrame;
			_endFrame = value;
			if (currentFrame > _endFrame)
				currentFrame = _endFrame;
			createFrameList();
		}
		
		public function get totalFrames():int {
			return _totalFrames;
		}
		
		public function set totalFrames(value:int):void {
			_totalFrames = value;
			endFrame = totalFrames - 1;
			createFrameList();
		}
		
		public function get fps():int {
			return _fps;
		}
		
		public function set fps(value:int):void {
			_fps = value > 1 ? value : 1;
		}
		
		public function get rows():int {
			return _rows;
		}
		
		public function set rows(value:int):void {
			_rows = value > 1 ? value : 1;
			totalFrames = _rows * _cols;
		}
		
		public function get cols():int {
			return _cols;
		}
		
		public function set cols(value:int):void {
			_cols = value > 1 ? value : 1;
			totalFrames = _rows * _cols;
		}
		
		public function get frames():Array {
			return _frames;
		}
	}
}
