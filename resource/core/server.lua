local QBCore = nil

CreateThread(function()
	while GetResourceState('qb-core') ~= 'started' do
		Wait(100)
	end
	while not QBCore do
		QBCore = exports['qb-core']:GetCoreObject()
		Wait(100)
	end
end)