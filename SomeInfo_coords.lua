local SomeInfo, info = ...

local coords = CreateFrame("Frame",nil,UIParent)
coords:EnableMouse(true)
local coords_Text = coords:CreateFontString(nil,"OVERLAY")
coords_Text:SetFont(unpack(info.Font))
info.Frames["coords"] = coords_Text

coords:SetAllPoints(coords_Text)

local coordsX,coordsY = 0,0
local function formatCoords() return format("%d,%d",coordsX*100,coordsY*100) end
local function formatCoordsFloat() return format("%.1f,%.1f",coordsX*100,coordsY*100) end

coords:SetScript("OnUpdate",function()
	coordsX,coordsY = GetPlayerMapPosition("player")
	if self:IsMouseOver() then 
		coords_Text:SetText(formatCoordsFloat())
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
		self.coordText:SetPoint("BOTTOM", self, "BOTTOM", 0, 6) 
	end 
	local px, py = GetPlayerMapPosition("player") 
	local x, y = GetCursorPosition() 
	local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetEffectiveScale() 
	local centerX, centerY = self:GetCenter() 
	x, y = (x/scale - (centerX - (width/2))) / width, (centerY + (height/2) - y/scale) / height 
	if px == 0 and py == 0 and (x > 1 or y > 1 or x < 0 or y < 0) then 
		self.coordText:SetText("") 
	elseif px == 0 and py == 0 then 
		self.coordText:SetText(format("mouse: |cff0CD809%.1f, %.1f|r", x*100, y*100)) 
	elseif x > 1 or y > 1 or x < 0 or y < 0 then 
		self.coordText:SetText(format("player: |cff0CD809%.1f, %.1f|r", px*100, py*100)) 
	else 
		self.coordText:SetText(format("player: |cff0CD809%.1f, %.1f|r; mouse: |cff0CD809%.1f, %.1f|r", px*100, py*100, x*100, y*100)) 
	end 
end)