package geodelib.camera;

import flixel.FlxBasic;
import geodelib.GeodeTween;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;

using StringTools;

class CameraTools
{
	public static inline function zoomCameraFadeIn(cam:FlxCamera, initialZoomAmount:Float = 3, finalZoomAmount:Float = 1, ?duration:Float = 0.85, ?easeProperty:String = 'expoInOut'):Void
	{
		cam.alpha = 0;
		cam.zoom = initialZoomAmount;
		FlxTween.tween(cam, {zoom: finalZoomAmount, alpha: 1}, duration, {ease: GeodeTween.getFlxEaseFromString(easeProperty)});
	}

	public static inline function zoomCameraFadeOut(cam:FlxCamera, zoomAmount:Float = 3, ?duration:Float = 0.75, ?easeProperty:String = 'expoInOut'):Void
	{
		FlxTween.tween(cam, {zoom: zoomAmount, alpha: 0}, duration, {ease: GeodeTween.getFlxEaseFromString(easeProperty)});
	}

	public static inline function rotateCamera(cam:FlxCamera, rotationAmount:Float = 90, ?duration:Float = 1.75, ?easeProperty:String = 'quartInOut'):Void
	{
		FlxTween.tween(cam, {angle: rotationAmount}, duration, {ease: GeodeTween.getFlxEaseFromString(easeProperty)});
	}
}
