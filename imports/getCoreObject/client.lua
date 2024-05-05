---@param safe boolean Get the core object safely
---@return boolean? safe
lib.getCoreObject = function(safe)
    local core = safe and QBCore or exports['qb-core']:GetCoreObject()
    while core == nil do
        Wait(0)
        TriggerEvent('QBCore:GetObject', function(obj) core = obj end)
    end
    return core
end
return lib.getCoreObject