local MakeMeHappy = GameMain:NewMod("MakeMeHappy")
local count = 0
local count1 = 0
local SaveData = {}

local BridgeMod = GameMain:GetMod("Jai_MobileHotkeyBridge")

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
	
	
	-- Added by Jai
	BridgeMod:register("Elysium", "Open UI",
		function()
			local MMHWindow = self:GetMMHWindow()
			MMHWindow:Show()
		end
	)
	BridgeMod:register("Elysium", "One-Click Change Talisman",
		function()
			local MMHWindow = self:GetMMHWindow()
			MMHWindow:Show()
			MMHWindow:ChangeFu()
		end
	)
	BridgeMod:register("Elysium", "One-Click Put Item",
		function()
			local PutItemWindow = self:GetPutItemWindow()
			PutItemWindow:Show()
		end
	)
	
	BridgeMod:register("Test2", "Test",
		function()
		end
	)
	BridgeMod:register("Test3", "Test",
		function()
		end
	)
	BridgeMod:register("Test4", "Test",
		function()
		end
	)
	BridgeMod:register("Test5", "Test",
		function()
		end
	)
	BridgeMod:register("Test6", "Test",
		function()
		end
	)
end

function MakeMeHappy:OnEnter()

end

function MakeMeHappy:OnSetHotKey()
    local tbHotKeys = {{
        ID = "MakeMeHappy",
        Name = "极乐世界",
        Type = "Mod",
        InitialKey1 = "LeftShift + E",
        InitialKey2 = "RightShift + E"
    }, {
        ID = "MakeMeHappy_ChangeFu",
        Name = "极乐世界（一键换符）",
        Type = "Mod",
        InitialKey1 = "LeftShift + R",
        InitialKey2 = "RightShift + R"
    }, {
        ID = "MakeMeHappy_SetPutItem",
        Name = "极乐世界（一键放置）",
        Type = "Mod",
        InitialKey1 = "LeftShift + T",
        InitialKey2 = "RightShift + T"
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

function MakeMeHappy:GetMMHWindow()
    return GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_Window")
end

function MakeMeHappy:GetPutItemWindow()
    return GameMain:GetMod("Windows"):GetWindow("MakeMeHappy_PutItemWindow")
end
