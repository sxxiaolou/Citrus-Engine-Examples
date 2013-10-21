package multiresolutions {
	
	/**
	 * @author Aymeric
	 */
	public class Utils {

		static public function FindScaleFactor(screenWidth:Number, screenHeight:Number):Number {
			
			var minValue:Number = Math.min(screenWidth, screenHeight);

			if (minValue < 330) //iPhone3GS
				return 1; // 0.2 in TexturePacker
			else if (minValue < 640) // Lots of Android devices
                 return 1.5; // 0.3 in TexturePacker
			else if (minValue < 1536) //iPhone4, iPhone5, iPad non retina
				return 2; // 0.4 in TexturePacker
			else if (minValue == 1536) //iPad retina
				return 4; // 0.8 in TexturePacker
			else //nexus 10
				return 5; // 1 in TexturePacker
		}
	}
}
