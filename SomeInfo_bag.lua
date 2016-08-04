local SomeInfo, info = ...

local bag = CreateFrame("Frame")--frame
bag:EnableMouse(true)
local bag_text = bag:CreateFontString(nil,"OVERLAY")
bag_text:SetFont(unpack(info.Font))
bag_text:SetPoint(unpack(info.Bag_position))
-- test
print(info.test("functest"))
local width,height = bag_text:GetWidth(),bag_text:GetHeight()
info.test(width..","..height)

local function OnEvent(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		--print("infight")
		info.Bag_gttShow = false
	elseif event == "PLAYER_REGEN_ENABLED" then
		--print("outfight")
		info.Bag_gttShow = true
	end
	--背包空间计算逻辑
	local free, total, used = 0,0,0
	for i = 0,NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	
	bag_text:SetText("背包:"..free)
	self:SetAllPoints(bag_text)
	

		-- print(bag:GetMaxResize()))	
	--ggt(悬浮界面)
	bag:SetScript("OnEnter",function()
		-- 获取bag的宽高
	
		if info.Bag_gttShow then
			GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,0)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Bag_gttPosition))
			GameTooltip:ClearLines()
			--GameTooltip:AddLine("  ")
			GameTooltip:AddLine(used.."/"..total,1,1,1)
			--GameTooltip:AddDoubleLine("",free.."/"..total.."  ",0.6,0.8,1,1,1,1)
			GameTooltip:Show()
		end
	end)
	bag:SetScript("OnLeave",function()GameTooltip:Hide()end)
	
end
bag:SetScript("OnEvent",OnEvent)
bag:SetScript("OnMouseDown", function(self,button)
	if info.Bag_gttShow then
		if button == "RightButton" then
			print("click rb")
		else
			ToggleAllBags()
		end
	end
end)

bag:RegisterEvent("PLAYER_LOGIN")
bag:RegisterEvent("BAG_UPDATE")
bag:RegisterEvent("PLAYER_REGEN_DISABLED")
bag:RegisterEvent("PLAYER_REGEN_ENABLED")

--自动卖垃圾
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	--if diminfo.AutoSell == true then
	local c = 0
	for b = 0, 4 do
		for s = 1, GetContainerNumSlots(b) do
			local l = GetContainerItemLink(b, s)
			if l and GetItemInfo(l) ~= nil then
				local p = select(11, GetItemInfo(l)) * select(2, GetContainerItemInfo(b, s))
				if select(3, GetItemInfo(l)) == 0 and p > 0 then
					UseContainerItem(b, s)
					PickupMerchantItem()
					c = c + p
				end
			end
		end
	end
	if c > 0 then
		--print(format("|cff99CCFF"..infoL["Your vendor trash has been sold and you earned"].."|r|cffFFFFFF%.1f|r|cffffd700%s|r", c * 0.0001,GOLD_AMOUNT_SYMBOL))
		local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100 
		DEFAULT_CHAT_FRAME:AddMessage("卖垃圾卖了".." |cffffffff"..g.."|cffffc125g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,255)
	end
	--end
end)
f:RegisterEvent("MERCHANT_SHOW")
