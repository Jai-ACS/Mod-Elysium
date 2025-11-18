local Windows = GameMain:GetMod("Windows")
local MakeMeHappy_Window = Windows:CreateWindow("MakeMeHappy_Window")
local EatList = {}
local EatNpcList = {}
local AutoTreatLing = false
local MinMind = 50
local MaxMind = 80
local FaBaoToZhen = false
local FaBaoRate = 8
local FaBaoAttackPower = 50
local EnableMindFromFu = true;
local ExplainText =
	XT("【默认快捷键说明】") .. "\r\n" ..
	XT("面板：") .. " SHIFT + E\r\n" ..
	XT("一键换符：") .. " SHIFT + R\r\n" ..
	XT("一键放置：") .. " SHIFT + T\r\n" ..
	XT("开/关心境符管理：") .. " SHIFT + Y\r\n" ..
	"=================\r\n" ..
	XT("【丹药设置说明】") .. "\r\n" ..
	XT("自动食用选中的丹药，药效过后会自动接续。") .. "\r\n" ..
	XT("选中仅修行时使用，NPC只会在修行时自动食用选中的丹药。") .. "\r\n" ..
	"=================\r\n" ..
	XT("【修行模式设置说明】") .. "\r\n" ..
	XT("心境低于设定时开始“调心”，高于设定时开始“修/练”。") .. "\r\n" ..
	"\r\n" ..
	XT("【自动心境符管理】[状态：%s]") .. "\r\n" ..
	XT("开启时，进入调心状态自动关闭影响心境的符箓，反之亦然。同时，心境值计算时会自动扣除正在使用的符箓。") .. "\r\n" ..
	XT("例：设符箓A为+5心境、B为+1，心境最低值设为40；则46心境时进入调心状态，并关闭符箓。") .. "\r\n" ..
	XT("注：MOD提供的符箓可能不会生效。") .. "\r\n" ..
	"=================\r\n" ..
	XT("自动模式下会打断部分操作") .. "\r\n" ..
	XT("手动控制NPC时请先恢复默认")

xlua.private_accessible(CS.XiaWorld.RemoteStorage)
xlua.private_accessible(CS.XiaWorld.CommandEatItem)

local strEatItemCmd = "EatItem"
---@type table<string, table<strBuffName, strItemName>>
local tbBuffItem = {
	["qingxin"] = {"Dan_CalmDown", "Item_Dan_CalmDown"},
	["jile"] = {"Dan_Happiness", "Item_Dan_Happiness"},
	["lingshi"] = {"Dan_LingStone", "Item_LingStone"},
	["lingjing"] = {"Dan_LingCrystal", "Item_LingCrystal"},
	["huangya"] = {"Dan_PracticeSpeed", "Item_Dan_PracticeSpeed"}
}

function MakeMeHappy_Window:OnInit()
	self.window.contentPane = UIPackage.CreateObject("MMHWindow", "MainWindow")
	self.window.closeButton = self:GetChild("frame"):GetChild("n5")
	self:GetChild("frame"):GetChild("title").text = XT("极乐世界")
	self:GetChild("explain").text = XT("*功能说明")
	self:UpdateExplainText()
	
	self.list = self:GetChild("list")
	self.window:Center()
end

function MakeMeHappy_Window:UpdateExplainText()
	local enableText = EnableMindFromFu and XT("开") or XT("关")
	self:GetChild("explain").tooltips = string.format(ExplainText, enableText)
		-- "[color=#000000]" .. XT("面板【快捷键】：") .. "[/color]\r\n" ..
		-- "SHIFT + E\r\n一键换符【快捷键】：\r\n" ..
		-- "SHIFT + R\r\n" .. 
		-- "=================\r\n" .. 
		-- "丹药设置说明：\r\n\r\n" .. 
		-- "【自动食用】选中的丹药\r\n" .. 
		-- "药效过后会自动接续\r\n\r\n" .. 
		-- "选中【仅修行时使用】\r\n" .. 
		-- "【NPC】只会在【修行】时\r\n" .. 
		-- "【自动食用】选中的丹药\r\n" .. 
		-- "=================\r\n" .. 
		-- "修行模式设置说明：\r\n\r\n" .. 
		-- "心境低于设定时开始【调心】\r\n" .. 
		-- "高于设定时开始【修/练】。\r\n" .. 
		-- "=================\r\n" .. 
		-- "*自动模式下会打断部分操作\r\n" .. 
		-- "手动控制NPC时请先恢复默认\r\n"
