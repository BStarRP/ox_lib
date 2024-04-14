---@class CObject
---@field model number
---@field coords vector4
---@field static? boolean
---@field distance? number
---@field onCreated? function
---@field onDeleted? function

local objects = {}

local function removeObject(self)
    if self.onDeleted then
        self.onDeleted(self.entity)
    end
	if DoesEntityExist(self.entity) then DeleteEntity(self.entity) end
	objects[self.id] = nil
end

local function createObject(props)
    lib.requestModel(props.model)

    local object = CreateObject(props.model, props.coords.x or 0, props.coords.y or 0, props.coords.z or 0, props.networked or false, false, false)

	if props.coords.w then
		SetEntityHeading(object, props.coords.w)
	end

    if props.static then
        FreezeEntityPosition(object, true)
    end

    if props.attachment then
        if props.attachment.disableCollision then
            SetEntityCollision(object, false, true)
        end

        AttachEntityToEntity(object, props.attachment.ped or cache.ped, props.attachment.boneIndex or GetPedBoneIndex(props.attachment.ped or props.ped, 24818), props.attachment.offsetX or 0.09, props.attachment.offsetY or -0.16, props.attachment.offsetZ or 0, 0.0, 180.0, 0.0, true, true, false, false, 2, true)
    end

    if props.onCreated then
        props.onCreated(object)
    end

    return object
end

CreateThread(function()
    while true do
        for _, object in pairs(objects) do
            if object.distance then
                local coords = GetEntityCoords(cache.ped)
                if #(coords - object.coords.xyz) < object.distance then
                    if not DoesEntityExist(object.entity) then
                        object.entity = createObject(object)
                    end
                else
                    if DoesEntityExist(object.entity) then
                        if object.onDeleted then
                            object.onDeleted(object.entity)
                        end
                        DeleteEntity(object.entity)
                    end
                end
            end
        end

        Wait(5000)
    end
end)

lib.object = {
	create = function(props)
		local _type = type(props)
		local id = #objects + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

        local obj = props.distance and 0 or createObject(props)
		TriggerEvent('objectCreated', props)

		self.id = id
		self.entity = obj
		self.remove = removeObject

		objects[id] = self

        if props.lifecycle then
            CreateThread(function()
                Wait(props.lifecycle)
                removeObject(self)
            end)
        end

		return self
	end
}

return lib.object
