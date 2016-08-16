local SomeInfo, info = ...

local experience = CreateFrame("Frame",nil,UIParent)
experience:EnableMouse(true)
local experience_Text = experience:CreateFontString(nil,"OVERLAY")
experience_Text:SetFont(unpack(info.Font))
experience:SetAllPoints(experience_Text)
info.Frames[experience] = experience_Text

info.ScriptOfFrame(experience, "OnEvent", function()
	local currentExp = UnitXP("player")
	local maxExp = UnitXPMax("player")
	local percentExp = tonumber(string.format("%.3f",currentExp / maxExp)) *100
	
	local fName,fStandingID,minRep,maxRep,currentRep = GetWatchedFactionInfo()
	-- if 
	experience_Text:SetText(percentExp.."%"..info.SetColorText(4," xp"))
	-- local Standing = {FACTION_STANDING_LABEL1,FACTION_STANDING_LABEL2,FACTION_STANDING_LABEL3,
					-- FACTION_STANDING_LABEL4,FACTION_STANDING_LABEL5,FACTION_STANDING_LABEL6,
					-- FACTION_STANDING_LABEL7,FACTION_STANDING_LABEL8}
	local func = function()
		if info.Experience_ggtShow then
			GameTooltip:SetOwner(experience,"ANCHOR_BOTTOMLEFT",experience_Text:GetWidth(),-5)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Experience_ggtposi))
			GameTooltip:ClearLines()
			GameTooltip:AddLine(COMBAT_XP_GAIN.." & "..REPUTATION,0,.6,1)
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(COMBAT_XP_GAIN..":",currentExp.."/"..maxExp,1,1,1)
			if fName ~= nil then
				GameTooltip:AddDoubleLine(fName..":",info.change_color(FACTION_BAR_COLORS[fStandingID])..
					currentRep-minRep == 0 and 0 or currentRep-minRep.."/"..maxRep-minRep.."(".._G["FACTION_STANDING_LABEL"..fStandingID]..")",1,1,1)
			end
			-- GameTooltip:
			GameTooltip:Show()
		end
	end
	info.ShowGameToolTip(experience,func)
end)
experience:SetScript("OnMouseDown",function(self,button)
	if info.Experience_ggtShow then
		if button == "RightButton" then
		else
			ToggleCharacter("ReputationFrame")
		end
	end
end)
experience:RegisterEvent("PLAYER_LOGIN")
experience:RegisterEvent("PLAYER_XP_UPDATE")
experience:RegisterEvent("UPDATE_FACTION")