end

function MakeMeHappy_Window:OnShowUpdate()
	local list = self:GetChild("list")
	local ItemList = list:GetChildren()
	local contentPane = self.window.contentPane
	local zhiliao = self:GetChild("zhiliao")
	local fabaoguizhen = self:GetChild("fabaoguizhen")
	local min = self:GetChild("minvalue")
	local max = self:GetChild("maxvalue")

	-- contentPane:GetChild("author").text = "By: Lazy Fusky\nTranslated by: Kanna~Chan"
	contentPane:GetChild("author").text = ""
	contentPane:GetChild("n34").text = XT("低于")
	contentPane:GetChild("n35").text = XT("调心")
	contentPane:GetChild("n36").text = XT("高于")
	contentPane:GetChild("n37").text = XT("修炼")
	contentPane:GetChild("n54").text = XT("品阶")
	contentPane:GetChild("n56").text = XT("威力")
	contentPane:GetChildAt(19).text = XT("说明")
	contentPane:GetChildAt(19).tooltips =
		XT("前面勾选后功能才会生效。") .. "\r\n" ..
		XT("品阶低于或等于设置，而且威力低于或等于设置的法宝将会自动归阵，无论法宝是否被禁用。") .. "\r\n" ..
		XT("有制作者名字的法宝不会被归阵。")

	zhiliao.text = XT("自动治疗真气溢伤")
	zhiliao.tooltips = XT("自动治疗有“灵”标志的伤，需要通脉散。")
	fabaoguizhen.text = XT("法宝自动归阵")
	fabaoguizhen.tooltips = XT("自动将法宝归阵。")

	-- min:SetScale(0.75, 0.75)
	-- max:SetScale(0.75, 0.75)
	-- contentPane:GetChild("n34"):SetScale(0.7, 0.7)
	-- contentPane:GetChild("n35"):SetScale(0.9, 0.9)
	-- contentPane:GetChild("n36"):SetScale(0.7, 0.7)
	-- contentPane:GetChild("n37"):SetScale(0.9, 0.9)
	-- contentPane:GetChild("n54"):SetScale(0.7, 0.7)
	-- contentPane:GetChild("n56"):SetScale(0.7, 0.7)
	-- contentPane:GetChild("n34"):SetPosition(339, 365, 0)
	-- contentPane:GetChild("n35"):SetPosition(395, 356, 0)
	-- contentPane:GetChild("n36"):SetPosition(436, 365, 0)
	-- contentPane:GetChild("n37"):SetPosition(491, 356, 0)
	-- contentPane:GetChild("n54"):SetPosition(-1, 365, 0)
	-- contentPane:GetChild("n56"):SetPosition(59, 365, 0)
	for i = 0, ItemList.Length - 1 do
		local Item = ItemList[i]
		
		local qingxin = Item:GetChild("qingxin")
		local jile = Item:GetChild("jile")
		local lingshi = Item:GetChild("lingshi")
		local lingjing = Item:GetChild("lingjing")
		local huangya = Item:GetChild("huangya")
		local xiulian = Item:GetChild("xiulian")
		local moshi = Item:GetChild("moshi")
		
		qingxin.text = XT("清心丹")
		qingxin.tooltips = XT("服用清心丹能暂时提升心境以及提高心境稳定程度[color=#ff0000]1日[/color]。")

		jile.text = XT("极乐丹")
		jile.tooltips = XT("服用极乐丹能让弟子沉浸在欢乐中，持续[color=#ff0000]2天[/color]，但会减低工作效率。")

		lingshi.text = XT("灵石")
		lingshi.tooltips = XT("能够[color=#0000ff]提升10%基本修炼速度[/color]，持续[color=#ff0000]3日[/color]。")

		lingjing.text = XT("灵晶")
		lingjing.tooltips = XT("能够[color=#0000ff]提升20%基本修炼速度[/color]，持续[color=#ff0000]15日[/color]。")

		huangya.text = XT("黄芽丹")
		huangya.tooltips = XT("以朱果炼制而成的丹药，能够[color=#0000ff]提升30%修炼速度[/color]，持续[color=#ff0000]1日[/color]。")

		xiulian.text = XT("仅修行时使用")
		xiulian.tooltips = XT("选后弟子会仅在修行时自动服用选定的消耗品。")

		moshi.tooltips = XT("默认模式") .. "\r\n" .. XT("自动修行调心") .. "\r\n" .. XT("自动练功调心")
	end
