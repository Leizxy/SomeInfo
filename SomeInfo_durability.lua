local SomeInfo, info = ...

local durability = CreateFrame("Frame",nil,UIParent)
durability:EnableMouse(true)
local durability_Text = durability:CreateFontString(nil,"OVERLAY")
durability_Text:SetFont(unpack(info.Font))
durability:SetAllPoints(durability_Text)
info.Frames["durability"] = durability_Text

local durability_slots = {
	{1 ,"头", 1},
	{3 ,"肩", 1},
	{5 ,"胸", 1},
	{6 ,"腰", 1},
	{9 ,"腕", 1},
	{10,"手", 1},
	{7 ,"腿", 1},
	{8 ,"脚", 1},
	{16,"主", 1},
	{17,"副", 1}
}
durability:SetScript("OnEvent",function(self,event,...)
	local totalDurable, totalMax = 0,0
	for i = 1, #durability_slots do
		if GetInventoryItemLink("player",durability_slots[i][1]) ~= nil then
			local current,max = GetInventoryItemDurability(durability_slots[i][1])
			if current then
				durability_slots[i][3] = current/max
				totalDurable = totalDurable + current
				totalMax = totalMax + max
			end
		end
	end
	if totalDurable and totalMax then
		local per = floor(totalDurable/totalMax*100)
		local color = "|cffffffff"
		if per > 66 then
			color = "|cff0CD809"
		elseif per < 33 then
			color = "|cffD80909"
		else
			color = "|cffE8DA0F"
		end
		durability_Text:SetText(color..floor(totalDurable/totalMax*100).."%|r")
	else
		durability_Text:SetText("")
	end
end)
durability:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	end
end)
durability:RegisterEvent("MERCHANT_SHOW")
durability:RegisterEvent("PLAYER_ENTERING_WORLD")
durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

------------人物界面------------
--[[
do
   PAPERDOLL_STATCATEGORIES= {
      [1] = {
         categoryFrame = "AttributesCategory",
         stats = {
            [1] = { stat = "ATTACK_DAMAGE" },
            [2] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
            [3] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
            [4] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
            [5] = { stat = "STAMINA" },
            [6] = { stat = "ARMOR" },
            [7] = { stat = "ENERGY_REGEN", hideAt = 0 },
            [8] = { stat = "RUNE_REGEN", hideAt = 0 },
            [9] = { stat = "FOCUS_REGEN", hideAt = 0 },
            [10] = { stat = "MANAREGEN", roles =  { "HEALER" } },
            [11] = { stat = "ATTACK_AP" },
         },
      },
      [2] = {
         categoryFrame = "EnhancementsCategory",
         stats = {
            [1] = { stat = "CRITCHANCE", hideAt = 0 },
            [2] = { stat = "HASTE", hideAt = 0 },
            [3] = { stat = "MASTERY", hideAt = 0 },
            [4] = { stat = "VERSATILITY", hideAt = 0 },
            [5] = { stat = "LIFESTEAL", hideAt = 0 },
            [6] = { stat = "AVOIDANCE", hideAt = 0 },
            [7] = { stat = "DODGE", roles =  { "TANK" } },
            [8] = { stat = "PARRY", hideAt = 0, roles =  { "TANK" } },
            [9] = { stat = "BLOCK", hideAt = 0, roles =  { "TANK" } },
         },
      },
   };
   ---修改,若能量值获取不到.就设置为0,就能套用hideAt了
   PAPERDOLL_STATINFO["ENERGY_REGEN"].updateFunc = function(statFrame, unit) statFrame.numericValue=0; PaperDollFrame_SetEnergyRegen(statFrame, unit); end

   PAPERDOLL_STATINFO["RUNE_REGEN"].updateFunc = function(statFrame, unit) statFrame.numericValue=0; PaperDollFrame_SetRuneRegen(statFrame, unit); end

   PAPERDOLL_STATINFO["FOCUS_REGEN"].updateFunc = function(statFrame, unit) statFrame.numericValue=0; PaperDollFrame_SetFocusRegen(statFrame, unit); end

   --增加移动速度的代码(被暴雪删掉了)
   PAPERDOLL_STATINFO["MOVESPEED"].updateFunc =  function(statFrame, unit) PaperDollFrame_SetMovementSpeed(statFrame, unit); end


   --根据职业,做一些改动
   local _,_,classid = UnitClass("player")
   if (classid==1)then --战士

   elseif (classid==2)then --圣骑
   elseif (classid==3)then --猎人

   elseif (classid==4)then --盗贼

   elseif (classid==5)then --牧师
      PAPERDOLL_STATCATEGORIES[1].stats[1].roles={}   --隐藏伤害
   elseif (classid==6)then --DK

   elseif (classid==7)then --萨满
   elseif (classid==8)then --法师,加上回蓝显示
      PAPERDOLL_STATCATEGORIES[1].stats[1].roles={}
      table.insert(PAPERDOLL_STATCATEGORIES[1].stats,{ stat = "MANAREGEN" })
   elseif (classid==9)then --术士
      PAPERDOLL_STATCATEGORIES[1].stats[1].roles={}   --隐藏伤害
   elseif (classid==10)then --武僧

   elseif (classid==11)then --德鲁伊

   elseif (classid==12)then --DH

   end

   --加上移动速度(加最后)
   table.insert(PAPERDOLL_STATCATEGORIES[1].stats,{ stat = "MOVESPEED" })

   --关于移动速度代码(不然会出现错乱)
   local tempstatFrame
   hooksecurefunc("PaperDollFrame_SetMovementSpeed",function(statFrame, unit)
      if(tempstatFrame and tempstatFrame~=statFrame)then
        tempstatFrame:SetScript("OnUpdate",nil);
      end
      statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate);
      tempstatFrame = statFrame;
      statFrame:Show();
   end)
end
]]
------------打断----------------
-- 模式选择
local SoloMode = false      -- 单人模式,开启后当单独一人时会使用 说 通报...
local WaringMode = true   -- 警报模式,开启后不管在什么队伍都会使用 说 通报...
-- 默认信息
function ShowSpellLink(SpellID)
   local spellLink = GetSpellLink(SpellID or 0) or "<法术链接没有找到>"
   DEFAULT_CHAT_FRAME:AddMessage(spellLink)
