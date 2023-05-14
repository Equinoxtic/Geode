package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;

class WIPState extends MusicBeatState
{
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image("checker"), 0.2, 0.2, true, true);
	var txt:FlxText;
	override public function create()
	{
		FlxG.sound.music.volume = 0;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menubgs/wip"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		add(bg);

		checker.antialiasing = ClientPrefs.globalAntialiasing;
		checker.scrollFactor.set();
		add(checker);

		var border:FlxSprite = new FlxSprite().loadGraphic(Paths.image("game_border"));
		border.screenCenter();
		border.scrollFactor.set();
		add(border);

		txt = new FlxText(0, 0, FlxG.width, "", 14);
		txt.setFormat(Paths.font("Exo2-Medium.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();
		txt.scrollFactor.set();
		txt.borderSize = 1.25;
		add(txt);

		super.create();
	}

	var txt_sine:Float = 0;
	override public function update(elapsed:Float)
	{
		txt.text = "< This is a work in progress!!! >";

		checker.y -= 0.05 / (ClientPrefs.framerate / 60);

		if (txt.visible) {
			txt_sine += 180 * elapsed;
			txt.alpha = 1 - Math.sin((Math.PI * txt_sine) / 180);
		}

		if (controls.BACK) {
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}