package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import geodelib.camera.CameraTools;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var warnText:FlxText;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey there, watch out!\n
			This Game contains some flashing lights!\n
			You can disable flashing lights in the Options / Settings Menu.\n
			You've been warned by the developers!\n
			Press the *ENTER* key to continue.",
			24);
		warnText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
		warnText.screenCenter();
		warnText.alpha = 0;
		add(warnText);

		super.create();

		CameraTools.zoomCameraFadeIn(FlxG.camera, 3, 1, 0.875);
		FlxTween.tween(warnText, {alpha: 0.95}, 1.35, {ease: FlxEase.expoInOut});
	}

	private function openTitleState()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		warnText.font = Paths.font('teoran-font-v1-04.ttf');
		CameraTools.zoomCameraFadeOut(FlxG.camera, 3, 0.875, 'quartInOut');
		warnText.alpha = 1;
		FlxTween.tween(warnText, {alpha: 0}, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween) {
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				MusicBeatState.switchState(new TitleState());
			});
		}});
	}

	var pressedSmth:Bool = false;
	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([FlxKey.ENTER, FlxKey.SPACE]) && !pressedSmth) {
			pressedSmth = true;
			openTitleState();
		}
		super.update(elapsed);
	}
}
