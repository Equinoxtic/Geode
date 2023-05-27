package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import geodelib.GeodeTween;

using StringTools;

class ExtrasMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var checker:FlxBackdrop = new FlxBackdrop(Paths.image("checker"), 0.2, 0.2, true, true);

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate' #end
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var selectedText:FlxText;
	var selectedTextBG:FlxSprite;

	var selectorLeft:FlxText;
	var selectorRight:FlxText;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus - Extras Menu", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image("menubgs/extrasBG"));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		checker.scrollFactor.set(0, 0.07);
		checker.antialiasing = ClientPrefs.globalAntialiasing;
		add(checker);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image("extrasmenu/button_" + optionShit[i]));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.screenCenter();
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		selectedTextBG = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		selectedTextBG.alpha = ClientPrefs.alphaOverride;
		selectedTextBG.scrollFactor.set();
		add(selectedTextBG);
		selectedText = new FlxText(0, 525, 1180, "", 27);
		selectedText.setFormat(Paths.font("Exo2-Medium.ttf"), 27, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectedText.screenCenter(X);
		selectedText.scrollFactor.set();
		add(selectedText);

		selectorLeft = new FlxText(-175, 0, FlxG.width, "<", 35);
		selectorLeft.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectorLeft.scrollFactor.set();
		selectorLeft.screenCenter(Y);
		add(selectorLeft);

		selectorRight = new FlxText(selectorLeft.x + 345, 0, FlxG.width, ">", 35);
		selectorRight.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectorRight.scrollFactor.set();
		selectorRight.screenCenter(Y);
		add(selectorRight);

		var border:FlxSprite = new FlxSprite().loadGraphic(Paths.image("game_border"));
		border.scrollFactor.set();
		border.screenCenter();
		add(border);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		menuItems.forEach(function(spr:FlxSprite) {
			spr.alpha = 0;
			if (spr.ID == curSelected) {
				spr.alpha = 0.95;
			}
			spr.updateHitbox();
		});

		checker.x -= 0.43 / (ClientPrefs.framerate / 60);
		checker.y -= 0.17 / (ClientPrefs.framerate / 60);
		checker.angle -= 0.076 / (ClientPrefs.framerate / 60);

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					// if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					GeodeTween.tween(FlxG.camera, {zoom: 3}, 1.1, {ease: FlxEase.expoInOut});
					GeodeTween.tween(FlxG.camera, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut});

					menuItems.forEach(function(spr:FlxSprite)
					{
						FlxFlicker.flicker(spr, 0, 0.04, true, false);
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							var daChoice:String = optionShit[curSelected];
							switch (daChoice)
							{
								#if MODS_ALLOWED
								case 'mods':
									MusicBeatState.switchState(new ModsMenuState());
								#end
								case 'awards':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'credits':
									MusicBeatState.switchState(new CreditsState());
								default:
									MusicBeatState.switchState(new WIPState());
							}
						});
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		GeodeTween.globalManager.update(elapsed);
	}

	function updateSelectionText() {
		var daChoice:String = optionShit[curSelected];
		var selectedString:String = '';
		switch(daChoice) {
			case 'mods':
				selectedString = 'Mods';
			case 'awards':
				selectedString = 'Achievements';
			case 'credits':
				selectedString = 'Credits';
			case 'donate':
				selectedString = 'Donate';
		}
		selectedText.text = selectedString;
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		updateSelectionText();

		selectedTextBG.setPosition(selectedText.x - 10, selectedText.y - 10);
		selectedTextBG.setGraphicSize(Std.int(selectedText.width + 10), Std.int(selectedText.height + 25));
		selectedTextBG.updateHitbox();

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
