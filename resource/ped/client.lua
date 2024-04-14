AddStateBagChangeHandler('initPed', '', function(bagName, _, props)
    if not props then return end

    local ent = GetEntityFromStateBagName(bagName)
    if ent == 0 then
        return print(('failed to set properties of spawned ped on %s'):format(bagName))
    end

    lib.requestModel(props.model)
    if NetworkGetEntityOwner(ent) ~= cache.playerId then return end

    if props.static then
        SetEntityInvincible(ent, true)
        SetBlockingOfNonTemporaryEvents(ent, true)
    end

    if props.nametag then
        local tag = CreateFakeMpGamerTag(ent, props.nametag, false, false, '', 0)

        SetMpGamerTagColour(tag, 0, 48)
        SetMpGamerTagAlpha(tag, 0, 155)
        Entity(ent).state.nametag = tag
    end

    Entity(ent).state:set('initPed', nil, true)
end)