package geodelib;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import geodelib.GeodeTween;

/**
	### Custom made "Camera Flashing" function with FlxTween built into it.

	-----

	#### Usage (SAMPLE CODE)

	~~~~~~~~~~~~~~~{.hx}
	// Set up
	class CameraFlashSample {
		var _flash:CameraFlash = new CameraFlash();
		_flash.cameras = [camera];
		add(_flash);

		_flash.flash(...); // Flash function
	}
	~~~~~~~~~~~~~~~

	#### Functions

	* `flash()` - Default flash.
**/
class CustomFlash extends FlxSpriteGroup
{
	private var twn:FlxTween;

	var instance:FlxBasic;

	public function new(?instance:FlxBasic) {
		super();
		if (instance == null) {
			instance = this;
		}
		this.instance = instance;
	}

	private function flashSpriteObject(sprite:Dynamic, alpha:Float = 1, duration:Float = 1, ?startDelay:Float = 0) {
		new FlxTimer().start(startDelay, function(tmr:FlxTimer) {
			if (alpha > 0) {
				sprite.alpha = alpha;
			}
			twn = GeodeTween.tween(sprite, { alpha: 0 }, duration, { onComplete: function(twn:FlxTween) {
				new FlxTimer().start(0.1, function(tmr:FlxTimer) { sprite.destroy(); });
			}});
			twn.start();
		});
	}

	public function flash(alpha:Float = 1, duration:Float = 0, color:FlxColor = FlxColor.WHITE, ?startDelay:Float = 0):Void {
		var sprite:FlxSprite = new FlxSprite().makeGraphic(
			Std.int(FlxG.width * 2), Std.int(FlxG.height * 2),
			color
		);
		sprite.screenCenter();
		sprite.scrollFactor.set();
		sprite.alpha = 0;
		
		add(sprite);

		flashSpriteObject(sprite, alpha, duration, startDelay);
	}
	
	public function flashSprite(spritePath:String = '', spriteSize:Float = 1, alpha:Float = 1, duration:Float = 1, ?startDelay:Float = 0) {
		var spritePath_s:String = '';
		if (spritePath != null) {
			spritePath_s = spritePath;
		} else {
			trace('${spritePath}: cannot be found.');
		}

		var sprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image(spritePath_s));
		sprite.screenCenter();
		sprite.scrollFactor.set();
		sprite.setGraphicSize(Std.int(sprite.width * spriteSize), Std.int(sprite.height * spriteSize));
		sprite.alpha = 0;
		
		add(sprite);

		flashSpriteObject(sprite, alpha, duration, startDelay);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		GeodeTween.globalManager.update(elapsed);
	}

	override function destroy() {
		super.destroy();
		if (twn != null) {
			twn.cancel();
		}
	}
}
