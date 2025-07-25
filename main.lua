local api = require("api")
local scanAlgorithm = require("hom_scanner/scannerAlgorithm")
local chunkRate = 150 -- Chunk scan update rate 150 * 16 = 2.4 seconds per update
local bruteRate = 2400 -- Brute force method update rate 2 seconds per update
scanAlgorithm.scanMethod = "CHUNK" -- change to BRUTE_FORCE or CHUNK TO CHANGE METHODS

local hom_scanner = {
  name = "Hom Scanner",
  version = "0.4.3",
  author = "Nyella",
  desc = "Scans the region for total amount of friendly or hostile players"
}



local function OnUpdate(dt)

  if masterScan.minimizedWnd.isShown then 
    scanAlgorithm:resetScanData()
    return
  end 

  if scanAlgorithm.scanMethod == "BRUTE_FORCE" then

    if scanAlgorithm.lastUpdate > bruteRate then 
      scanAlgorithm:bruteForce()
    else
      scanAlgorithm.lastUpdate = scanAlgorithm.lastUpdate + dt
    end
  elseif scanAlgorithm.scanMethod == "CHUNK" then 
    if scanAlgorithm.lastUpdate > chunkRate then 
      scanAlgorithm:chunkScan()
    else
      scanAlgorithm.lastUpdate = scanAlgorithm.lastUpdate + dt
    end
  end

  if scanAlgorithm.scanComplete then 

    scanAlgorithm:parseScanData()

    scanAlgorithm:sortGuilds()

    -- Reset Text Labels (We do this since could be less than 17 guilds scanned)
    for i = 1, 17 do
      masterScan.scannerWindow.friendlyGuild[i]:SetText("")
      masterScan.scannerWindow.hostileGuild[i]:SetText("")
    end 

    -- indexCounters
    local friendCount = 1
    local hostileCount = 1 

    -- Set Friend Labels
    for _, entry in ipairs(scanAlgorithm.friendGuild) do
        if entry.value ~= 0 and friendCount < 18 then
          entryValue = entry.key
          combinedString = entryValue:sub(1,16) .. ": " .. entry.value
          masterScan.scannerWindow.friendlyGuild[friendCount]:SetText(combinedString)
          friendCount = friendCount + 1
        end
    end
    
    -- Set Hostile Labels
    for _, entry in ipairs(scanAlgorithm.hostileGuild) do
        if entry.value ~= 0 and hostileCount < 18 then
          entryValue = entry.key
          combinedString = entryValue:sub(1,14) .. ": " .. entry.value
          masterScan.scannerWindow.hostileGuild[hostileCount]:SetText(combinedString)
          hostileCount = hostileCount + 1
        end
    end

    masterScan.scannerWindow.child['scannedPlayers']:SetText("Total scanned players: " .. scanAlgorithm.friendScanned + scanAlgorithm.hostileScanned)
    masterScan.scannerWindow.child['friendlyScan']:SetText("Friendly: " .. scanAlgorithm.friendScanned)
    masterScan.scannerWindow.child['hostileScan']:SetText("Hostile: " .. scanAlgorithm.hostileScanned)
    scanAlgorithm:resetScanData()
  
  end
    --api.File:Write("./hom_scanner/Abcdef.txt", scannedPlayers)

  -- Probably shouldnt be doing all this onUpdate. 
 
end

local function OnLoad()
  api.Log:Info("HOM Scanner " .. hom_scanner.version .. " loaded")
  masterScan = require("hom_scanner/scannerView")
  masterScan.scannerWindow.mainWindowLabel:SetText("Hom Scanner v" .. hom_scanner.version)
  masterScan.scannerWindow:Show(true)

  api.On("UPDATE", OnUpdate)
end

local function OnUnload()
  if masterScan ~= nil then 
    api.Interface:Free(masterScan.scannerWindow)
  end 
  if masterScan ~= nil then 
    api.Interface:Free(masterScan.minimizedWnd)
  end 
end

hom_scanner.OnLoad = OnLoad
hom_scanner.OnUnload = OnUnload

return hom_scanner



