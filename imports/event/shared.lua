lib.event = {}

---@param eventName string The name of event.
---@param eventResource? string Resource name of event.
---@param isLocal? boolean Whether or not its a network event or local event.
---@return number? playerId
---@return number? playerPed
---@return vector3? playerCoords
function lib.event.trigger(eventName, eventResource, isLocal, ...)
    local eventResource = eventResource or cache.resource or GetCurrentResourceName()
    local eventType = IsDuplicityVersion() and 'server' or 'client'
    local eventFullName = ('%s:%s:%s'):format(eventResource, eventType, eventName)
    if eventName == nil then return lib.print('Missing event name!') end
    if isLocal then 
        TriggerEvent(eventFullName, ...)
    end

    if isLocal == 'both' or not isLocal then
        if eventType == 'client' then
            TriggerClientEvent(eventFullName, ...)
        else
            TriggerServerEvent(eventFullName, ...)
        end
    end

    --Core.OnEventTriggered({eventName = eventFullName, resource = eventResource, eventType = eventType, args = {...}})
end

function lib.event.register(cb, eventName, eventResource, isLocal)
    local eventCallback = cb
    local eventResource = eventResource or cache.resource or GetCurrentResourceName()
    local eventType = IsDuplicityVersion() and 'server' or 'client'
    local eventFullName = ('%s:%s:%s'):format(eventResource, eventType, eventName)
    if eventName == nil then return lib.print('Missing event name!') end
    if isLocal then 
        AddEventHandler(eventFullName, eventCallback)
    end

    if isLocal == 'both' or not isLocal then
        RegisterNetEvent(eventFullName, eventCallback)
    end

    --Core.OnEventRegistered(eventFullName, eventResource, eventType, eventCallback)
end

return lib.event