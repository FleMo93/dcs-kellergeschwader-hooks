local playersToKick = ""
local restrictedAmmoTypes = {
    "weapons.bombs.RN-24",
    "weapons.bombs.RN-28"
}

local function isAmmoRestricted(ammoName)
    for _, name in pairs(restrictedAmmoTypes) do
        if name == ammoName then
            return true
        end
    end
    return false
end

for _, playerUnit in pairs(coalition.getPlayers(coalition.side.BLUE)) do

    for _, ammo in pairs(playerUnit:getAmmo()) do
        if ammo and ammo.count > 0 and isAmmoRestricted(ammo.desc.typeName) == true then
            if playersToKick == "" then
                playersToKick = playerUnit:getPlayerName() .. "\n"
            else
                playersToKick = playersToKick .. playerUnit:getPlayerName() .. "\n"
            end
        end
    end
end

return playersToKick