end

function MakeMeHappy_Window:OnShown() -- 显示窗口时
	local zhiliao = self:GetChild("zhiliao")
	zhiliao.selected = AutoTreatLing
	local minvalue = self:GetChild("minvalue"):GetChild("title")
	minvalue.text = MinMind
	local maxvalue = self:GetChild("maxvalue"):GetChild("title")
	maxvalue.text = MaxMind
	local fabaoguizhen = self:GetChild("fabaoguizhen")
	fabaoguizhen.selected = FaBaoToZhen
	local fabaopinjie = self:GetChild("fabaopinjie"):GetChild("title")
	fabaopinjie.text = FaBaoRate
	local fabaoweili = self:GetChild("fabaoweili"):GetChild("title")
	fabaoweili.text = FaBaoAttackPower

	self.list:RemoveChildrenToPool()
	local NpcList = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom)

	for _, Npc in pairs(NpcList) do
		if self:IsValidNpc(Npc) then
			local Item = self.list:AddItemFromPool()
			-- local Item = self.list:AddItemFromPool("ui://2fevh8bil1ry9c")
			local NameLable = Item:GetChild("name")
			NameLable.text = Npc.Name
			Item.data = Npc.ID

			local qingxin = Item:GetChild("qingxin")
			local jile = Item:GetChild("jile")
			local lingshi = Item:GetChild("lingshi")
			local lingjing = Item:GetChild("lingjing")
			local huangya = Item:GetChild("huangya")
			local xiulian = Item:GetChild("xiulian")
			local moshi = Item:GetChild("moshi") -- 模式0=默认, 模式1=修行调心, 模式2=练功调心
			moshi.items = {XT("默认模式"), XT("自动修行调心"), XT("自动练功调心")}

			local moshi_bg = moshi:GetChild("n1")
			local moshi_arrow = moshi:GetChild("n5")
			moshi_arrow:AddRelation(moshi_bg, CS.FairyGUI.RelationType.Right_Right)

			if Npc.Rank ~= g_emNpcRank.Disciple then
				lingshi.visible = false
				lingjing.visible = false
				huangya.visible = false
				xiulian.visible = false
				moshi.visible = false
			else
				lingshi.visible = true
				lingjing.visible = true
				huangya.visible = true
				xiulian.visible = true
				moshi.visible = true
			end

			if EatList[Npc.ID] then
				qingxin.selected = EatList[Npc.ID].qingxin
				jile.selected = EatList[Npc.ID].jile
				lingshi.selected = EatList[Npc.ID].lingshi
				lingjing.selected = EatList[Npc.ID].lingjing
				huangya.selected = EatList[Npc.ID].huangya
				xiulian.selected = EatList[Npc.ID].xiulian
				moshi.selectedIndex = EatList[Npc.ID].moshi
			else
				qingxin.selected = false
				jile.selected = false
				lingshi.selected = false
				lingjing.selected = false
				huangya.selected = false
				xiulian.selected = false
				moshi.selectedIndex = 0
			end
		end
	end
