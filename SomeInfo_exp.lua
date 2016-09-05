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
	-- local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent);
	while artifactXP >= xpForNextPoint and xpForNextPoint > 0 do
		artifactXP = artifactXP - xpForNextPoint;

		pointsSpent = pointsSpent + 1;
		numPoints = numPoints + 1;

		-- xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent);
	end
	return numPoints, artifactXP, xpForNextPoint;
end

info.ScriptOfFrame(experience, "OnEvent", function()
	local currentExp = UnitXP("player")
	local maxExp = UnitXPMax("player")
	local percentExp = tonumber(string.format("%.3f",currentExp / (maxExp == 0 and 1 or maxExp))) *100
	
	local fName,fStandingID,minRep,maxRep,currentRep = GetWatchedFactionInfo()
	-- if 
	
	--***********ARTIFACT***********(暂时与经验放一起)
	--	pointsSpent	花费的神器点数
	--	totalXP		获得的总神器能量
	-- local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo();
	-- =================
-- GetArtifacts() - returns a table array listing of obtained artifact weapons (includes bags, but not banks)
-- GetPowerPurchased(artifactID) - returns number of powers purchased for specified ID (or equipped if not specified)
-- GetPowers(artifactID) - returns a table array list of artifact powers, defaults to equipped artifact if no artifactID.
-- GetPowerInfo(powerID,artifactID) - returns an information array about the specified powerID, defaults to equipped artifact if no artifactID.
	local numPointsAvailableToSpend, xp, xpForNext = 0,0,0
	-- getArtifactXP(pointsSpent,totalXP)
	
	experience_Text:SetText((MaxLevel and "" or percentExp.."%"..info.SetColorText(4,"xp")..";")..
	"("..(numPointsAvailableToSpend ~= 0 and info.SetColorText(4,numPointsAvailableToSpend..",") or "")..
	info.SetColorText(5,xp.."/"..xpForNext)..")")
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
			-- test
			print(GetArtifacts())
		end
	end
end)
experience:RegisterEvent("PLAYER_LOGIN")
experience:RegisterEvent("PLAYER_XP_UPDATE")
experience:RegisterEvent("UPDATE_FACTION")