local core = nil
while lib.hasLoaded() ~= true do
    Wait(1000)
end
CreateThread(function()
    while not core do
        core = exports['qb-core']:GetCoreObject()
        cache:set('items', core.Shared.Items)
        cache:set('jobs', core.Shared.Jobs)
        cache:set('items', core.Shared.Items)
        cache:set('jobs', core.Shared.Jobs)
        cache:set('gangs', core.Shared.Gangs)
        cache:set('weapons', core.Shared.Weapons)
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

    lib.addStateHandler('isLoggedIn', function(ent, netId, value, bagName)
        cache:set('isLoggedIn', value)
    end)

    lib.addStateHandler('PlayerData', function()
        cache:set('playerData', core.PlayerData)
    end)
end)