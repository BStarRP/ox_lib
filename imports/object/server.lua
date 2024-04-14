---@class CObject
---@field model number
---@field coords vector4
---@field static? boolean
---@field onCreated function

local objects = {}

local function removeObject(self)
	if DoesEntityExist(self.entity) then DeleteEntity(self.entity) end
    
	objects[self.id] = nil
end

local function createObject(props)
    local object = CreateObjectNoOffset(props.model, props.coords.x, props.coords.y, props.coords.z, true, false, true)

	if props.coords.w then
		SetEntityHeading(object, props.coords.w)	
	end

    if props.static then
        FreezeEntityPosition(object, true)
    end

    return object
end

lib.object = {
	create = function(props)
		local _type = type(props)
		local id = #objects + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

        local ped = createObject(props)

		self.id = id
		self.entity = ped
		self.remove = removeObject
        
        if self.onCreated then
            self.onCreated(self.entity)
        end

		objects[id] = self
		return self
	end
}

return lib.object