end

function MakeMeHappy_Window:DecidePracticeMode() -- 处理自动调心
	for _, EatNpc in pairs(EatNpcList) do
		local Npc = Map.Things:GetNpcByID(EatNpc)
		if self:IsValidNpc(Npc) then
			if Npc.CanDoAction then
				if EatList[EatNpc].moshi > 0 then
					if EatList[EatNpc].moshi == 1 then -- 自动修行调心模式
						local MindState = Npc.Needs:GetNeedValue("MindState")
						local mindFromFu, mindFuList = self:GetMindFuAndValue(Npc.Equip)
						MindState = MindState - mindFromFu; -- 减去符箓的影响值
						
						local NpcPracticeMode = Npc.PropertyMgr.Practice.PracticeMode
						local Job = Npc.JobEngine.CurJob -- 取NPC当前工作
						local JobType = nil
						if Job ~= nil and Job.jobdef ~= nil then
							JobType = Job.jobdef.Name
						end
						if MindState <= MinMind then -- 心境低于设定
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then -- 如果不在调心模式，则切换到调心模式
								self:ChangePracticeMode(Npc, "tiaoxin")
								self:ToggleFuList(Npc.Equip, mindFuList, false) -- 停用心境符箓
							end
							if JobType == "JobPractice" then -- 如果还在修行状态，则打断当前任务
								Job:InterruptJob()
							end
						elseif MindState >= MaxMind then -- 心境高于设定
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Practice then -- 如果不在修行模式，则切换到修行模式
								self:ChangePracticeMode(Npc, "xiulian")
								self:ToggleFuList(Npc.Equip, mindFuList, true) -- 启用心境符箓
							end
						else -- 如果心境值处于区间段，但既不在修行，也不在调心，则切换到调心模式。
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Practice and NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then
								self:ChangePracticeMode(Npc, "tiaoxin")
								self:ToggleFuList(Npc.Equip, mindFuList, false) -- 停用心境符箓
							end
						end
					elseif EatList[EatNpc].moshi == 2 then -- 自动练功调心模式
						local MindState = Npc.Needs:GetNeedValue("MindState")
						local NpcPracticeMode = Npc.PropertyMgr.Practice.PracticeMode
						local Job = Npc.JobEngine.CurJob -- 取NPC当前工作
						local JobType = nil
						if Job ~= nil and Job.jobdef ~= nil then
							JobType = Job.jobdef.Name
						end
						if MindState <= MinMind then -- 心境低于设定
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then -- 如果不在调心模式，则切换到调心模式
								self:ChangePracticeMode(Npc, "tiaoxin")
								self:ToggleFuList(Npc.Equip, mindFuList, false) -- 停用心境符箓
							end
							if JobType == "JobPractice" then -- 如果还在修行状态，则打断当前任务
								Job:InterruptJob()
							end
						elseif MindState >= MaxMind then -- 心境高于设定
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Skill then -- 如果不在练功模式，则切换到练功模式
								self:ChangePracticeMode(Npc, "liangong")
								self:ToggleFuList(Npc.Equip, mindFuList, true) -- 停用心境符箓
							end
						else -- 如果心境值处于区间段，但既不在练功，也不在调心，则切换到调心模式。
							if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Skill and NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then
								self:ChangePracticeMode(Npc, "tiaoxin")
								self:ToggleFuList(Npc.Equip, mindFuList, false) -- 停用心境符箓
							end
							if JobType == "JobPractice" then -- 如果还在修行状态，则打断当前任务
								Job:InterruptJob()
							end
						end
					end
				end
			end
		end
	end
end

