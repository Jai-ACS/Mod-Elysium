local MakeMeHappy = GameMain:GetMod("MakeMeHappy")
local count = 0
local count1 = 0
local SaveData = {}

local Adapter = GameMain:GetMod("Jai_HotkeyAdapter")

function MakeMeHappy:OnInit()
    SaveData = SaveData or {}
    local MMHWindow = self:GetMMHWindow()
    MMHWindow:SetEatList(SaveData.MakeMeHappy_EatItem)
    MMHWindow:SetEatNpcList(SaveData.MakeMeHappy_EatNpcList)
    MMHWindow:SetAutoTreatLing(SaveData.MakeMeHappy_AutoTreatLing)
    local minv = SaveData.MakeMeHappy_MinMindValue or 50
    local maxv = SaveData.MakeMeHappy_MaxMindValue or 80
    MMHWindow:SetMindValue(minv, maxv)
    MMHWindow:SetGuiZhen(SaveData.MakeMeHappy_FaBaoToZhen, SaveData.MakeMeHappy_FaBaoRate,
        SaveData.MakeMeHappy_FaBaoAttackPower)
    local PutItemWindow = self:GetPutItemWindow()
    PutItemWindow:SetPlan(SaveData.MakeMeHappy_Plan)

	self:registerWithAdapter()
end

function MakeMeHappy:registerWithAdapter()
	if (Adapter == nil) then
		return
	end
	
	Adapter:register(XT("极乐世界"), XT("打开面板"),
		function()
			local MMHWindow = self:GetMMHWindow()
			MMHWindow:Show()
		end
	)
	Adapter:register(XT("极乐世界"), XT("一键换符"),
		function()
			local MMHWindow = self:GetMMHWindow()
			MMHWindow:Show()
			MMHWindow:ChangeFu()
		end
	)
	Adapter:register(XT("极乐世界"), XT("一键放置"),
		function()
			local PutItemWindow = self:GetPutItemWindow()
			PutItemWindow:Show()
		end
	)
	Adapter:register(XT("极乐世界"), XT("开/关心境符管理"),
		function()
			local MMHWindow = self:GetMMHWindow()
			MMHWindow:Show()
			MMHWindow:ToggleMindFromFu()
		end
	)
end

function MakeMeHappy:OnSetHotKey()
    local tbHotKeys = {{
        ID = "MakeMeHappy",
        Name = XT("极乐世界"),
        Type = "Mod",
        InitialKey1 = "LeftShift + E",
        InitialKey2 = "RightShift + E"
    }, {
        ID = "MakeMeHappy_ChangeFu",
        Name = XT("极乐世界") .. XT("（一键换符）"),
        Type = "Mod",
        InitialKey1 = "LeftShift + R",
        InitialKey2 = "RightShift + R"
    }, {
        ID = "MakeMeHappy_SetPutItem",
        Name = XT("极乐世界") .. XT("（一键放置）"),
        Type = "Mod",
        InitialKey1 = "LeftShift + T",
        InitialKey2 = "RightShift + T"
    }, {
        ID = "MakeMeHappy_ToggleMindFromFu",
        Name = XT("极乐世界") .. XT("（开/关心境符管理）"),
        Type = "Mod",
        InitialKey1 = "LeftShift + Y",
        InitialKey2 = "RightShift + Y"
    }}
    return tbHotKeys
end

function MakeMeHappy:OnHotKey(ID, State)
    if ID == "MakeMeHappy" and State == "down" then
		local MMHWindow = self:GetMMHWindow()
		
		if MMHWindow.window.isShowing then
			MMHWindow:Hide()
		else
			MMHWindow:Show()
		end
    end
    if ID == "MakeMeHappy_ChangeFu" and State == "down" then
		local MMHWindow = self:GetMMHWindow()
		MMHWindow:ChangeFu()
    end
    if ID == "MakeMeHappy_SetPutItem" and State == "down" then
		local PutItemWindow = self:GetPutItemWindow()
		if PutItemWindow.window.isShowing then
			PutItemWindow:Hide()
		else
			PutItemWindow:Show()
		end
    end
	if ID == "MakeMeHappy_ToggleMindFromFu" and State == "down" then
        local MMHWindow = self:GetMMHWindow()
        MMHWindow:ToggleMindFromFu()
    end
