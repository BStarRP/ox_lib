local core = nil
local isServer = IsDuplicityVersion()
local isClient = not isServer
while lib.hasLoaded() ~= true do
    Wait(1000)
end
CreateThread(function()
    while not core do
        core = exports['qb-core']:GetCoreObject()
        Wait(100)
    end

    cache:set('core', core)
    cache:set('coreFunctions', core.Functions)
    cache:set('shared', core.Shared)
    cache:set('sharedItems', core.Shared.Items)
    cache:set('sharedJobs', core.Shared.Jobs)
    cache:set('sharedItems', core.Shared.Items)
    cache:set('sharedGangs', core.Shared.Gangs)
    cache:set('sharedWeapons', core.Shared.Weapons)

    while core do
        Wait(30000)
        if isClient then
            if cache.sharedItems ~= core.Shared.Items then
                cache:set('sharedItems', core.Shared.Items)
            end
            if cache.sharedJobs ~= core.Shared.Jobs then
                cache:set('sharedJobs', core.Shared.Jobs)
            end
            if cache.sharedGangs ~= core.Shared.Gangs then
                cache:set('sharedGangs', core.Shared.Gangs)
            end
            if cache.sharedWeapons ~= core.Shared.Weapons then
                cache:set('sharedWeapons', core.Shared.Weapons)
            end
            if cache.coreFunctions ~= core.Functions then
                cache:set('coreFunctions', core.Functions)
            end
        end

        if isServer then
            cache:set('players', core.Functions.GetQBPlayers())
        end
    end
end)


CreateThread(function()
    --client handlers
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
    --server handlers
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
    else
        RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
            cache:set('playerData', val)
        end)
    end
end)
