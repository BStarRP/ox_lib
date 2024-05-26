---Request control of network entity. When called from a thread, it will yield until it has loaded.
---@param entity string
---@param timeout number? Approximate milliseconds to wait for the dictionary to load. Default is 10000.
---@return string animDict
function lib.requestControl(entity, timeout)
    if NetworkHasControlOfEntity(entity) then return true end
    local timeout = timeout or 10000
    while not NetworkHasControlOfEntity(entity) do
        NetworkRequestControlOfEntity(entity)
        Wait(10)
        if timeout <= 0 then return false end
        timeout = timeout - 10
    end

    return true
end

return lib.requestControl
