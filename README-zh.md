[[English version of README](README.md)]
<hr>

# 极乐世界
手游版的极乐世界 MOD。此 MOD 使用 [快捷键连接器](https://github.com/Jai-ACS/Mod-HotkeyAdapter) MOD 来弥补此 MOD 原本需要快捷键的要求，导致在大多数玩家的手机不能运行。此 MOD 将继续支持使用快捷键的功能，让少数拥有键盘的玩家能继续享用快捷键所带来的便捷，可是本手游不支持更改或编辑快捷键。

此外，此手游版 MOD 也：
1. 支持多种语言
	* 在 MOD 初始版本就支持英文和中文（原本此 MOD 的英文和中文已被融合）
	* 此后，能支持更多语言；你可以以下方法提交新的翻译：
		1. Fork 出此仓库
		2. 增添新语言的[翻译文档](Language/OfficialEnglish/codedictionary.txt)
		3. 在此仓库提交 [Pull Request](https://github.com/Jai-ACS/Mod-Elysium/pulls)
	* 你也可以在 Discord 平台与我取得联系，请在信息中标记我 (Jai, 用户名：jai.san)
	* 提交成功就会把提交者增加到【致谢】章节里（如不是本人翻译的，请说明出自谁的手）
2. 更新和纠正了一些英文翻译

## 主要功能
1. 内门弟子修炼的自动化
	* 自动在修炼（修行或练功模式）与心境回复（调心模式）间循环
	* 可被设置成自动服用丹药、灵石以及灵晶
		* 可选是否只在修炼中自动服用
2. 一键转换已选中弟子的已激活和非激活的符咒
	* 注：用快捷键才会好用
3. 一键在/从置物台置放和丢下物品
	* 主要用于手动爆发灵气
4. 开/关自动管理能提升心境的符咒的激活状态，来整体提升修炼和心境恢复的效率
	* 注：此功能的开关状态只在面板中的说明里显示
5. 自动治疗拥有“灵“标签的伤
6. 自动收集及回归法宝到剑阵中

## 问题
1. 面板以及里头的全部东西都挺小的，导致对设置造成一定挑战
2. 暂时去除一些输入框的提示框 - 那原本是用于解释一些输入框的作用，但是因为手游版没有滑鼠，导致提示框只能在点击时打开，和输入框起了冲突
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
