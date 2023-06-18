package geodelib.ui;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import ClientPrefs;

using StringTools;

class ScreenFooter extends FlxSpriteGroup
{
	public var enabled = false;
	var instance:FlxBasic;
	private var textBgSprite:FlxSprite;
	private var textSprite:FlxText;

	private function tweenAlpha(object:Dynamic, initialAlphaValue:Float, finalAlphaValue:Float) {
		if (enabled) {
			 FlxTween.tween(object, {alpha: initialAlphaValue}, 0.45, {ease: FlxEase.linear});
		} else {
			FlxTween.tween(object, {alpha: finalAlphaValue}, 0.45, {ease: FlxEase.linear});
		}
	}

	public function new(text:String, textSize:Int, ?textFont:String = 'vcr.ttf', ?bgColor:FlxColor = 0xFF000000, ?textColor:FlxColor = 0xFFFFFFFF, ?instance:FlxBasic):Void {
		super();

		if (instance == null) {
			instance = this;
		}
		this.instance = instance;

		textBgSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, bgColor);
		textBgSprite.alpha = ClientPrefs.alphaOverride;
		add(textBgSprite);

		var nTextSize:Int = 0;
		if (textSize <= 0 || textSize > 16) {
			nTextSize = 16;
		} else {
			nTextSize = textSize;
		}

		var leText:String = '';
		if (text != null) {
			leText = text;
		} else {
			leText = 'TEXT';
		}

		textSprite = new FlxText(textBgSprite.x, textBgSprite.y + 4, FlxG.width, leText, nTextSize);
		textSprite.setFormat(Paths.font(textFont), nTextSize, textColor, RIGHT);
		textSprite.scrollFactor.set();
		add(textSprite);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		tweenAlpha(textBgSprite, ClientPrefs.alphaOverride, 0);
		tweenAlpha(textSprite, 1, 0);
	}
}