end

function MakeMeHappy:OnStep(dt)
    count = count + 1
    count1 = count1 + 1
    if count > 200 then
        local MMHWindow = self:GetMMHWindow()
        MMHWindow:DoEatItem()
        MMHWindow:DecidePracticeMode()
        local AutoTreatLing = MMHWindow:GetAutoTreatLing()
        if AutoTreatLing then
            MMHWindow:TreatLingDamage()
        end
        count = 0
    end
    if count1 > 2000 then
        local MMHWindow = self:GetMMHWindow()
        MMHWindow:PutFaBaoToZhen()
        count1 = 0
    end
end

function MakeMeHappy:OnLeave()

end

function MakeMeHappy:OnSave()
    SaveData = {}
    local MMHWindow = self:GetMMHWindow()
    local EatList = MMHWindow:GetEatList()
    local EatNpcList = MMHWindow:GetEatNpcList()
    local AutoTreatLing = MMHWindow:GetAutoTreatLing()
    local minv, maxv = MMHWindow:GetMindValue()
    if minv < 10 then
        minv = 10
    end
    if maxv > 500 then
        maxv = 500
    end
    if maxv <= minv then
        maxv = minv + 1
    end
    local FaBaoToZhen, FaBaoRate, FaBaoAttackPower = MMHWindow:GetGuiZhen()
    SaveData.MakeMeHappy_EatItem = EatList
    SaveData.MakeMeHappy_EatNpcList = EatNpcList
    SaveData.MakeMeHappy_AutoTreatLing = AutoTreatLing
    SaveData.MakeMeHappy_MinMindValue = minv
    SaveData.MakeMeHappy_MaxMindValue = maxv
    SaveData.MakeMeHappy_FaBaoToZhen = FaBaoToZhen
    SaveData.MakeMeHappy_FaBaoRate = FaBaoRate
    SaveData.MakeMeHappy_FaBaoAttackPower = FaBaoAttackPower
    local PutItemWindow = self:GetPutItemWindow()
    local Plan = PutItemWindow:GetPlan()
    SaveData.MakeMeHappy_Plan = Plan
    return SaveData
end

function MakeMeHappy:OnLoad(tbLoad)
    SaveData = tbLoad or {}
    local MMHWindow = self:GetMMHWindow()
    MMHWindow:SetEatList(SaveData.MakeMeHappy_EatItem)
    MMHWindow:SetEatNpcList(SaveData.MakeMeHappy_EatNpcList)
    MMHWindow:SetAutoTreatLing(SaveData.MakeMeHappy_AutoTreatLing)
    local minv = SaveData.MakeMeHappy_MinMindValue or 50
    local maxv = SaveData.MakeMeHappy_MaxMindValue or 80
    MMHWindow:SetMindValue(minv, maxv)
    MMHWindow:SetGuiZhen(SaveData.MakeMeHappy_FaBaoToZhen, SaveData.MakeMeHappy_FaBaoRate,
        SaveData.MakeMeHappy_FaBaoAttackPower)
    local PutItemWindow = self:GetPutItemWindow()
    PutItemWindow:SetPlan(SaveData.MakeMeHappy_Plan)
end

-- function MakeMeHappy:GetMMHWindow()
--     return GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_Window")
-- end

-- function MakeMeHappy:GetPutItemWindow()
--     return GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_PutItemWindow")
-- end

-- Seriously, I'm not sure if we need to use loops like this for potential race condition
-- And I'm not even sure if things are loaded synchronously - if so then this would also block the other file from loading
function MakeMeHappy:GetMMHWindow()
	local window = GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_Window")
	repeat
		window = GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_Window")
	until window
	return window
end

function MakeMeHappy:GetPutItemWindow()
	local window = GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_PutItemWindow")
	repeat
		window = GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_PutItemWindow")
	until window
	return window
end






