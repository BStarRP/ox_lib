---@class CBlip
---@field entity? number
---@field coords? vector3
---@field name? string
---@field radius? number
---@field sprite? number
---@field scale? number
---@field color? number
---@field category? number
---@field distance? number
---@field group? string

local blips = {}
local hidden = json.decode(GetExternalKvpString('erp-radialmenu', 'hiddenBlips') or '{}') -- erp-radialmenu handles blip toggles and stores the kvp value 

local function removeBlip(self)
	if DoesBlipExist(self.blipId) then RemoveBlip(self.blipId) end

	blips[self.id] = nil
end

local function refreshBlipGroup(group)
	hidden = json.decode(GetExternalKvpString('erp-radialmenu', 'hiddenBlips') or '{}')

	for i=1, #blips do
		if blips[i].group and blips[i].group == group then
			if DoesBlipExist(blips[i].blipId) then
				SetBlipDisplay(blips[i].blipId, hidden[group] and 0 or 2)
			end
		end
	end
end

AddEventHandler('refreshBlipGroup', function(group)
	refreshBlipGroup(group)
end)

CreateThread(function()
	while true do
		for _, blip in pairs(blips) do
			if blip.distance and blip.coords then
				if #(cache.coords - blip.coords) < blip.distance then
					if not DoesBlipExist(blip.blipId) then
						local props = blip
						blip.blipId = AddBlipForCoord(props.coords.x, props.coords.y, props.coords.z)

						if props.sprite then
							SetBlipSprite(blip, props.sprite)
						end

						SetBlipScale(blip, props.scale or 0.6)
						SetBlipColour(blip, props.color or 0)
						SetBlipDisplay(blip, hidden[blip.group] and 0 or 2)
						SetBlipAsShortRange(blip, true)

						if props.name then
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(props.name)
							EndTextCommandSetBlipName(blip)
						end

						TriggerEvent('blipCreated', blip)
					end
				else
					if DoesBlipExist(blip.blipId) then
						RemoveBlip(blip.blipId)
					end
				end
			end
		end

		Wait(6000)
	end
end)

lib.blip = {
	entity = function(props)
		local _type = type(props)
		local id = #blips + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end
		if not DoesEntityExist(props.entity) then error("attempted to create a blip for an unknown entity") end

		local blip = AddBlipForEntity(props.entity)

		if props.sprite then
			SetBlipSprite(blip, props.sprite)
		end

		SetBlipScale(blip, props.scale or 0.6)
		SetBlipColour(blip, props.color or 0)
		SetBlipDisplay(blip, hidden[props.group] and 0 or 2)
		SetBlipAsShortRange(blip, true)

		if props.name then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(props.name)
			EndTextCommandSetBlipName(blip)
		end

		TriggerEvent('blipCreated', props)

		self.id = blip
		self.remove = removeBlip

		blips[id] = self
		return self
	end,
	coords = function(props)
		local _type = type(props)
		local id = #blips + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

		local blip = AddBlipForCoord(props.coords.x + 0.0, props.coords.y + 0.0, props.coords.z + 0.0)

		if props.sprite then
			SetBlipSprite(blip, props.sprite or 1)
		end

		SetBlipScale(blip, props.scale or 0.6)
		SetBlipColour(blip, props.color or 0)
		SetBlipDisplay(blip, hidden[props.group] and 0 or 2)
		SetBlipAsShortRange(blip, true)

		if props.name then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(props.name)
			EndTextCommandSetBlipName(blip)
		end

		if props.distance then
			self.distance = props.distance
		end
		
		TriggerEvent('blipCreated', props)

		self.id = id
		self.blipId = blip
		self.remove = removeBlip

		blips[id] = self
		return self
	end,
	radius = function(props)
		local _type = type(props)
		local id = #blips + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

		local blip = AddBlipForRadius(props.coords.x + 0.0, props.coords.y + 0.0, props.coords.z + 0.0, props.radius)

		SetBlipColour(blip, props.color or 0)
		SetBlipAlpha(blip, props.alpha or 250)

		TriggerEvent('blipCreated', props)

		self.id = id
		self.blipId = blip
		self.remove = removeBlip

		blips[id] = self
		return self
	end,
}

return lib.blip
