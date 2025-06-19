-- Just stole some of this from delarmes raid thing.
-- Tenks dude

scannerWindow = api.Interface:CreateEmptyWindow("scannerWindow", "UIParent")
scannerWindow:SetExtent(320,450)
scannerWindow:AddAnchor("RIGHT", "UIParent", 0, -100)
scannerWindow.child = {}
scannerWindow.friendlyGuild = {}
scannerWindow.hostileGuild = {}


local offsetX = 30
local offsetY = 100
local labelHeight = 20

--- Add dragable bar across top
local moveWnd = scannerWindow:CreateChildWidget("label", "moveWnd", 0, true)
moveWnd:AddAnchor("TOPLEFT", scannerWindow, 12, 0)
moveWnd:AddAnchor("TOPRIGHT", scannerWindow, 0, 0)
moveWnd:SetHeight(80)
moveWnd.style:SetFontSize(FONT_SIZE.XLARGE)
moveWnd.style:SetAlign(ALIGN.LEFT)
moveWnd:SetText("")
ApplyTextColor(moveWnd, FONT_COLOR.WHITE)


-- Drag handlers for dragable bar
function moveWnd:OnDragStart(arg)
	if arg == nil or (arg == "LeftButton" and api.Input:IsShiftKeyDown()) then
	scannerWindow:StartMoving()
	api.Cursor:ClearCursor()
	api.Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
	end
end
moveWnd:SetHandler("OnDragStart", moveWnd.OnDragStart)
function moveWnd:OnDragStop()
	scannerWindow:StopMovingOrSizing()
	api.Cursor:ClearCursor()
end
moveWnd:SetHandler("OnDragStop", moveWnd.OnDragStop)
if moveWnd.RegisterForDrag ~= nil then
	moveWnd:RegisterForDrag("LeftButton")
end
if moveWnd.EnableDrag ~= nil then
    moveWnd:EnableDrag(true)
end


-- Main Label Menu 
local mainWindowLabel = api.Interface:CreateWidget("label", "mainWindowText", moveWnd)
mainWindowLabel:AddAnchor("TOPLEFT", moveWnd, 0, 3)
mainWindowLabel:SetExtent(100, 20)
ApplyTextColor(mainWindowLabel, FONT_COLOR.WHITE)
mainWindowLabel:SetText("Hom Scanner v0.4.2")


--- Minimized view & maximize button
minimizedWnd = api.Interface:CreateEmptyWindow("minimizedWnd", "UIParent2")
minimizedWnd:SetExtent(280, 40)
minimizedWnd:AddAnchor("TOPRIGHT", scannerWindow, 0, 0)
local minimizedLabel = minimizedWnd:CreateChildWidget("label", "minimizedLabel", 0, true)
minimizedLabel:SetText("Raid Stats (Hidden)")
minimizedLabel.style:SetFontSize(FONT_SIZE.XLARGE)
minimizedLabel.style:SetAlign(ALIGN.RIGHT)
minimizedLabel:AddAnchor("TOPRIGHT", minimizedWnd, -100, FONT_SIZE.XLARGE)
-- Dragable bar for minimized window too
local minimizedMoveWnd = minimizedWnd:CreateChildWidget("label", "minimizedMoveWnd", 0, true)
minimizedMoveWnd:AddAnchor("TOPLEFT", minimizedWnd, 12, 0)
minimizedMoveWnd:AddAnchor("TOPRIGHT", minimizedWnd, 0, 0)
minimizedMoveWnd:SetHeight(40)
-- Drag handlers for dragable bar
function minimizedMoveWnd:OnDragStart(arg)
	if arg == nil or (arg == "LeftButton" and api.Input:IsShiftKeyDown()) then
		minimizedWnd:StartMoving()
		api.Cursor:ClearCursor()
		api.Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
	end
end
minimizedMoveWnd:SetHandler("OnDragStart", minimizedMoveWnd.OnDragStart)
function minimizedMoveWnd:OnDragStop()
	minimizedWnd:StopMovingOrSizing()
	api.Cursor:ClearCursor()
end
minimizedMoveWnd:SetHandler("OnDragStop", minimizedMoveWnd.OnDragStop)
if minimizedMoveWnd.RegisterForDrag ~= nil then
	minimizedMoveWnd:RegisterForDrag("LeftButton")
end
if minimizedMoveWnd.EnableDrag ~= nil then
    minimizedMoveWnd:EnableDrag(true)
