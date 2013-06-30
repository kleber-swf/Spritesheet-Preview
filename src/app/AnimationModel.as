package app
{
	import flash.events.EventDispatcher;

	[Bindable]
	public final class AnimationModel extends EventDispatcher {
		private var _rows:int = 1;
		private var _cols:int = 1;
		
		public var fps:int = 20;
		public var loop:Boolean = true;
		public var playing:Boolean = false;
		public var totalFrames:int = 0;
		public var currentFrame:int = 0;
		
		public function get rows():int {
			return _rows;
		}
		
		public function set rows(value:int):void {
			_rows = value;
			totalFrames = (_rows * _cols) - 1;
		}
		
		public function get cols():int {
			return _cols;
		}
		
		public function set cols(value:int):void {
			_cols = value;
			totalFrames = (_rows * _cols) - 1;
		}
	}
}