local FuEquipTypeList = {CS.XiaWorld.g_emEquipType.Fu1, CS.XiaWorld.g_emEquipType.Fu2, CS.XiaWorld.g_emEquipType.Fu3, CS.XiaWorld.g_emEquipType.Fu4, CS.XiaWorld.g_emEquipType.Fu5, CS.XiaWorld.g_emEquipType.Fu6}
function MakeMeHappy_Window:GetMindFuAndValue(equip) -- 计算所有符箓给于的心境值
	local fuList = {} -- 储存影响心境的符箓
	local count = 0; -- 储存心境值
	if not EnableMindFromFu then
		return count, fuList;
	end
	
	for fi = 101, 106 do
		local fuItem = equip:GetEquip(fi)
		if fuItem then
			for ei, effect in pairs(fuItem.EquptData) do
				if effect.name == "MindStateBaseValue" then
					fuList[fi] = fuItem;
					if equip:CheackFuThingActive(fi) then
						count = count + effect.addv * 6 / 5;
					end
				end
			end
		end
	end
	return count, fuList;
end

function MakeMeHappy_Window:ToggleFuList(equip, fuList, isOn) -- 开启或关闭符箓列表
	for i, fu in pairs(fuList) do
		if isOn then
			equip:ActiveItemThing(fu, FuEquipTypeList[i - 100])
		else
			equip:CloseItemthing(fu, FuEquipTypeList[i - 100])
		end
	end
end

function MakeMeHappy_Window:ChangePracticeMode(Npc, PracticeMode) -- 更改NPC行为模式
	if self:IsValidNpc(Npc) then
		local NpcPracticeMode = Npc.PropertyMgr.Practice
		if PracticeMode == "xiulian" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Practice) -- 修行模式
		elseif PracticeMode == "liangong" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Skill) -- 练功模式
		elseif PracticeMode == "tiaoxin" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Quiet) -- 调心模式
		end
	end
end

function MakeMeHappy_Window:DoEatItem() -- 处理NPC吃药
	for _, EatNpc in pairs(EatNpcList) do
		local Npc = Map.Things:GetNpcByID(EatNpc)
		if self:IsValidNpc(Npc) then
			if Npc.CanDoAction then
				local CanEatItem = true
				if EatList[EatNpc].xiulian then
					local NpcPracticeMode = Npc.PropertyMgr.Practice.PracticeMode
					if NpcPracticeMode == CS.XiaWorld.g_emPracticeBehaviourKind.Practice then
						CanEatItem = true
					else
						CanEatItem = false
					end
				end
				if CanEatItem then
					if EatList[EatNpc].qingxin then
						self:AddEatCommand(Npc, "qingxin")
					end
					if EatList[EatNpc].jile then
						self:AddEatCommand(Npc, "jile")
					end
					if EatList[EatNpc].lingshi then
						self:AddEatCommand(Npc, "lingshi")
					end
					if EatList[EatNpc].lingjing then
						self:AddEatCommand(Npc, "lingjing")
					end
					if EatList[EatNpc].huangya then
						self:AddEatCommand(Npc, "huangya")
					end
				end
			end
		end
	end
end