end


-- Minimized Window Background Styling
minimizedWnd.bg = minimizedWnd:CreateNinePartDrawable(TEXTURE_PATH.HUD, "background")
minimizedWnd.bg:SetTextureInfo("bg_quest")
minimizedWnd.bg:SetColor(0, 0, 0, 0.5)
minimizedWnd.bg:AddAnchor("TOPLEFT", minimizedWnd, 0, 0)
minimizedWnd.bg:AddAnchor("BOTTOMRIGHT", minimizedWnd, 0, 0)

minimizedWnd:Show(false) --> default to being hidden
minimizedWnd.isShown = false


scannerWindow.bg = scannerWindow:CreateNinePartDrawable(TEXTURE_PATH.HUD, "background")
scannerWindow.bg:SetTextureInfo("bg_quest")
scannerWindow.bg:SetColor(0, 0, 0, 0.5)
scannerWindow.bg:AddAnchor("TOPLEFT", scannerWindow, 0, 0)
scannerWindow.bg:AddAnchor("BOTTOMRIGHT", scannerWindow, 0, 0)


local minimizeButton = scannerWindow:CreateChildWidget("button", "minimizeButton", 0, true)
minimizeButton:SetExtent(26, 28)
minimizeButton:AddAnchor("TOPRIGHT", scannerWindow, -12, 5)
local minimizeButtonTexture = minimizeButton:CreateImageDrawable(TEXTURE_PATH.HUD, "background")
minimizeButtonTexture:SetTexture(TEXTURE_PATH.HUD)
minimizeButtonTexture:SetCoords(754, 121, 26, 28)
minimizeButtonTexture:AddAnchor("TOPLEFT", minimizeButton, 0, 0)
minimizeButtonTexture:SetExtent(26, 28)


minimizedWnd = api.Interface:CreateEmptyWindow("minimizedWnd", "UIParent")
minimizedWnd:SetExtent(280, 40)
minimizedWnd:AddAnchor("TOPRIGHT", scannerWindow, 0, 0)
local minimizedLabel = minimizedWnd:CreateChildWidget("label", "minimizedLabel", 0, true)
minimizedLabel:SetText("View scanned players...")
minimizedLabel.style:SetFontSize(FONT_SIZE.XLARGE)
minimizedLabel.style:SetAlign(ALIGN.RIGHT)
minimizedLabel:AddAnchor("TOPRIGHT", minimizedWnd, -100, FONT_SIZE.XLARGE)

-- Dragable bar for minimized window too
local minimizedMoveWnd = minimizedWnd:CreateChildWidget("label", "minimizedMoveWnd", 0, true)
minimizedMoveWnd:AddAnchor("TOPLEFT", minimizedWnd, 12, 0)
minimizedMoveWnd:AddAnchor("TOPRIGHT", minimizedWnd, 0, 0)
minimizedMoveWnd:SetHeight(40)

-- Toggle back to maximized view with this button
local maximizeButton = minimizedWnd:CreateChildWidget("button", "maximizeButton", 0, true)
maximizeButton:SetExtent(26, 28)
maximizeButton:AddAnchor("TOPRIGHT", minimizedWnd, -12, 5)
local maximizeButtonTexture = maximizeButton:CreateImageDrawable(TEXTURE_PATH.HUD, "background")
maximizeButtonTexture:SetTexture(TEXTURE_PATH.HUD)
maximizeButtonTexture:SetCoords(754, 94, 26, 28)
maximizeButtonTexture:AddAnchor("TOPLEFT", maximizeButton, 0, 0)
maximizeButtonTexture:SetExtent(26, 28)

scannerWindow.minimizeButton:SetHandler("OnClick", function()
  local statsMeterX, statsMeterY = scannerWindow:GetOffset()
  minimizedWnd:RemoveAllAnchors()
  minimizedWnd:AddAnchor("TOPRIGHT", scannerWindow, 0, 0)
  scannerWindow:Show(false)
  minimizedWnd:Show(true)
  minimizedWnd.isShown = true
end)

minimizedWnd.maximizeButton:SetHandler("OnClick", function()
  scannerWindow:RemoveAllAnchors()
  scannerWindow:AddAnchor("TOPLEFT", minimizedWnd, 0, 0)
  minimizedWnd:Show(false)
  scannerWindow:Show(true)
  minimizedWnd.isShown = false
  Update()
end)


