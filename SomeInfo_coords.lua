local SomeInfo, info = ...

local coords = CreateFrame("Frame",nil,UIParent)
coords:EnableMouse(true)
local coords_Text = coords:CreateFontString(nil,"OVERLAY")
coords_Text:SetFont(unpack(info.Font))
coords_Text:SetShadowOffset(1,-1)
coords_Text:SetShadowColor(0, 0, 0, 0.5)
info.Frames["coords"] = coords_Text

coords:SetAllPoints(coords_Text)

local coordsX,coordsY = 0,0
local function formatCoords() return format("(|cff0CD809%d|r,|cff0CD809%d|r)",coordsX~=nil and coordsX*100 or 0,coordsY~=nil and coordsY*100 or 0) end
local function formatCoordsFloat() return format("(|cff0CD809%.1f|r,|cff0CD809%.1f|r)",coordsX*100,coordsY*100) end

coords:SetScript("OnUpdate",function(self)
	coordsX,coordsY = GetPlayerMapPosition("player")
--	if coordsX==nil or coordsY==nil then
--		return
--	end
	if self:IsMouseOver() then 
		-- coords_Text:SetText(formatCoordsFloat())
	else
		coords_Text:SetText(formatCoords())
	end
end)

coords:SetScript("OnMousedown", function(_,btn)
	if btn == "LeftButton" then
		ToggleFrame(WorldMapFrame)
	else
		ChatFrame_OpenChat(format("%s: %s","坐标",formatCoords()), chatFrame)
	end
end)
-- 地图上显示坐标
WorldMapButton:HookScript("OnUpdate", function(self)
	if not self.coordText then 
		--self.coordText = WorldMapFrameCloseButton:CreateFontString(nil, "OVERLAY", "GameFontGreen") 
		self.coordText = WorldMapFrameCloseButton:CreateFontString(nil, "OVERLAY", "GameFontWhite") 
		self.coordText:SetFont(UNIT_NAME_FONT, 14, "THINOUTLINE")
		self.coordText:SetPoint("BOTTOM", WorldMapScrollFrame, "BOTTOM", 0, -6) 
		self.coordText:SetShadowOffset(1,-1)
		self.coordText:SetShadowColor(0, 0, 0, 1)
	end 
	local px, py = GetPlayerMapPosition("player") 
	local x, y = GetCursorPosition() 
	local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetEffectiveScale() 
	local centerX, centerY = self:GetCenter() 
	x, y = (x/scale - (centerX - (width/2))) / width, (centerY + (height/2) - y/scale) / height 
	if px == 0 and py == 0 and (x > 1 or y > 1 or x < 0 or y < 0) then 
		self.coordText:SetText("") 
	elseif px == 0 and py == 0 then 
		self.coordText:SetText(format("Mouse: |cff0CD809%.1f, %.1f|r", x*100, y*100)) 
	elseif x > 1 or y > 1 or x < 0 or y < 0 then 
		self.coordText:SetText(format("You: |cff0CD809%.1f, %.1f|r", px~=nil and px*100 or 0, py~=nil and py*100 or 0))
	else 
		self.coordText:SetText(format("You: |cff0CD809%.1f, %.1f|r; Mouse: |cff0CD809%.1f, %.1f|r", px~=nil and px*100 or 0, py~=nil and py*100 or 0, x*100, y*100))
	end 
end)