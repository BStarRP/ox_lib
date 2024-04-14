---@class CPed
---@field model number
---@field coords vector4
---@field static? boolean
---@field distance? number
---@field onCreated function

local DoesEntityExist = DoesEntityExist
local GetEntityCoords = GetEntityCoords
local peds = {}
local tagDistance = 10.0
local interval = nil

AddEventHandler('onResourceStop', function(res)
    if cache.resource ~= res then return end

    for i=1, #peds do
        if peds[i].nametag then RemoveMpGamerTag(Entity(peds[i].nametag).state?.nametag) end
        if DoesEntityExist(peds[i].entity) then DeleteEntity(peds[i].entity) end
    end
end)

CreateThread(function()
    SetMpGamerTagsVisibleDistance(tagDistance)
end)

local function removePed(self)
	if self.onDeleted then
		self.onDeleted(self.entity)
	end
		
    if self.nametag then RemoveMpGamerTag(Entity(self.nametag).state?.nametag) end
	if DoesEntityExist(self.entity) then DeleteEntity(self.entity) end
    
	peds[self.id] = nil
end

local function createPed(props)
    lib.requestModel(props.model)

    local ped = CreatePed(0, props.model, props.coords.x, props.coords.y, props.coords.z, props.coords.w, props.networked or false, true)

    if props.static then
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityCoords(ped, props.coords.x, props.coords.y, props.coords.z - 1.0)
    end

    if props.nametag then
        local tag = CreateFakeMpGamerTag(ped, props.nametag, false, false, '', 0)

        SetMpGamerTagColour(tag, 0, 48)
        SetMpGamerTagAlpha(tag, 0, 155)
        Entity(ped).state.nametag = tag
    end

    if props.onCreated then
        props.onCreated(ped)
    end

    return ped
end

local function updatePed(self, key, value)

    if self.nametag then RemoveMpGamerTag(Entity(self.nametag).state?.nametag) end

    local currentPed = self.entity
    if DoesEntityExist( currentPed ) then DeleteEntity(currentPed) end

    peds[self.id][key] = value

    if currentPed and currentPed ~= 0 then
        peds[self.id].entity = createPed(peds[self.id])
    end

end

CreateThread(function()
    while true do
        for _, ped in pairs(peds) do
            if ped.distance then
                local coords = GetEntityCoords(cache.ped)
                if #(coords - ped.coords.xyz) < ped.distance then
                    if ped.entity == 0 or not DoesEntityExist(ped.entity) then
                        ped.entity = createPed(ped)
                    end
                elseif ped.entity ~= 0 and DoesEntityExist(ped.entity) then
                    if ped.onDeleted then
                        ped.onDeleted(ped.entity)
                    end
                    DeleteEntity(ped.entity)
                    ped.entity = 0
                end
            end
        end

        Wait(2000)
    end
end)

lib.ped = {
	create = function(props)
		local _type = type(props)
		local id = #peds + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

		self.id = id
		self.entity = props.distance and 0 or createPed(props)
		self.remove = removePed
		self.updatePed = updatePed

        TriggerEvent('pedCreated', props)

		peds[id] = self

		return self
	end,
    get = function (props)
        return peds[ props.id ].entity
    end
}

return lib.ped


