local filename = 'WeaponRestrictions.lua'
WeaponRestrictions = {}
WeaponRestrictions.checkIntervall = 60
WeaponRestrictions.lastCheck = 10

local function readFile(path)
    local file = io.open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local script = readFile(lfs.writedir()..'Scripts\\WeaponRestrictionsIngame.lua')

local function splitNewLines (str)
    local t = {}
    for word in string.gmatch(str, "(.*)\n?") do
        if word ~= "" then
            word = word:gsub("\n", "")
            table.insert(t, word)
        end
    end
    return t
end

function WeaponRestrictions.OnSimulationFrame()
    local modelTime = DCS.getModelTime()

    if (modelTime - WeaponRestrictions.lastCheck) >= WeaponRestrictions.checkIntervall then
        WeaponRestrictions.lastCheck = modelTime

        local stat = net.dostring_in('server', script)
        local playerNamesToKick = splitNewLines(stat)

        for _, playerNameToKick in pairs(playerNamesToKick) do
            for _, playerID in pairs(net.get_player_list()) do
                local playerName = net.get_player_info(playerID, 'name')
                if playerName == playerNameToKick then
                    log.write(filename, log.INFO, "Force player to spectator: " .. playerName)
                    net.send_chat_to("You use forbidden weapons and have been moved to the spectators", playerID)
                    net.force_player_slot(playerID, 0, '')
                end 
            end
        end
    end
end

log.write(filename, log.INFO, 'Start WeaponRestrictions')