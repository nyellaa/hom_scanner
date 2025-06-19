scanAlgorithm = {
    scannedPlayers = {},
    scanMethod = "BRUTE_FORCE",
    friendGuild = {},
    hostileGuild = {},
    friendScanned = 0,
    hostileScanned = 0,
    currentChunk = 1,
    lastUpdate = 0,
    scanComplete = false
}

scanAlgorithm.friendGuild['No guild (friendly)'] = 0
scanAlgorithm.hostileGuild['No guild (hostile)'] = 0

function scanAlgorithm:bruteForce()
        local hex_chars = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' }
        for i1 = 1, 2 do  -- Modify this for scan accuaracy. Do
            for i2 = 1, 16 do
                for i3 = 1, 16 do
                    for i4 = 1, 16 do
                        for i5 = 1, 16 do
    
                            local hexString = hex_chars[i1] .. hex_chars[i2] .. hex_chars[i3] .. hex_chars[i4] .. hex_chars[i5]
                            local targetUnit = api.Unit:GetUnitInfoById(hexString)
                                        
                            if not (targetUnit == nil) and (targetUnit.type == "character") then
                                self.scannedPlayers[hexString] = targetUnit
                            end
                        end
                    end
                end
            end
        end

        self.scanComplete = true 
        self.lastUpdate = 0
end 

function scanAlgorithm:chunkScan()
        local hex_chars = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' }
        for i1 = 1, 2 do  -- Modify this for scan accuaracy. Do
            for i2 = 1, 16 do
                for i3 = 1, 16 do
                    for i4 = 1, 16 do
                        for i5 = self.currentChunk, self.currentChunk + 1 do
    
                            local hexString = hex_chars[i1] .. hex_chars[i2] .. hex_chars[i3] .. hex_chars[i4] .. hex_chars[i5]
                            local targetUnit = api.Unit:GetUnitInfoById(hexString)
                                   
                            if not (targetUnit == nil) and (targetUnit.type == "character") then
                                self.scannedPlayers[hexString] = targetUnit
                            end
                        end
                    end
                end
            end
        end
        
        self.currentChunk = self.currentChunk + 1
       

        if self.currentChunk > 15 then
            self.scanComplete = true
            self.currentChunk = 1
        end 

        self.lastUpdate = 0
        
end 


function scanAlgorithm:resetScanData()
    self.scannedPlayers = {}
    self.friendGuild = {}
    self.hostileGuild = {}
    self.friendScanned = 0
    self.hostileScanned = 0
    self.currentChunk = 1
    self.lastUpdate = 0
    self.scanComplete = false
    self.friendGuild['No guild (friendly)'] = 0
    self.hostileGuild['No guild (hostile)'] = 0
    
end

-- Function for parsing the scan data. Expects that you store the entire player object in scannedPlayers = {}
function scanAlgorithm:parseScanData()
        -- Seperate Into Guilds
        for key, player in pairs(self.scannedPlayers) do 
            if (player.faction == "friendly") and (player.expeditionName ~= nil) then 
                if (self.friendGuild[player.expeditionName] ~= nil) then
                    self.friendGuild[player.expeditionName] = self.friendGuild[player.expeditionName] + 1
                else 
                    self.friendGuild[player.expeditionName] = 1
                end
            elseif(player.faction == "friendly") and (player.expeditionName == nil) then
                self.friendGuild['No guild (friendly)'] = self.friendGuild['No guild (friendly)'] + 1
            elseif(player.faction == "hostile") and (player.expeditionName ~= nil) then
                if (self.hostileGuild[player.expeditionName] ~= nil) then
                    self.hostileGuild[player.expeditionName] = self.hostileGuild[player.expeditionName] + 1
                else 
                    self.hostileGuild[player.expeditionName] = 1
                end
            elseif(player.faction == "hostile") and (player.expeditionName == nil) then
                self.hostileGuild['No guild (hostile)'] = self.hostileGuild['No guild (hostile)'] + 1
            end
        end 


        -- Tally total counts
        for guild, count in pairs(self.friendGuild) do self.friendScanned = self.friendScanned + count end
        for guild, count in pairs(self.hostileGuild) do self.hostileScanned = self.hostileScanned + count end


    end



function scanAlgorithm:sortGuilds()
        -- Sort Friend Guild 

        local sortedFriendly = {}
        for k, v in pairs(self.friendGuild) do
            table.insert(sortedFriendly, {key = k, value = v})
        end

        table.sort(sortedFriendly, function(a, b)
            return a.value > b.value
        end)

        self.friendGuild = sortedFriendly
        

        -- Sort Hostile Guild 
        local sortedHostile = {}
        for k, v in pairs(self.hostileGuild) do
            table.insert(sortedHostile, {key = k, value = v})
        end

        table.sort(sortedHostile, function(a, b)
            return a.value > b.value
        end)

        self.hostileGuild = sortedHostile
       
end



return scanAlgorithm