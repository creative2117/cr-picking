local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("plock:server:getitem", function(k)
    src = source
    Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem(config.locations[k].item, config.locations[k].amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[config.locations[k].item], "add")
    else
        TriggerClientEvent('QBCore:Notify', src, "Can't give item!")
    end
end)