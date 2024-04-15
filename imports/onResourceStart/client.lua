lib.onResourceStart = function(resource, cb)
	AddEventHandler('onResourceStart', function(_resource)
		if resource ~= _resource then return end
		cb()
	end)
end


return lib.onResourceStart