-- 添加NPC吃药行为
function MakeMeHappy_Window:AddEatCommand(Npc, Buff)
	local strBuffName, strItemName = table.unpack(tbBuffItem[Buff])
	if strBuffName == nil or strItemName == nil then
		return
	end

	if Npc.PropertyMgr:FindModifier(strBuffName) ~= nil then
		return
	end

	local listCmd = Npc:CheckCommand(strEatItemCmd, true) or {}
	for _, pCmd in pairs(listCmd) do
		if pCmd.item.def.Name == strItemName then
			return
		end
	end

	local pItem
	if strItemName == "Item_LingStone" then
		local pRemoteStorage = Map.SpaceRing
		local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(Npc.Pos)
		if pRemoteStorage.CanUse then
			local listItem = pRemoteStorage:TakeOut(strItemName, 1, Npc.Key, pNearestStorageBuilding.Pos)
			if listItem ~= nil then
				pItem = listItem[0]
			end
		end
	end
	if pItem == nil then
		pItem = Map.Things:FindItem(null, 9999, strItemName, 0, false, null, 0, 9999, null, false)
	end

	if pItem == nil then
		return
	end
	Npc:AddCommandIfNotExist("EatItem", pItem)

	if strItemName == "Item_LingCrystal" then
		local pRemoteStorage = Map.SpaceRing
		local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(Npc.Pos)
		if pRemoteStorage.CanUse then
			local listItem = pRemoteStorage:TakeOut(strItemName, 1, Npc.Key, pNearestStorageBuilding.Pos)
			if listItem ~= nil then
				pItem = listItem[0]
			end
		end
	end
	if pItem == nil then
		pItem = Map.Things:FindItem(null, 9999, strItemName, 0, false, null, 0, 9999, null, false)
	end

	if pItem == nil then
		return
	end
	Npc:AddCommandIfNotExist("EatItem", pItem)

	if strItemName == "Item_Dan_CalmDown" then
		local pRemoteStorage = Map.SpaceRing
		local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(Npc.Pos)
		if pRemoteStorage.CanUse then
			local listItem = pRemoteStorage:TakeOut(strItemName, 1, Npc.Key, pNearestStorageBuilding.Pos)
			if listItem ~= nil then
				pItem = listItem[0]
			end
		end
	end
	if pItem == nil then
		pItem = Map.Things:FindItem(null, 9999, strItemName, 0, false, null, 0, 9999, null, false)
	end

	if pItem == nil then
		return
	end
	Npc:AddCommandIfNotExist("EatItem", pItem)

	if strItemName == "Item_Dan_Happiness" then
		local pRemoteStorage = Map.SpaceRing
		local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(Npc.Pos)
		if pRemoteStorage.CanUse then
			local listItem = pRemoteStorage:TakeOut(strItemName, 1, Npc.Key, pNearestStorageBuilding.Pos)
			if listItem ~= nil then
				pItem = listItem[0]
			end
		end
	end
	if pItem == nil then
		pItem = Map.Things:FindItem(null, 9999, strItemName, 0, false, null, 0, 9999, null, false)
	end

	if pItem == nil then
		return
	end
	Npc:AddCommandIfNotExist("EatItem", pItem)

	if strItemName == "Item_Dan_PracticeSpeed" then
		local pRemoteStorage = Map.SpaceRing
		local pNearestStorageBuilding = pRemoteStorage:GetNearestWorkThing(Npc.Pos)
		if pRemoteStorage.CanUse then
			local listItem = pRemoteStorage:TakeOut(strItemName, 1, Npc.Key, pNearestStorageBuilding.Pos)
			if listItem ~= nil then
				pItem = listItem[0]
			end
		end
	end

	if pItem == nil then
		pItem = Map.Things:FindItem(null, 9999, strItemName, 0, false, null, 0, 9999, null, false)
	end

	if pItem == nil then
		return
	end

	Npc:AddCommandIfNotExist("EatItem", pItem)
end

function MakeMeHappy_Window:TreatLingDamage() -- 自动治疗真气溢伤
	local NpcList = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom)
	for _, Npc in pairs(NpcList) do
		if self:IsValidNpc(Npc) then
			if Npc.CanDoAction and Npc.PropertyMgr.Practice.IsZhuJi then -- 只治疗内门弟子
				local Body = Npc.PropertyMgr.BodyData
				local DamageID = Body.m_DamageID -- 取伤病列表
				for _, v in pairs(DamageID) do
					local Damage = Body:GetDamage(v.ID) -- 取伤病
					if Damage.def.Lable == CS.XiaWorld.g_emDamageLable.Ling and Damage.TreatValue > 0 then -- 判断是否灵气伤害且未被治疗
						local Item = Map.Things:FindItem(null, 9999, "Item_Dan_DredgeQi1", 0, false, null, 0, 9999, null, false)
						if Item ~= nil then
							Npc:AddCommandIfNotExist("EatItem", Item)
							break
						end
					end
				end
			end
		end
	end
end

