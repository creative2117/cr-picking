local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local picking = false
local skillbarDuration = nil
local skillbarPos = nil
local skillbarWidth = nil
local QBCore = exports['qb-core']:GetCoreObject()

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local inRange = false

        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        
        
        for k, v in pairs(config.locations) do
            for _, v in pairs(config.locations[k].coords) do
                local coords = vector3(config.locations[k].coords[_].x, config.locations[k].coords[_].y, config.locations[k].coords[_].z)
                local dist = #(PlayerPos - coords)
                if dist < 15 then
                    inRange = true
                    
                    if dist < 5 then
                        DrawText3D(coords.x, coords.y, coords.z, config.locations[k].text)
                        if IsControlJustPressed(0, config.key) then
                            PickMinigame(k)
                        end
                    end
                end
            end
            
        end 

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

function PrepareAnim(k)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, config.locations[k].anim, 0, true)
end

function PickMinigame(k)
    dufficulty(k)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    
    local maxwidth = 30
    local maxduration = 3500

    Skillbar.Start({
        duration = skillbarDuration,
        pos = skillbarPos,
        width = skillbarWidth,
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then
            PrepareAnim(k)
            pickProcess(k)
            QBCore.Functions.Notify(config.locations[k].notifyMinigameSuccess, "success")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            dufficulty(k)
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = skillbarDuration,
                pos = skillbarPos,
                width = skillbarWidth,
            })
        end
                
        
	end, function()

            QBCore.Functions.Notify(config.locations[k].notifyMinigameFail, "error")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            picking = false
       
    end)
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
        picking = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify(config.locations[k].notifyProgressbar, "error")
    end)
end

function dufficulty(k)
    if config.locations[k].skillBar == "hard" then
        skillbarDuration = math.random(600, 1000)
        skillbarPos = math.random(5, 50)
        skillbarWidth = math.random(7, 15)
        NeededAttempts = math.random(5, 10)
    elseif config.locations[k].skillBar == "medium" then
        skillbarDuration = math.random(1000, 1500)
        skillbarPos = math.random(10, 40)
        skillbarWidth = math.random(10, 20)
        NeededAttempts = math.random(5, 7)
    elseif config.locations[k].skillBar == "easy" then
        skillbarDuration = math.random(1500, 2000)
        skillbarPos = math.random(15, 30)
        skillbarWidth = math.random(15, 30)
        NeededAttempts = math.random(3, 5)
    end
end