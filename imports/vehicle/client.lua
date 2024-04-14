-- To be yeeted in the future. Only provided as a compatibility
function MathRound(value, decimalPoints)
	if decimalPoints then return math.floor((value * 10^decimalPoints) + 0.5) / (10^decimalPoints) end
	return math.floor(value + 0.5)
end

function Round(value, decimalPoints)
	return MathRound(value, decimalPoints)
end

function MathTrim(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

function createVehicle(params)
    if not params or not params.model then return end;
    if not IsModelInCdimage(params.model) or not IsModelAVehicle(params.model) then return end;

    RequestModel(params.model)
    while not HasModelLoaded(params.model) do
        Wait(0)
    end

    if type(params.position) == 'vector3' then
        local heading = GetEntityHeading(PlayerPedId()) or 90.0
        params.position = vector4(params.position.x, params.position.y, params.position.z, heading)
    end

    local networked = params.networked == nil and true or params.networked
    local vehicle = CreateVehicle(params.model, params.position.x, params.position.y, params.position.z, params.position.w, networked, false)

    -- if networked then
    --     NetworkSetEntityInvisibleToNetwork(vehicle, false)

    --     while not NetworkGetEntityIsNetworked(vehicle) do
    --         NetworkRegisterEntityAsNetworked(vehicle)
    --         Wait(100)
    --     end

    --     NetworkUseHighPrecisionBlending(NetworkGetNetworkIdFromEntity(vehicle), true)
    -- end

    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(params.model)
    
    return vehicle
end

lib.vehicle = {
    create = function(params)
        return createVehicle(params)
    end
}

return lib.vehicle