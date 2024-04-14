function lib.addStateHandler(keyfilter, cb, bagfilter)
    return AddStateBagChangeHandler(keyfilter, bagfilter or '', function(bagName, _, value)
        Wait(0) -- wait a frame for the bag update

        local netId = tonumber(bagName:gsub('entity:', ''), 10) or GetEntityFromStateBagName(bagName);
        local count = 0
        local exists = false
        
        repeat
            count += 1
            if count > 10000 then break end
    
            exists = NetworkDoesEntityExistWithNetworkId(netId)
            Wait(0)
        until exists
      
        if not exists then return print(('the statebag handler for %s failed to find an entity in time.'):format(bagName)) end
    
        local ent = NetworkGetEntityFromNetworkId(netId)
        if ent == 0 then return print(('the statebag handler for %s received an invalid entity.'):format(bagName)) end
        cb(ent, netId, value, bagName)
    end)
end

return lib.addStateHandler