function MakeMeHappy_Window:ChangeFu() -- 一键换符
	local Npc = CS.XiaWorld.UILogicMode_Select.Instance.CurSelectThing;
	if not Npc then
		return
	end
	
	if Npc.ThingType == CS.XiaWorld.g_emThingType.Npc then
		local Equip = Npc.Equip
		local ActiveState = {}
		local Fu = {CS.XiaWorld.g_emEquipType.Fu1, CS.XiaWorld.g_emEquipType.Fu2, CS.XiaWorld.g_emEquipType.Fu3, CS.XiaWorld.g_emEquipType.Fu4, CS.XiaWorld.g_emEquipType.Fu5, CS.XiaWorld.g_emEquipType.Fu6}
		for i = 101, 106 do
			if Equip:CheackFuThingActive(i) == true then
				local Item = Equip:GetEquip(i)
				Equip:CloseItemthing(Item, Fu[i - 100])
			else
				local Item = Equip:GetEquip(i)
				if Item then
					ActiveState[i] = true
				end
			end
		end
		for i, v in pairs(ActiveState) do
			local Item = Equip:GetEquip(i)
			Equip:ActiveItemThing(Item, Fu[i - 100])
		end
	end
end

function MakeMeHappy_Window:PutFaBaoToZhen() -- 法宝自动归阵
	if FaBaoToZhen == true then
		local Zhen = Map.Things:FindBuilding(null, 9999, "Zhen", 0, false, false, 0, 9999, null, null, true)
		local FaBaoList = Map.Things:FindItems(null, 9999, 9999, "FightFaBao", 0, null, 0, 9999, null, false, true)
		if FaBaoList then
			for _, FaBao in pairs(FaBaoList) do
				local tempRate = FaBao.Rate
				local tempPower = FaBao.Fabao:GetProperty(CS.XiaWorld.Fight.g_emFaBaoP.AttackPower)
				if tempRate <= FaBaoRate and tempPower <= FaBaoAttackPower and FaBao.Author == nil then
					Zhen.Bag:AddBegItem(FaBao, 1, "Carry")
				end
			end
		end
	end
end

function MakeMeHappy_Window:OnUpdate(dt)

end

function MakeMeHappy_Window:UpdateItem(Item)

end

function MakeMeHappy_Window:OnHide() -- 关闭窗口时
	local minvalue = self:GetChild("minvalue"):GetChild("title")
	local minv = tonumber(minvalue.text)
	if minv then
		MinMind = minv
	else
		MinMind = 50
	end
	local maxvalue = self:GetChild("maxvalue"):GetChild("title")
	local maxv = tonumber(maxvalue.text)
	if maxv then
		MaxMind = maxv
	else
		MaxMind = 80
	end
	if MinMind < 10 then
		MinMind = 10
	end
	if MaxMind > 200 then
		MaxMind = 200
	end
	if MaxMind <= MinMind then
		MaxMind = MinMind + 1
	end

	local fabaoguizhen = self:GetChild("fabaoguizhen")
	FaBaoToZhen = fabaoguizhen.selected
	local fabaopinjie = self:GetChild("fabaopinjie"):GetChild("title")
	FaBaoRate = tonumber(fabaopinjie.text) or 8
	if FaBaoRate < 0 then
		FaBaoRate = 0
	end
	local fabaoweili = self:GetChild("fabaoweili"):GetChild("title")
	FaBaoAttackPower = tonumber(fabaoweili.text) or 50
	if FaBaoAttackPower < 0 then
		FaBaoAttackPower = 0
	end

	EatNpcList = {}
	EatList = {}
	local TempList = {}
	local ItemList = self.list:GetChildren()
	for i = 0, ItemList.Length - 1 do
		local Item = ItemList[i]
		local qingxin = Item:GetChild("qingxin")
		local jile = Item:GetChild("jile")
		local lingshi = Item:GetChild("lingshi")
		local lingjing = Item:GetChild("lingjing")
		local huangya = Item:GetChild("huangya")
		local xiulian = Item:GetChild("xiulian")
		local moshi = Item:GetChild("moshi")

		if qingxin.selected == true or jile.selected == true or lingshi.selected == true or lingjing.selected == true or huangya.selected == true or xiulian.selected == true or moshi.selectedIndex > 0 then
			EatNpcList[i + 1] = Item.data
			local EatStates = {}
			EatStates.qingxin = qingxin.selected
			EatStates.jile = jile.selected
			EatStates.lingshi = lingshi.selected
			EatStates.lingjing = lingjing.selected
			EatStates.huangya = huangya.selected
			EatStates.xiulian = xiulian.selected
			EatStates.moshi = moshi.selectedIndex
			TempList[Item.data] = EatStates
		end
	end

	EatList = TempList
	local zhiliao = self:GetChild("zhiliao")
	AutoTreatLing = zhiliao.selected
