local Windows = GameMain:GetMod("Windows")
local MakeMeHappy_PutItemWindow = Windows:CreateWindow("MakeMeHappy_PutItemWindow")
local Plan = {}

function MakeMeHappy_PutItemWindow:OnInit()
    self.window.contentPane = UIPackage.CreateObject("MMHWindow", "SetPutItemWindow")
    self.window.closeButton = self:GetChild("frame"):GetChild("n5")
    self:GetChild("frame"):GetChild("title").text = XT("极乐世界（一键放置）")
    self:GetChild("explain").text = XT("*功能说明") .. "\r\n" .. XT("（重要）")
    self:GetChild("explain").tooltips = 
        XT("【重要说明】") .. "\r\n" ..
        XT("[color=#FF0000]请不要设置常用的置物台作为一键放置的置物台，注意看下面的【摆放原理】，确定理解了再设置，以免发生不幸事件[/color]") .. "\r\n" ..
        XT("【设置说明】") .. "\r\n" ..
        XT("先选择某种材料置物台，点击设置置物台，看到MOD面板上出现置物台名称则设置成功。摆放物也是同样设置方法。") .. "\r\n" ..
        XT("【摆放原理】") .. "\r\n" .. 
        XT("MOD会寻找地图上所有你设置的这种材料的置物台，然后摆上你设置要摆的物品。比如你设置了铁置物台摆放灵木，那么全图所有铁置物台上都会被摆上灵木。") ..
        XT("所以不要将聚灵阵里常用材料的置物台设置为MOD一键摆放的置物台，建议造一些不常用材料的置物台，比如灰石、大理石之类，专门用作MOD的一键摆放。") .. "\r\n" ..
        XT("【其他说明】") .. "\r\n" .. 
        XT("MOD一共内置五套方案，各自独立，对应五行聚灵阵。[color=#FF0000]这个MOD主要是为了手动灵气爆发而设计，不适合精细摆放。[/color]能正常解放双手，但不要做太骚的操作，可能会有BUG。") .. "\r\n" ..
        XT("[color=#FF0000]只能摆放可堆叠的物品。[/color]") .. "\r\n" ..
        XT("方案名可以自定义。")
    self.list = self:GetChild("list")
    self.window:Center()
    self.list:RemoveChildrenToPool()
    for i = 1, 5 do
        local listItem = self.list:AddItemFromPool()
        local tempPlan = {}
        tempPlan.title = listItem:GetChild("plan")
        tempPlan.title.text = Plan[i].title or XT("方案") .. i

        tempPlan.setshelfbtn = listItem:GetChild("setshelf")
        tempPlan.shelftext = listItem:GetChild("shelftext")
        tempPlan.shelftext.text = Plan[i].shelftext or XT("未设置")
        tempPlan.setshelfbtn.text = XT("设置置物台")
        tempPlan.setshelfbtn.onClick:Add(function(context)
            local thing = CS.XiaWorld.UILogicMode_Select.Instance.CurSelectThing
            if thing ~= nil then
                if thing.def.Name == "Building_ItemShelf" then
                    tempPlan.shelftext.text = thing:GetName()
                    Plan[i].shelftext = thing:GetName()
                end
            end
        end)

        tempPlan.setitembtn = listItem:GetChild("setitem")
        tempPlan.itemtext = listItem:GetChild("itemtext")
        tempPlan.itemtext.text = Plan[i].itemtext or XT("未设置")
        tempPlan.setitembtn.text = XT("设置摆放物")
        tempPlan.setitembtn.onClick:Add(function(context)
            local thing = CS.XiaWorld.UILogicMode_Select.Instance.CurSelectThing
            if thing ~= nil then
                if thing.ThingType == CS.XiaWorld.g_emThingType.Item then
                    tempPlan.itemtext.text = thing:GetName()
                    Plan[i].itemtext = thing:GetName()
                    Plan[i].item = thing.def.Name
                end
            end
        end)

        tempPlan.putallbtn = listItem:GetChild("putall")
        tempPlan.putallbtn.text = XT("全部放置")
        tempPlan.putallbtn.onClick:Add(function(context)
            if Plan[i].shelftext == XT("未设置") or Plan[i].itemtext == XT("未设置") then
            else
                local list = Map.Things:FindBuildingForTag("ItemShelf")

                for _, shelf in pairs(list) do
                    if shelf:CanWork() == true and shelf:GetName() == Plan[i].shelftext then
                        local itemthing = Map.Things:FindItem(null, 9999, Plan[i].item, 0, false, null, 0, 9999, null, false)
                        if itemthing then
                            shelf.Bag:AddBegItem(itemthing, 1, "PutCarry")
                        else
                            return
                        end
                    end
                end
            end
        end)

        tempPlan.dropallbtn = listItem:GetChild("dropall")
        tempPlan.dropallbtn.text = XT("全部丢下")
        tempPlan.dropallbtn.onClick:Add(function(context)
            if Plan[i].shelftext == XT("未设置") or Plan[i].itemtext == XT("未设置") then
            else
                local list = Map.Things:FindBuildingForTag("ItemShelf")
                for _, shelf in pairs(list) do
                    if shelf:CanWork() == true and shelf:GetName() == Plan[i].shelftext then
                        if shelf.Bag.m_lisItems.Count > 0 then
                            local item = shelf.Bag.m_lisItems[0]
                            if item.View ~= null then
                                item.View.gameObject:SetActive(true)
                            end
                            item:PickUp()
                            item:SetHide(false)
                            shelf.Bag:DropAll()
                            shelf.View:SendViewMessage("RemoveItem", null)
                        end
                    end
                end
            end
        end)
    end
end

function MakeMeHappy_PutItemWindow:OnShowUpdate()

end

function MakeMeHappy_PutItemWindow:OnShown() -- 显示窗口时

end

function MakeMeHappy_PutItemWindow:OnUpdate(dt)

end

function MakeMeHappy_PutItemWindow:UpdateItem(Item)

end

function MakeMeHappy_PutItemWindow:OnHide() -- 关闭窗口时
    local listItem = self.list:GetChildren()
    for i = 1, 5 do
        local tempItem = listItem[i - 1]:GetChild("plan")
        Plan[i].title = tempItem.text
    end
end

function MakeMeHappy_PutItemWindow:GetPlan()
    return Plan
end

function MakeMeHappy_PutItemWindow:SetPlan(tPlan)
    if tPlan ~= nil then
        Plan = tPlan
    else
        Plan = {}
        for i = 1, 5 do
            Plan[i] = {}
        end
    end
end
