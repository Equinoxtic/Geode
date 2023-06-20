package geodelib;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;

/**
	A class for creating backgrounds with checkers. (Uses [FlxBackdrop](https://api.haxeflixel.com/flixel/addons/display/FlxBackdrop.html).)

	```haxe
	var checkerBg:CheckerBackground = new CheckerBackground(this, "checker", FlxG.camera, 0.2, 0.2, true, true, 1);
	checkerBg.scrollFactor.set(0, 0.07);
	add(checkerBg);
	```

	@param		instance			The current instance / state. (Will default to the current state if `null`)
	@param		checkerImage		The sprite to use for the checker background.
	@param		camera				The camera to use.
	@param		scrollX				The scrollrate of the X axis.
	@param		scrollY				The scrollrate of the Y axis.
	@param		repeatX				Whether or not the background should repeat on the X axis.
	@param		repeatY				Whether or not the background should repeat on the Y axis.
**/
class CheckerBackground extends FlxSpriteGroup {

	var instance:FlxBasic;

	private var backdrop:FlxBackdrop;

	public function new(?instance:FlxBasic, ?checkerImage:String = "checker", ?camera:FlxCamera, ?scrollX:Float = 0.2, ?scrollY:Float = 0.2, ?repeatX:Bool = true, ?repeatY:Bool = true, ?sizeMult:Float = 1.0) {
		super();
		if (instance == null) {
			instance = this;
		}
		this.instance = instance;

		if (camera == null) {
			camera = FlxG.camera;
		}
		this.camera = camera;
		
		var nCheckerImg:String = "";
		if (checkerImage != null) {
			nCheckerImg = checkerImage;
		} else {
			nCheckerImg = "checker";
		}

		backdrop = new FlxBackdrop(Paths.image(nCheckerImg), scrollX, scrollY, repeatX, repeatY);
		backdrop.setGraphicSize(Std.int(backdrop.width * sizeMult), Std.int(backdrop.height * sizeMult));
		backdrop.antialiasing = ClientPrefs.globalAntialiasing;
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
