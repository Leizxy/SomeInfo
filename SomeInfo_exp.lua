local SomeInfo, info = ...

local experience = CreateFrame("Frame",nil,UIParent)
experience:EnableMouse(true)
local experience_Text = experience:CreateFontString(nil,"OVERLAY")
experience_Text:SetFont(unpack(info.Font))
experience:SetAllPoints(experience_Text)
info.Frames[4] = experience_Text

info.ScriptOfFrame(experience, "OnEvent", function()
	local currentExp = UnitXP("player")
	local maxExp = UnitXPMax("player")
	local percentExp = string.format("%.3f",currentExp / maxExp) *100
	
	local fName,fStandingID,minRep,maxRep,currentRep = GetWatchedFactionInfo()
	
	experience_Text:SetText(percentExp.."%|cffff3300Xp|r")
	
	local func = function()
		if info.Experience_ggtShow then
			GameTooltip:SetOwner(experience,"ANCHOR_BOTTOMRIGHT",-experience_Text:GetWidth(),-5)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Experience_ggtposi))
			GameTooltip:ClearLines()
			GameTooltip:AddLine(COMBAT_XP_GAIN.." & "..REPUTATION,0,.6,1)
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(COMBAT_XP_GAIN..":",currentExp.."/"..maxExp)
			GameTooltip:AddDoubleLine(fName..":",info.change_color(FACTION_BAR_COLORS[fStandingID])..
				currentRep-minRep.."/"..maxRep-minRep.."("..FACTION_STANDING_LABEL[fStandingID]..")")
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