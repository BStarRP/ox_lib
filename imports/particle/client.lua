---@class CParticle
---@field dict string
---@field name string
---@field coords? vector3
---@field scale? number
---@field looped? boolean
---@field duration? number
---@field networked? boolean

local particles = {}

local function removeParticle(self)
    if particles[self.id].looped then
        StopParticleFxLooped(particles[self.id].handle, false) 
    end

	particles[self.id] = nil
end

local function loadParticleDict(dict)
    if HasNamedPtfxAssetLoaded(dict) then return dict end
    RequestNamedPtfxAsset(dict)

    if coroutine.running() then
        timeout = 500

        for _ = 1, timeout do
            if HasNamedPtfxAssetLoaded(dict) then
                return dict
            end

            Wait(0)
        end

        print(("failed to load particle '%s' after %s ticks"):format(dict, timeout))
    end
end

local function createParticle(props)
    loadParticleDict(props.dict)
    UseParticleFxAsset(props.dict)

    local handle

    if props.looped then
        if props.networked and props.entity then
            handle = StartNetworkedParticleFxLoopedOnEntity(props.name, props.entity, props.offset?.x or 0.0, props.offset?.y or 0.0, props.offset?.z or 0.0, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false)
        elseif props.entity then
            handle = StartParticleFxLoopedOnEntity(props.name, props.entity, props.offset?.x or 0.0, props.offset?.y or 0.0, props.offset?.z or 0.0, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false)
        else
    	    handle = StartParticleFxLoopedAtCoord(props.name, props.coords.x, props.coords.y, props.coords.z, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false, false)
        end
    else
        if props.networked and props.coords then
	        handle = StartNetworkedParticleFxNonLoopedAtCoord(props.name, props.coords.x, props.coords.y, props.coords.z, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false)
        elseif props.networked and props.entity then
            handle = StartNetworkedParticleFxNonLoopedOnEntity(props.name, props.entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false)
        else
	        handle = StartParticleFxNonLoopedAtCoord(props.name, props.coords.x, props.coords.y, props.coords.z, 0.0, 0.0, 0.0, props.scale or 0.0, false, false, false)
        end
    end
    
    return handle
end

lib.particle = {
	create = function(props)
		local _type = type(props)
		local id = #particles + 1
		local self = props

		if _type ~= "table" then error(("expected type 'table' for the first argument, received (%s)"):format(_type)) end

        local particle = createParticle(props)
		TriggerEvent('particleCreated', props)

		self.id = id
		self.handle = particle
		self.remove = removeParticle
        
		particles[id] = self

        if props.duration then
            CreateThread(function()
                Wait(props.duration)
                removeParticle(self)
            end)
        end

		return self
	end
}

return lib.particle
