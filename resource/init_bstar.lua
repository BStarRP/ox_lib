local core = nil
local isServer = IsDuplicityVersion()
local isClient = not isServer
while lib.hasLoaded() ~= true do
    Wait(1000)
end
CreateThread(function()
    while not core do
        core = exports['qb-core']:GetCoreObject()
        cache:set('core', core)
        cache:set('items', core.Shared.Items)
        cache:set('jobs', core.Shared.Jobs)
        cache:set('items', core.Shared.Items)
        cache:set('jobs', core.Shared.Jobs)
        cache:set('gangs', core.Shared.Gangs)
        cache:set('weapons', core.Shared.Weapons)
        cache:set('players', core.Functions.GetQBPlayers())
        Wait(100)
    end

    while core do
        Wait(30000)
        if cache.core.Shared.Items ~= core.Shared.Items then
            cache:set('items', core.Shared.Items)
        end
        if cache.core.Shared.Jobs ~= core.Shared.Jobs then
            cache:set('jobs', core.Shared.Jobs)
        end
        if cache.core.Shared.Gangs ~= core.Shared.Gangs then
            cache:set('gangs', core.Shared.Gangs)
        end
        if cache.core.Shared.Weapons ~= core.Shared.Weapons then
            cache:set('weapons', core.Shared.Weapons)
        end
        if cache.core.Functions ~= core.Functions then
            cache:set('functions', core.Functions)
        end
    end

    if isClient then
        lib.addStateHandler('isLoggedIn', function(ent, netId, value, bagName)
            cache:set('isLoggedIn', value)
        end)

        lib.addStateHandler('PlayerData', function(ent, netId, value, bagName)
            if LocalPlayer.state.isLoggedIn then
                cache:set('playerData', core.PlayerData)
                cache:set('playerJob', core.PlayerData.job)
                cache:set('playerGang', core.PlayerData.gang)
                cache:set('playerItems', core.PlayerData.items)
            else
                cache:set('playerData', nil)
                cache:set('playerJob', nil)
                cache:set('playerGang', nil)
                cache:set('playerItems', nil)
            end
        end)
    end
end)

if isServer then
    RegisterNetEvent('QBCore:client:PlayerLoaded', function()
        cache:set('players', core.Functions.GetQBPlayers())
    end)
    
    RegisterNetEvent('playerDropped', function()
        cache:set('players', core.Functions.GetQBPlayers())
    end)

    AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerSrc)
        cache:set('players', core.Functions.GetQBPlayers())
    end)
end
