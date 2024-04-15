lib.onResourceStop = function(resource, cb)
	AddEventHandler('onResourceStop', function(_resource)
		if resource ~= _resource then return end
		cb()
	end)
end


return lib.onResourceStop