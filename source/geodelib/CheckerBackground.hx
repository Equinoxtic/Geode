package geodelib;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;

class CheckerBackground extends FlxSpriteGroup {

	var instance:FlxBasic;

	private var backdrop:FlxBackdrop;

	public function new(?instance:FlxBasic, ?cam:FlxCamera, ?checkerImage:String = "checker", ?scrollX:Float = 0.2, ?scrollY:Float = 0.2, ?repeatX:Bool = true, ?repeatY:Bool = true) {
		super();
		if (instance == null) {
			instance = this;
		}
		this.instance = instance;
		
		var nCheckerImg:String = "";
		if (checkerImage != null) {
			nCheckerImg = checkerImage;
		} else {
			nCheckerImg = "checker";
		}

		backdrop = new FlxBackdrop(Paths.image(nCheckerImg), scrollX, scrollY, repeatX, repeatY);
		backdrop.antialiasing = ClientPrefs.globalAntialiasing;
		backdrop.cameras = [cam];
		add(backdrop);
	}

	public function updateCheckerPosition(?xSpeed:Float = 0.0, ?ySpeed:Float = 0.0, ?invertedX:Bool = false, ?invertedY:Bool = false) {
		if (!invertedX)
			backdrop.x += xSpeed / (ClientPrefs.framerate / 60);
		else
			backdrop.x -= xSpeed / (ClientPrefs.framerate / 60);

		if (!invertedY)
			backdrop.y += ySpeed / (ClientPrefs.framerate / 60);
		else
			backdrop.y -= ySpeed / (ClientPrefs.framerate / 60);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		// do nothing
	}
}
