package
{
	import advancedSounds.Main;
	import away3dbox2d.Main;
	import awayphysics.car.Main;
	import blitting.Main;
	import box2dstarling.Main;
	import cameramovement.Main;
	import complexbox2dobject.Main;
	import dragonbones.Main;
	import entity.Main;
	import flash.events.Event;
	import games.braid.Main;
	import games.hungryhero.Main;
	import games.live4sales.Main;
	import games.osmos.Main;
	import games.superhexagon.Main;
	import games.tinywings.Main;
	import groupobjects.Main;
	import mobilenapestarling.Main;
	import multiplayer.Main;
	import multiresolutions.Main;
	import objectpooling.Main;
	import simplecollision.Main;
	import soundpatchdemo.Main;
	import stage3dinteroperation.Main;
	import starlingdemo.Main;
	import starlingtiles.Main;
	import statetransitions.Main;
	import tiledmap.displaylist.Main;
	import tiledmap.starling.Main;
	import ui.Main;
	import vehicle.Main;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * TODO/NOTES :
	 * example 3 (Blitting) fails with physics.
	 * example 22 (stage3dinteroperation: resize event problem)
	 */
	
	public class CitrusExampleLauncher extends Sprite
	{
		
		/**
		 * index of the example to play in a total of 29 examples.
		 */
		public static const index:uint = 0;
		
		public static var examples:Array = [advancedSounds.Main, away3dbox2d.Main, awayphysics.car.Main, blitting.Main, box2dstarling.Main, cameramovement.Main, complexbox2dobject.Main, dragonbones.Main, entity.Main, games.braid.Main, games.hungryhero.Main, games.live4sales.Main, games.osmos.Main, games.superhexagon.Main, games.tinywings.Main, groupobjects.Main, mobilenapestarling.Main, multiplayer.Main, multiresolutions.Main, objectpooling.Main, simplecollision.Main, soundpatchdemo.Main, stage3dinteroperation.Main, starlingdemo.Main, starlingtiles.Main, statetransitions.Main, tiledmap.displaylist.Main, tiledmap.starling.Main, ui.Main, vehicle.Main];
		
		public function CitrusExampleLauncher()
		{
			
			var example:* = new examples[index]();
			
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void
				{
					e.target.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
					addChild(example as DisplayObjectContainer);
				});
		}
	
	}

}