end
-- 主体
local function OnEvent(self, event, ...)
   if (event == "PLAYER_LOGIN") then
      self:UnregisterEvent("PLAYER_LOGIN")
      self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
   elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
      local ZoneInfo = select(2, IsInInstance())
      local EventType, SourceName, DestName, SpellID, ExtraskillID = select(2, ...), select(5, ...), select(9, ...), select(12, ...), select(15, ...)
      if SourceName == UnitName("player") then
         if EventType == "SPELL_INTERRUPT" then
            Message = ("我好像打断了"..DestName..GetSpellLink(ExtraskillID))
         elseif EventType == "SPELL_DISPEL" then
            Message = ("已驱散" .. GetSpellLink(ExtraskillID))
         elseif EventType == "SPELL_STOLEN" then
            Message = ("已偷取" .. GetSpellLink(ExtraskillID))
         end
         if EventType == "SPELL_INTERRUPT" or EventType == "SPELL_DISPEL" or EventType == "SPELL_STOLEN" then
            if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then
               if ZoneInfo == "pvp" or ZoneInfo == "raid" or ZoneInfo == "party" or ZoneInfo == nil then
                  if WaringMode == true then
                     SendChatMessage(Message, "SAY")
                  else
                     SendChatMessage(Message, "INSTANCE_CHAT")
                  end
               end
            else
               if IsInRaid() == true then
                  if WaringMode == true then
                     SendChatMessage(Message, "SAY")
                  else
                     SendChatMessage(Message, "RAID")
                  end
               elseif GetNumSubgroupMembers() ~= nil and GetNumSubgroupMembers() > 0 then
                  if WaringMode == true then
                     SendChatMessage(Message, "SAY")
                  else
                     SendChatMessage(Message, "PARTY")
                  end
               elseif ZoneInfo == "none" then
                  if SoloMode == true then
                     SendChatMessage(Message, "SAY")
                  end
               end
            end
         end
      end
   end
end
local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")
Frame:SetScript("OnEvent", OnEvent)