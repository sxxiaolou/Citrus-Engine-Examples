package advancedSounds
{
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.view.starlingview.StarlingArt;
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import advancedSounds.AdvancedSoundsState;
	
	public class Main extends StarlingCitrusEngine
	{
		public static var assets:AssetManager;
		
		public function Main():void {}
		
		override protected function handleAddedToStage(e:flash.events.Event):void
		{
			super.handleAddedToStage(e);
			setUpStarling(true, 1);
		}
		
		override protected function _context3DCreated(e:starling.events.Event):void
		{
			super._context3DCreated(e);
			
			assets = new AssetManager();
			
			assets.enqueue("sounds/loop.mp3");
			
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					start();
				}
			});
			
		}
		
		protected function start():void
		{
			//sound added with asset manager
			sound.addSound("loop", { sound:assets.getSound("loop") ,permanent:true, volume:0.6 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );
			
			//sounds added with url
			sound.addSound("beep1", { sound:"sounds/beep1.mp3" ,autoload:true , group:CitrusSoundGroup.SFX } );
			sound.addSound("beep2", { sound:"sounds/beep2.mp3" ,autoload:true , group:CitrusSoundGroup.SFX } );
			
			sound.getGroup(CitrusSoundGroup.SFX).volume = 0.12;
			
			state = new AdvancedSoundsState();
		}
		
	}
	
}