end

function MakeMeHappy_Window:GetNpc(ID) -- 取NPC
	return Map.Things:GetNpcByID(ID)
end

function MakeMeHappy_Window:GetEatList() -- 取吃药详情列表
	return EatList
end

function MakeMeHappy_Window:GetEatNpcList() -- 取吃药NPC列表
	return EatNpcList
end

function MakeMeHappy_Window:GetAutoTreatLing() -- 取自动冶疗
	return AutoTreatLing or false
end

function MakeMeHappy_Window:GetMindValue() -- 取心境区间
	return MinMind, MaxMind
end

function MakeMeHappy_Window:GetEnableMindFromFu() -- 开关心境符管理
    return EnableMindFromFu
end

function MakeMeHappy_Window:SetEnableMindFromFu(value) -- 开关心境符管理
    EnableMindFromFu = value;
	self:UpdateExplainText();
end

function MakeMeHappy_Window:ToggleMindFromFu() -- 开/关 符箓对心境的影响
	EnableMindFromFu = not EnableMindFromFu;
	self:UpdateExplainText();
end

function MakeMeHappy_Window:SetEatList(tbEatList) -- 设置吃药详情列表
	EatList = tbEatList or {}
end

function MakeMeHappy_Window:SetEatNpcList(tbEatNpcList) -- 设置吃药NPC列表
	EatNpcList = tbEatNpcList or {}
end

function MakeMeHappy_Window:SetAutoTreatLing(bAutoTreatLing) -- 设置自动治疗
	AutoTreatLing = bAutoTreatLing or false
end

function MakeMeHappy_Window:SetMindValue(iMinMindValue, iMaxMindValue) -- 设置心境区间
	MinMind = iMinMindValue or 50
	MaxMind = iMaxMindValue or 80
	if MinMind < 10 then
		MinMind = 10
	end
	if MaxMind > 500 then
		MaxMind = 500
	end
	if MaxMind <= MinMind then
		MaxMind = MinMind + 1
	end
end

function MakeMeHappy_Window:GetGuiZhen() -- 取法宝归阵设置
	return FaBaoToZhen, FaBaoRate, FaBaoAttackPower
end

function MakeMeHappy_Window:SetGuiZhen(bFaBaoToZhen, iFaBaoRate, iFaBaoAttackPower) -- 设置法宝归阵
	FaBaoToZhen = bFaBaoToZhen or false
	FaBaoRate = iFaBaoRate or 8
	FaBaoAttackPower = iFaBaoAttackPower or 50
end

function MakeMeHappy_Window:IsValidNpc(Npc) -- 检测NPC可用性
	if not Npc.IsValid then
		return false
	end
	-- if Npc.PropertyMgr.Practice.GongStateLevel == CS.XiaWorld.g_emGongStageLevel.God2 then
	-- return false
	-- end
	
	local Enum = CS.XiaWorld
	if not Npc.IsValid or Npc.IsDeath or Npc.IsPuppet or Npc.IsZombie or Npc.IsVistor or Npc.IsWaiMen then
		return false
	elseif Npc.GongKind == Enum.g_emGongKind.Body or Npc.GongKind == Enum.g_emGongKind.God then
		return false
	else
		return true
	end
end
