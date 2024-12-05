local QBCore = exports['qb-core']:GetCoreObject()
local closestLocations = {}
local cooldown = {}
local isLooping = false
local clock = 0
local busy = false

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        clock = clock + 1
        Wait(1000)
    end
end)

local function canUse(k, location)
    if not config.locations[k].cooldown.enabled then return true end
    local cooldownTime = config.locations[k].cooldown.time
    for index, _ in pairs(closestLocations) do
        for index2, _ in pairs(cooldown) do
            if closestLocations[index].location == location and cooldown[index2].location == location then
                if clock > cooldown[index2].time + cooldownTime then
                    return true
                else
                    return false
                end
                break
            end
        end
    end
    return true
end

local function addCooldown(k, location)
    if not config.locations[k].cooldown.enabled then return end
    for index, _ in pairs(cooldown) do
        if cooldown[index].location == location then table.remove(cooldown, k) end
    end
    table.insert(cooldown, { index = k, time = clock, location = location })
end

local function addToClosestLocations(index, coords, location)
    -- for index, _ in pairs(closestLocations) do
    --     if closestLocations[index].index == k then return end
    -- end
    table.insert(closestLocations, {index = index, coords = coords, location = location})
end

local function removeFromClosestLocation(k)
    
    for index, _ in pairs(closestLocations) do
        if closestLocations[index].location == k then
            table.remove(closestLocations, index)
            if not closestLocations[1] then isLooping = false end
        end
    end
end

if not config.useTarget then
    CreateThread(function()
        for k, _ in pairs(config.locations) do
            for v, coords in pairs(config.locations[k].coords) do
                local coords = vector3(config.locations[k].coords[v].x, config.locations[k].coords[v].y, config.locations[k].coords[v].z)
                local PolyZone = CircleZone:Create(coords, 3, {
                    name = "location-"..k,
                    useZ = true,
                    debugPoly = false
                })
                PolyZone:onPlayerInOut(function(isPointInside)
                    if isPointInside then
                        addToClosestLocations(k, coords, v)
                        loop()
                    else
                        removeFromClosestLocation(v)
                    end
                end)
            end
        end
    end)
end

if not config.useTarget then
    function loop()
        if isLooping then return end
        isLooping = true
        CreateThread(function()
            while isLooping do   
                for k, v in pairs(closestLocations) do
                    DrawText3D(closestLocations[k].coords.x, closestLocations[k].coords.y, closestLocations[k].coords.z, config.locations[closestLocations[k].index].text)
                    if IsControlJustPressed(0, config.key) then
                        if canUse(closestLocations[k].index, closestLocations[k].location) then
                            if not busy then
                                busy = true
                                PickMinigame(closestLocations[k].index, closestLocations[k].location)
                            end
                        else
                            QBCore.Functions.Notify(config.locations[closestLocations[k].index].cooldown.notify, "error")
                        end
                    end
                end
                Wait(3)
            end
        end)
    end
else
    for k, _ in pairs(config.locations) do
        for i, _ in pairs(config.locations[k].coords) do

            exports['qb-target']:AddCircleZone('cr-picking_' .. k .. i, vector3(config.locations[k].coords[i].x, config.locations[k].coords[i].y, config.locations[k].coords[i].z), 0.5,{
                name = 'cr-picking_' .. k .. i, debugPoly = config.debug, useZ=true}, {
                options = {{label = config.locations[k].text,icon = 'fa-solid fa-hand-rock-o', action = function() PickMinigame(k) end}},
                distance = 2.0
            })
        end
    end
end


local function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(1)
	end
end

function PrepareAnim(k)
    local ped = PlayerPedId()
    loadAnimDict(config.locations[k].animDict)

    TaskPlayAnim(ped, config.locations[k].animDict , config.locations[k].anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
end

function PickMinigame(k, location)
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)

    local success = exports['qb-minigames']:Skillbar(config.locations[k].skillBar)

    if success then
        PrepareAnim(k)
        pickProcess(k, location)
        QBCore.Functions.Notify(config.locations[k].notifyMinigameSuccess, "success")
    else
        QBCore.Functions.Notify(config.locations[k].notifyMinigameFail, "error")
        busy = false
    end
end

function pickProcess(k, location)
    QBCore.Functions.Progressbar("grind_coke", "Picking..", config.locations[k].progressbar, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        addCooldown(k, location)
        TriggerServerEvent("plock:server:getitem", k)
        ClearPedTasks(PlayerPedId())
        busy = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify(config.locations[k].notifyProgressbar, "error")
        busy = false
    end)
end