function minimizedMoveWnd:OnDragStart(arg)
	if arg == nil or (arg == "LeftButton" and api.Input:IsShiftKeyDown()) then
		minimizedWnd:StartMoving()
		api.Cursor:ClearCursor()
		api.Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
	end
end
minimizedMoveWnd:SetHandler("OnDragStart", minimizedMoveWnd.OnDragStart)
function minimizedMoveWnd:OnDragStop()
	minimizedWnd:StopMovingOrSizing()
	api.Cursor:ClearCursor()
end
minimizedMoveWnd:SetHandler("OnDragStop", minimizedMoveWnd.OnDragStop)
if minimizedMoveWnd.RegisterForDrag ~= nil then
	minimizedMoveWnd:RegisterForDrag("LeftButton")
end
if minimizedMoveWnd.EnableDrag ~= nil then
    minimizedMoveWnd:EnableDrag(true)
end



-- Create Scanned Players Label
scannerWindow.child['scannedPlayers'] = api.Interface:CreateWidget("label", "scannedPlayers", scannerWindow)
local child = scannerWindow.child['scannedPlayers']
child:AddAnchor("TOPLEFT", 12, 30)
child:SetExtent(255, labelHeight)
child:SetText("Total scanned players" .. ": " .. "0")
child.style:SetColor(1, 1, 1, 1)
child.style:SetAlign(ALIGN.LEFT)
ApplyTextColor(child, FONT_COLOR.WHITE)

-- Setup Friendly Scan Text
scannerWindow.child['friendlyScan'] = api.Interface:CreateWidget("label", "friendlyScan", scannerWindow)
local friendScan = scannerWindow.child['friendlyScan']
friendScan:AddAnchor("TOPLEFT", 10, 60)
friendScan:SetText("Friendly" .. ": 0")
friendScan:SetExtent(255, labelHeight)
friendScan.style:SetColor(1, 1, 1, 1)
friendScan.style:SetAlign(ALIGN.LEFT)
ApplyTextColor(friendScan, FONT_COLOR.GREEN)

-- Setup Hostile Scan Text
scannerWindow.child['hostileScan'] = api.Interface:CreateWidget("label", "hostileScan", scannerWindow)
local hostileScan = scannerWindow.child['hostileScan']
hostileScan:AddAnchor("TOPLEFT", 160, 60)
hostileScan:SetExtent(255, labelHeight)
hostileScan:SetText("Hostile" .. ": 0")
hostileScan.style:SetColor(1, 1, 1, 1)
hostileScan.style:SetAlign(ALIGN.LEFT)
ApplyTextColor(hostileScan, FONT_COLOR.RED)

-- Draw X Seperators (320,450)
scannerWindow.child['seperatorX'] = W_BAR.CreateExpBar("someTest", scannerWindow)
local someTest = scannerWindow.child['seperatorX']
someTest:AddAnchor("TOPLEFT", 5, 80)
someTest:SetExtent(305, 2)

-- Draw Y Seperators
scannerWindow.child['seperatorY'] = W_BAR.CreateExpBar("someTest2", scannerWindow)
local someTest = scannerWindow.child['seperatorY']
someTest:AddAnchor("TOPLEFT", 160, 81)
someTest:SetExtent(2, 369)


for i = 1, 17 do
	local friendId = "friend" .. i
	local hostileId = "friend" .. i
    scannerWindow.friendlyGuild[i] = api.Interface:CreateWidget("label", friendId, scannerWindow)
	scannerWindow.hostileGuild[i] = api.Interface:CreateWidget("label", hostileId, scannerWindow)
	-- Setup left side labels 
    local child = scannerWindow.friendlyGuild[i]
    child:AddAnchor("TOPLEFT", 12, offsetY)
    child:SetExtent(255, labelHeight)
    child.style:SetColor(1, 1, 1, 1)
    child.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(child, FONT_COLOR.GREEN)

	-- Setup right side labels 
	local child = scannerWindow.hostileGuild[i]
	child:AddAnchor("TOPLEFT", 165, offsetY)
    child:SetExtent(255, labelHeight)
    child.style:SetColor(1, 1, 1, 1)
    child.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(child, FONT_COLOR.RED)

    offsetY = offsetY + labelHeight

end


masterScan = { 
	minimizedWnd = minimizedWnd,
	scannerWindow = scannerWindow
}

return masterScan