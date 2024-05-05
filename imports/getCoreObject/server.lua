---@param safe boolean Get the core object safely
---@return boolean? safe
lib.getCoreObject = function(safe, update)
    if safe then
        local core = nil
        while core == nil do
            Wait(0)
            TriggerEvent('QBCore:GetObject', function(obj) core = obj end)
        end
        return core
    else
        return exports['qb-core']:GetCoreObject()
    end
end
return lib.getCoreObject