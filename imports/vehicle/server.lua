local vehicles = {}

AddEventHandler('entityRemoved', function(entity)
    for i, vehicle in pairs(vehicles) do
        if vehicle.entity == entity then
            vehicles[i] = nil
            warn(('A vehicle registered with lib.vehicle (entity:%s) was removed externally.'):format(entity))
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if cache.resource ~= res then return end

    for _, vehicle in pairs(vehicles) do
        if DoesEntityExist(vehicle.entity) then DeleteEntity(vehicles.entity) end
    end
end)

-- God help me what have I done?
local function findVehicleType(model)
    local temp = CreateVehicle(model, 0, 0, 0, 0, true, true)
    local exists = DoesEntityExist(temp)

    for i = 1, 500 do
        if exists then break elseif i == 500 then return end

        exists = DoesEntityExist(temp)
        Wait(0)
    end

    local type = GetVehicleType(temp)
    DeleteEntity(temp)

    return type
end

local function createVehicle(self)
    local type = self.type or findVehicleType(self.model)

    if type == 'bicycle' or type == 'quadbike' or type == 'amphibious_quadbike' then
        type = 'bike'
    elseif type == 'amphibious_automobile' or type == 'submarinecar' then
        type = 'automobile'
    elseif type == 'blimp' then
        type = 'heli'
    end

    local veh = CreateVehicleServerSetter(self.model, type or 'automobile', self.coords.x, self.coords.y, self.coords.z, self.coords.w)
    Wait(0) -- for science

    if DoesEntityExist(veh) then
        Entity(veh).state:set('vehicleSpawned', true, true)
        
        if self.props then
            Entity(veh).state:set('vehicleProperties', self.props, true)
        end

        if self.onCreated then
            self.onCreated(veh)
        end

        return veh
    else
        return error(('Attempted to spawn a %s, but it failed.'):format(self.model))
    end
end

local function removeVehicle(self, cleanup, timeout)
    if cleanup then
        Entity(self.entity).state:set('cleanupEntity', timeout or true, false)
        vehicles[self.id] = nil

        return
    end

    vehicles[self.id] = nil -- remove the reference first so deleting the entity won't trigger the additonal print in entityRemoved

    if DoesEntityExist(self.entity) then
        DeleteEntity(self.entity)
    end
end

lib.vehicle = {
    create = function(data)
        local vehicleId = #vehicles+1
        local self = data

        local veh = createVehicle(data)
        if not veh then return end

        self.id = vehicleId
        self.entity = veh
        self.netid = NetworkGetNetworkIdFromEntity(veh)
        self.remove = removeVehicle
        self.exists = function()
            return DoesEntityExist(veh)
        end

        vehicles[vehicleId] = self
        return self
    end,
    register = function(entity)
        if not DoesEntityExist(entity) then return false end
        
        local vehicleId = #vehicles+1
        local self = {}

        self.id = vehicleId
        self.entity = entity
        self.netid = NetworkGetNetworkIdFromEntity(entity)
        self.remove = removeVehicle

        vehicles[vehicleId] = self
        return self
    end
}

return lib.vehicle