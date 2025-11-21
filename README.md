[[阅读中文版信息](README-zh.md)]
<hr>

# Elysium
Mobile port of Elysium mod. Mod requires and uses [Hotkey Adapter](https://github.com/Jai-ACS/Mod-HotkeyAdapter) mod to bridge the original requirement for hotkeys, which most mobile devices are incapable of performing. The mod continues to support hotkeys for mobile devices that are connected to a keyboard device, though the mobile version of the game itself does not support configuration of hotkeys (for changing activation keys).

Other than that, this mobile port also:
1. Has multi-language support
	* Support English and Chinese languages at initial release (the English variant and Chinese variant of the mod have been merged)
	* More languages could be added in the future; you could submit your translation by:
		1. Forking this repository
		2. Adding in new [translation file](Language/OfficialEnglish/codedictionary.txt) for the language
		3. Submitting it through a [pull request here](https://github.com/Jai-ACS/Mod-Elysium/pulls)
	* You could also submit translation to me via discord (one of the mod related channels), tagging me (Jai, username: jai.san) in the post
	* Credits will be provided upon successful submission (please provide due credit if you are not the actual translator)
2. Some English translations are updated as they are either not well translated or are mis-translated

## Main Features
1. Automate cultivation for inner disciples
	* Automate switching between cultivation (Practice or Train mode) and recovery (Mind mode), based on Mental State
	* Can be configured to automatically consume elixirs, spirit stones and spirit crystals
		* Can be configured to consume only during cultivation
2. One-Click toggle for equipping/unequipping talismans for the currently selected disciple
	* Note: Not very useful without hotkey
3. One-Click placement/removal of items onto/from displays
	* Used mainly for Manual Qi Bursting
4. Toggle the automatic equipping and unequipping of Mental State boosting talismans for enhanced cultivation to recovery ratio
	* Note: The status is currently only visible in the explanation / instruction pop-up
5. Automatically treat injuries with "Spirit" tag
6. Automatically collect and send artifacts to Sword Shield building

## Known Issues
1. The panels (as well as the controls on them) are pretty small and it could be challenging to configure settings on the panels
2. Tooltip (i.e. pop-up) that can explain what certain settings do are now disabled - those are supposed to show upon hovering the mouse over the setting, but since most people don't have a mouse while playing on the mobile version of the game, the only way to activate the tooltip is to tap on the setting, which conflicts with the selection of the checkboxes
3. Some tooltips are retained because they are not on a setting. However, the default pop-up is pretty small, which are truncating away long instruction texts

## Planned Enhancements
There are plans to further enhance this mod. Whether they do become reality or not would depend on my motivation and time.
1. [ ] Overhaul panels to make them suitable for mobile devices
2. [ ] Add in cultivation via Meditation miracle
3. [ ] Improve the logic/algorithm to increase cultivation efficiency
4. [ ] Change how One-Click Placement works to increase usability

## Credits
This mod has been cloned way too many times so it has became hard to ascertain who did what. Therefore, there may be some inaccuracies.
* Original Author: **懒惰夫斯基 (Lazy Fusky)**
* Original Translator: **Kanna~Chan**
* Fix for issue with eating items from Mini Universe: **Akira**
* New Feature: Automatic equipping and unequipping of Mental State boosting talisman: **Japlay**
