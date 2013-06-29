package app {
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public final class SpriteSheetController extends TickedComponent {
		public var background:SimpleShapeRenderer;
		public var animator:AnimatorComponent;
		public var spriteSheet:SpriteSheetComponent;
		
		private var _rows:int = 1;
		private var _cols:int = 1;
		private var _fps:int = 20;
		private var _url:String;
		private var _dirty:Boolean;
		private var _loop:Boolean = true;
		private var _currentAnimator:Animator;
		
		public function get currentAnimator():Animator {
			return _currentAnimator;
		}
		
		public function set rows(value:int):void {
			_rows = value > 0 ? value : 1;
			_dirty = true;
		}
		
		public function set cols(value:int):void {
			_cols = value > 0 ? value : 1;
			_dirty = true;
		}
		
		public function set fps(value:int):void {
			_fps = value > 0 ? value : 1;
			_dirty = true;
		}
		
		public function set url(value:String):void {
			_url = value;
			_dirty = true;
		}
		
		public function set loop(value:Boolean):void {
			_loop = value;
			_dirty = true;
		}
		
		public function get isPlaying():Boolean { return _currentAnimator != null && _currentAnimator.isAnimating; }
		
		public override function onTick(deltaTime:Number):void {
			if (!_dirty)
				return;
			update();
			_dirty = false;
		}
		
		public function update():void {
			if (_url == null)
				return;
			spriteSheet.imageFilename = _url;
			
			var divider:CellCountDivider = new CellCountDivider();
			divider.xCount = _cols;
			divider.yCount = _rows;
			spriteSheet.divider = divider;
			
			var a:Animator = animator.animations != null && animator.animations.hasOwnProperty("play") ? animator.animations["play"] : new Animator();
			a.animationType = _loop ? AnimatorType.LOOP_ANIMATION : AnimatorType.PLAY_ANIMATION_ONCE;
			a.duration = _rows * _cols / _fps;
			a.repeatCount = -1;
			a.startValue = 1;
			a.targetValue = (_rows * _cols) + 1;
			
			var animations:Dictionary = new Dictionary();
			animations["play"] = a;
			_currentAnimator = a;
			
			animator.animations = animations;
		}
		
		public function play():void {
			if (!animator.animations.hasOwnProperty("play"))
				return;
			animator.animations["play"].startValue = 0;
			animator.play("play");
		}
		
		public function stop():void {
			if (!animator.animations.hasOwnProperty("play"))
				return;
			animator.animations["play"].stop();
		}
		
		public function gotoFrame(frame:int):void {
			if (!animator.animations.hasOwnProperty("play"))
				return;
			var a:Animator = animator.animations["play"];
			animator.play("play", frame);
			a.stop();
			//a.currentValue = Math.round(frame * a.targetValue);
		}
	}
}
