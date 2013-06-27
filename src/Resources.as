package {
	import com.pblabs.engine.resource.ResourceBundle;
	
	public final class Resources extends ResourceBundle {
		[Embed(source="assets/levels/levelDescriptions.xml")]
		public var levelDescriptions:Class;
		
		[Embed(source="assets/levels/mainscreen.xml")]
		public var mainScreen:Class;
	}
}
