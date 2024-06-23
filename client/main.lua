local QBCore = exports['qb-core']:GetCoreObject()
local closestLocations = {}
local isLooping = false

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

local function addToClosestLocations(k, coords)
    for index, _ in pairs(closestLocations) do
        if closestLocations[index] == k then return end
    end
    table.insert(closestLocations, {index = k, coords = coords})
end

local function removeFromClosestLocation(k, v)
    
    for index, _ in pairs(closestLocations) do
        if closestLocations[index].index == k then
            table.remove(closestLocations, k)
            if not closestLocations[1] then isLooping = false end
            break
        end
    end
end

if not config.useTarget then
    CreateThread(function()
        for k, _ in pairs(config.locations) do
            for v, coords in pairs(config.locations[k].coords) do
                local coords = vector3(config.locations[k].coords[v].x, config.locations[k].coords[v].y, config.locations[k].coords[v].z)
                local PolyZone = CircleZone:Create(coords, 5, {
                    name = "location-"..k,
                    useZ = true,
                    debugPoly = false
                })
                PolyZone:onPlayerInOut(function(isPointInside)
                    if isPointInside then
                        addToClosestLocations(k, coords)
                        loop()
                    else
                        removeFromClosestLocation(k, v)
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
                        PickMinigame(closestLocations[k].index)
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

function PickMinigame(k)
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)
    print(k)

    local success = exports['qb-minigames']:Skillbar(config.locations[k].skillBar)

    if success then
        PrepareAnim(k)
        pickProcess(k)
        QBCore.Functions.Notify(config.locations[k].notifyMinigameSuccess, "success")
    else
        QBCore.Functions.Notify(config.locations[k].notifyMinigameFail, "error")
    end
end

function pickProcess(k)
    QBCore.Functions.Progressbar("grind_coke", "Picking..", config.locations[k].progressbar, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("plock:server:getitem", k)
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify(config.locations[k].notifyProgressbar, "error")
    end)
end