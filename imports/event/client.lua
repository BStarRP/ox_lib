
local events = {}
local isServer = IsDuplicityVersion()
local scriptType = isServer and 'server' or 'client'

local function getEvent(name)
    return events[name] or nil
end

local function isEventRegistered(id)
    return events[id] and true or false
end

local function getEventName(resource, action, net)
    local name = ('%s:server:'):format(resource)
    if action then name = name..action end
    return name
end

local function getRoute(net)
    return net and 'NET' or 'LOCAL'
end

local function getTrigger(net)
    return net and (isServer and (net and TriggerServerEvent or TriggerClientEvent) or TriggerEvent)
end

local function getHandler(net)
    return net and (isServer and (net and RegisterServerEvent or RegisterNetEvent) or AddEventHandler)
end

local function eventLog(event, logType, ...)
    if event.debug then
        print(logType..': '..event.name, ...)
    end
end

local function registerEvent(resource, cb, monitor, debug)
    local event = { 
        id = getEventName(resource),
        resources = resource,
        type = scriptType,
        monitor = monitor,
        debug = debug,
        callback = cb,
        listeners = {},
        triggers = {},
        actions = {},
    } 
    event.eventHandler = AddEventHandler(('%s:server:'):format(resource), function(action, ...)
        local key = getEventName(resource)
        local event = events[key]
        if event then
            local listeners = event.listeners or {}
            for action, actions in pairs(listeners) do
                local actionEvent = getEventName(resource, action)
                for i = 1, #actions do
                    local listener = listeners[i]
                    if not listener.net then
                        TriggerEvent(actionEvent, ...)
                    end
                end
                eventLog(event, 'Event Listeners Triggered', action, #listeners)
            end
        end
    end)
    event.netEvent = RegisterNetEvent(('%s:server:'):format(resource), function(action, ...)
        local key = getEventName(resource)
        local event = events[key]
        if event then
            local listeners = event.listeners or {}
            for action, actions in pairs(listeners) do
                local actionEvent = getEventName(resource, action)
                for i = 1, #actions do
                    local listener = listeners[i]
                    if listener.net then
                        TriggerServerEvent(actionEvent, ...)
                    end
                end
                eventLog(event, 'Event Listeners Triggered', action, #listeners)
            end
        end
    end)
    event.addListener = function(action, cb, net, invoker, debug)
        local actionListeners = {}
        if event.listeners[action] then
            actionListeners = event.listeners[action]
        end
        local actionData = { callback = cb, net = net, invoker = invoker, debug = debug }
        actionListeners[#actionListeners+1] = actionData
        events[event.id].listeners[action] = cb
        eventLog(event, 'Listener added', action)
    end
    events[event.id] = event
    eventLog(event, 'Event registered', event.id)
    return event
end

local function addTriggers(event, resource, cb)
    events[event.name].triggers[resource] = true
    return true
end

local function getEvent(name)
    return events[name]
end

local function isEventRegistered(name)
    return events[name] and true or false
end

local function findEvent(resource, action, net)
    for name, event in pairs(events) do
        if (event.resource == resource and event.action == action and event.net == net) then
            return event
        end
    end
end

function lib.event.trigger(resource, action, cb, net)
    if not resource then
        resource = GetInvokingResource()
    end
    local mainEvent = getEventName(resource)
    local event = getEvent(mainEvent)
    local eventName = getEventName(resource, action)
    if event then
        triggerEvent = getTrigger(net)
        triggerEvent(eventName, ...)
        eventLog(event, 'Event Triggered', ...)
    else
        triggerEvent = getTrigger(net)
        triggerEvent(eventName, ...)
        eventLog('unkown', 'Event Triggered', ...)
    end
end

function lib.event.register(resource, cb, debug)
    local resource = resource or GetInvokingResource()
    local event = registerEvent(resource, cb, debug)
end

function lib.event.addListener(resource, action, cb, net, debug)
    local eventId = getEventName(resource)
    local event = getEvent(eventId)
    if not event then event = lib.event.register(resource, cb, debug) end
    event.addListeners(action, cb, net, GetInvokingResource(), debug)
end


return lib.event











