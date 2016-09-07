local slot = {"Head","Neck","Shoulder","Shirt","Chest","Waist","Legs","Feet","Wrist","Hands","Finger0","Finger1","Trinket0","Trinket1","Back","MainHand","SecondaryHand","Tabard"} 
local ilv = {} 

local function createIlvText(slotName) 
	if not ilv[slotName] then 
		local fs = _G[slotName]:CreateFontString(nil, "OVERLAY") 
		fs:SetPoint("TOP", _G[slotName], "TOP", 0, 0) 
		fs:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE") 
		ilv[slotName] = fs 
	end 
end 

for k, v in pairs(slot) do createIlvText("Character"..v.."Slot") end 

local function checkItem(unit, frame) 
	if unit then 
		for k, v in pairs(slot) do 
			local itemLink = GetInventoryItemLink(unit, k) 
			if itemLink then 
				local _,_,itemQuality,itemLv = GetItemInfo(itemLink) 
				local r,g,b = GetItemQualityColor(itemQuality) 
				ilv[frame..v.."Slot"]:SetText(itemLv) 
				ilv[frame..v.."Slot"]:SetTextColor(r,g,b) 
			else 
				ilv[frame..v.."Slot"]:SetText() 
			end 
		end 
	end 
end 

_G["CharacterFrame"]:HookScript("OnShow", function(self) 
	checkItem("player", "Character") 
	self:RegisterEvent("UNIT_MODEL_CHANGED") 
end) 

_G["CharacterFrame"]:HookScript("OnHide", function(self) 
	self:UnregisterEvent("UNIT_MODEL_CHANGED") 
end) 

_G["CharacterFrame"]:HookScript("OnEvent", function(self, event) 
	if event == "UNIT_MODEL_CHANGED" then 
		checkItem("player", "Character") 
	end 
end) 

local F = CreateFrame("Frame") 
F:RegisterEvent("ADDON_LOADED") 
F:SetScript("OnEvent", function(self, event, addon) 
	if addon == "Blizzard_InspectUI" then 
		self:UnregisterEvent("ADDON_LOADED") 
		self:SetScript("OnEvent", nil) 

		for k, v in pairs(slot) do 
			createIlvText("Inspect"..v.."Slot") 
		end 
		checkItem(_G["InspectFrame"].unit, "Inspect") 

		_G["InspectFrame"]:HookScript("OnShow", function() 
			self:RegisterEvent("INSPECT_READY") 
			self:RegisterEvent("UNIT_MODEL_CHANGED") 
			self:RegisterEvent("PLAYER_TARGET_CHANGED") 
			self:SetScript("OnEvent", function() 
				checkItem(_G["InspectFrame"].unit, "Inspect") 
			end) 
		end) 

		_G["InspectFrame"]:HookScript("OnHide", function() 
			self:UnregisterEvent("PLAYER_TARGET_CHANGED") 
			self:UnregisterEvent("UNIT_MODEL_CHANGED") 
			self:UnregisterEvent("INSPECT_READY") 
			self:SetScript("OnEvent", nil) 
		end) 

	end 
end)
