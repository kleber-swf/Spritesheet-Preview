package app {
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.debug.Console;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SceneAlignment;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	
	public class Main extends Sprite {
		
		[Embed(source="/SpriteSheetPreview/src/assets/images/transparency.png")]
		private const TransparencyImage:Class;
		
		private var _controller:SpriteSheetController;
		private var _backgroundColor:uint = 0x666666;
		
		private var _mask:Sprite;
		private var _maskGraph:Graphics;
		private var _backgroundGraph:Graphics;
		private var _dirty:Boolean;
		private var _backgroundSprite:Sprite;
		private var _messageField:TextField;
		private var _hasContent:Boolean = false;
		private var _transparencyImage:BitmapData;
		private var _transparencyGraph:Graphics;
		private var _backgroundAlpha:Number = 1;
		
		public function set hasContent(value:Boolean):void {
			if (_hasContent == value)
				return;
			_hasContent = value;
			_backgroundSprite.removeChild(_messageField);
			_dirty = true;
		}
		
		public function get controller():SpriteSheetController { return _controller; }
		
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			_maskGraph.clear();
			_maskGraph.beginFill(value);
			_maskGraph.drawRect(0, 0, parent.width, parent.height);
			_maskGraph.endFill();
			
			if (_hasContent) {
				_backgroundGraph.clear();
				_backgroundGraph.beginFill(value, _backgroundAlpha);
				_backgroundGraph.drawRect(0, 0, parent.width, parent.height);
				_backgroundGraph.endFill();
				
				_transparencyGraph.clear();
				_transparencyGraph.beginBitmapFill(_transparencyImage, null, true, true);
				_transparencyGraph.drawRect(0, 0, parent.width, parent.height);
				_transparencyGraph.endFill();
			} else {
				_backgroundGraph.clear();
				_backgroundGraph.lineStyle(5, 0xFFFFFF, 0.3, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
				_backgroundGraph.beginFill(value);
				_backgroundGraph.drawRoundRect(10, 10, parent.width - 20, parent.height - 20, 40, 40);
				_messageField.x = (parent.width - _messageField.width) * 0.5;
				_messageField.y = (parent.height - _messageField.height) * 0.5;
			}
		}
		
		public function set backgroundAlpha(value:Number):void {
			_backgroundAlpha = value;
			_dirty = true;
		}
		
		public function Main() {
			if (stage == null)
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			else
				initialize();
		}
		
		private function initialize(e:Event = null):void {
			if (e)
				removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ENTER_FRAME, update);
			
			PBE.startup(this);
			PBE.inputManager.mouseMoveEnabled = false;
			PBE.inputManager.mouseOutEnabled = false;
			PBE.inputManager.mouseOverEnabled = false;
			PBE.inputManager.mouseWheelEnabled = false;
			
			var image:Bitmap = new TransparencyImage();
			_transparencyImage = image.bitmapData;
			
			registerComponents();
			PBE.levelManager.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, onLevelReady);
			PBE.levelManager.load("assets/levels/levelDescriptions.xml", 0);
			
			_mask = new Sprite();
			_backgroundSprite = new Sprite();
			var t:Sprite = new Sprite;
			
			_maskGraph = _mask.graphics;
			_backgroundGraph = _backgroundSprite.graphics;
			_transparencyGraph = t.graphics;
			
			_messageField = createMessageField();
			_backgroundSprite.addChild(_messageField);
			
			backgroundColor = _backgroundColor;
			
			createScene();
			addChild(_mask);
			addChildAt(_backgroundSprite, 0);
			addChildAt(t, 0);
		}
		
		private function createMessageField():TextField {
			var field:TextField = new TextField();
			field.width = 350;
			field.height = 40;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.selectable = false;
			field.alpha = 0.7;
			var format:TextFormat = new TextFormat("Arial", 30, 0xFFFFFF, true);
			format.align = TextAlign.CENTER;
			field.defaultTextFormat = format;
			field.text = "Drag a spritesheet here";
			return field;
		}
		
		protected function update(event:Event):void {
			if (!_dirty)
				return;
			resize();
			_dirty = false;
		}
		
		private function onResize(event:Event = null):void {
			_dirty = true;
			resize();
		}
		
		private function resize():void {
			PBE.scene.sceneView.width = parent.width;
			PBE.scene.sceneView.height = parent.height;
			backgroundColor = _backgroundColor;
			PBE.scene.sceneAlignment = SceneAlignment.TOP_LEFT;
			PBE.scene.sceneAlignment = SceneAlignment.CENTER;
		}
		
		private function onLevelReady(e:Event):void {
			_controller = PBE.lookupEntity("Main").lookupComponentByName("Controller") as SpriteSheetController;
			mask = _mask;
		}
		
		private function createScene():void {
			//			var scene:FlexSceneView = new FlexSceneView();
			var scene:SceneView = new SceneView();
			scene.width = parent.width;
			scene.height = parent.height;
			PBE.initializeScene(scene);
			PBE.IS_SHIPPING_BUILD = true;
			Logger.disable();
			Console.hotKeyCode = 0;
			
			var s:DisplayObjectScene = PBE.scene as DisplayObjectScene;
			if (s == null)
				return;
			s.maxZoom = 3;
			s.minZoom = 0.01;
		}
		
		private function registerComponents():void {
			PBE.registerType(SpriteSheetComponent);
			PBE.registerType(SpriteSheetRenderer);
			PBE.registerType(AnimatorComponent);
			PBE.registerType(SpriteSheetController);
		}
	}
}
