local SomeInfo, info = ...

local experience = CreateFrame("Frame",nil,UIParent)
experience:EnableMouse(true)
local experience_Text = experience:CreateFontString(nil,"OVERLAY")
experience_Text:SetFont(unpack(info.Font))
experience:SetAllPoints(experience_Text)
info.Frames["experience"] = experience_Text
local MaxLevel = UnitLevel("player") == 110
-- artifact func
local function getArtifactXP(pointsSpent, artifactXP)
	local numPoints = 0;
	local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent);
	while artifactXP >= xpForNextPoint and xpForNextPoint > 0 do
		artifactXP = artifactXP - xpForNextPoint;

		pointsSpent = pointsSpent + 1;
		numPoints = numPoints + 1;

		xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent);
	end
	return numPoints, artifactXP, xpForNextPoint;
end

info.ScriptOfFrame(experience, "OnEvent", function(self,event,...)
	-- if event == "PLAYER_ENTERING_WORLD" 
	local currentExp = UnitXP("player")
	local maxExp = UnitXPMax("player")
	local percentExp = tonumber(string.format("%.3f",currentExp / (maxExp == 0 and 1 or maxExp))) *100
	
	local fName,fStandingID,minRep,maxRep,currentRep = GetWatchedFactionInfo()
	-- if 
	
	--***********ARTIFACT***********(暂时与经验放一起)
	--	pointsSpent	花费的神器点数
	--	totalXP		获得的总神器能量
	-- local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo();
	local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _ = C_ArtifactUI.GetEquippedArtifactInfo();
	-- if event == ""
	local numPointsAvailableToSpend, xp, xpForNext
	if HasArtifactEquipped() then 
		numPointsAvailableToSpend, xp, xpForNext = getArtifactXP(pointsSpent,totalXP)
	else
		numPointsAvailableToSpend, xp, xpForNext = 0,0,0
	end
	-- =================
	
	experience_Text:SetText((MaxLevel and "" or percentExp.."%"..info.SetColorText(4,"xp")..";")..
	"("..(numPointsAvailableToSpend ~= 0 and info.SetColorText(4,numPointsAvailableToSpend..",") or "")..
	info.SetColorText(5,xp.."/"..xpForNext)..")")
	
	local func = function()
		if info.Experience_ggtShow then
			GameTooltip:SetOwner(experience,"ANCHOR_BOTTOMLEFT",experience_Text:GetWidth(),-5)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Experience_ggtposi))
			GameTooltip:ClearLines()
			GameTooltip:AddLine((MaxLevel and "" or COMBAT_XP_GAIN.." & ")..REPUTATION,0,.6,1)
			GameTooltip:AddLine' '
			if not MaxLevel then
				GameTooltip:AddDoubleLine(COMBAT_XP_GAIN..":",currentExp.."/"..maxExp,1,1,1)
			end
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
			if HasArtifactEquipped() then
				-- 打开神器界面
				-- 如果上线第一次打开会有卡顿，试试这一段代码
				-- local loaded,reason = LoadAddOn("Blizzard_ArtifactUI")
				-- if loaded then
					-- SocketInventoryItem(16)
				-- end
				SocketInventoryItem(16)				
			end
		else
			ToggleCharacter("ReputationFrame")	
		end
	end
end)
experience:RegisterEvent("PLAYER_LOGIN")
experience:RegisterEvent("PLAYER_XP_UPDATE")
experience:RegisterEvent("UPDATE_FACTION")
experience:RegisterEvent("PLAYER_ENTERING_WORLD")
experience:RegisterEvent("ARTIFACT_XP_UPDATE")
experience:RegisterEvent("UNIT_INVENTORY_CHANGED")
