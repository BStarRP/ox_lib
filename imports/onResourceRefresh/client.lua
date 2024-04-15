lib.onResourceRefresh = function(resource, cb)
	AddEventHandler('onResourceRefresh', function(_resource)
		if resource ~= _resource then return end
		cb()
	end)
end

return lib.onResourceRefresh