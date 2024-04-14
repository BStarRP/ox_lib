---@class CPed
---@field model number
---@field coords vector4
---@field static? boolean
---@field onCreated function

local DoesEntityExist = DoesEntityExist
local peds = {}

AddEventHandler('entityRemoved', function(entity)
    for i, ped in pairs(peds) do
        if ped.entity == entity then peds[i] = nil end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if cache.resource ~= res then return end

    for _, ped in pairs(peds) do
        if DoesEntityExist(ped.entity) then DeleteEntity(ped.entity) end
    end
end)

local function removePed(self, cleanup)
    if cleanup then
        Entity(self.entity).state:set('cleanupEntity', true, false)
	    peds[self.id] = nil

        return
    end

	if self.onDeleted then
		self.onDeleted(self.entity)
	end
		
	if DoesEntityExist(self.entity) then DeleteEntity(self.entity) end
    
	peds[self.id] = nil
end

local function createPed(props)
    local ped = CreatePed(0, props.model, props.coords.x, props.coords.y, props.coords.z - 1, props.coords.w, true, true)

    if props.static then
        FreezeEntityPosition(ped, true)
    end

    if props.onCreated then
        props.onCreated(ped)
    end

    Entity(ped).state:set('initPed', props, true)

    return ped
end

lib.ped = {
	create = function(props)
		local _type = type(props)
		local id = #peds + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

        local ped = createPed(props)
		TriggerEvent('pedCreated', props)

		self.id = id
		self.entity = ped
		self.netid = NetworkGetNetworkIdFromEntity(ped)
		self.remove = removePed
		self.exists = function()
            return DoesEntityExist(ped)
        end

		peds[id] = self
		return self
	end,
    get = function (props)
        return peds[ props.id ].entity
    end
}

return lib.ped


