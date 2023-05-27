package geodelib;

import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.tweens.FlxTween.TweenOptions;

class GeodeTween
{
	public static var globalManager:FlxTweenManager = new FlxTweenManager();

	public static function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions):VarTween {
		return globalManager.tween(Object, Values, Duration, Options);
	}
}