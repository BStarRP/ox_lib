lib.resource = {
	registerEvent = {
		onStart = function(resource, cb)
			AddEventHandler('onResourceStart', function(_resource)
				if resource ~= _resource then return end
				cb()
			end)
		end,
		onStop = function(resource, cb)
			AddEventHandler('onResourceStop', function(_resource)
				if resource ~= _resource then return end
				cb()
			end)
		end,
		onRefresh = function(resource, cb)
			AddEventHandler('onResourceRefresh', function(_resource)
				if resource ~= _resource then return end
				cb()
			end)
		end,
	},
    start = function(resource)
        StartResource(resource)
    end,
    stop = function(resource)
        StopResource(resource)
    end,
    restart = function(resource)
        StopResource(resource)
        StartResource(resource)
    end,
    refresh = function(resource)
        RefreshResources(resource)
    end,
	save = function(name, data, length)
		SaveResourceFile(name, data, length)
	end,
	load = function(name)
		return LoadResourceFile(name)
	end,
}


return lib.resource