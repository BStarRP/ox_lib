QBCore = nil
CreateThread(function()
	while QBCore == nil do
		Wait(0)
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
	end
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	PlayerData = LocalPlayer.state.PlayerData
	if not PlayerData then PlayerData = QBCore.Functions.GetPlayerData() end
	if PlayerData then
		cache:set('playerData', PlayerData)
		cache:set('playerJob', PlayerData.job)
		cache:set('playerGang', PlayerData.gang)
	end
	cache:set('playerLoaded', true)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	PlayerData = nil
	cache:set('playerData', {})
	cache:set('playerJob', {})
	cache:set('playerGang', {})
	cache:set('playerLoaded', false)
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
	PlayerData = val
	if not PlayerData and cache.playerLoaded then PlayerData = QBCore.Functions.GetPlayerData() end
	cache:set('playerData', PlayerData)
	cache:set('playerJob', PlayerData.job)
	cache:set('playerGang', PlayerData.gang)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	if not PlayerData then PlayerData = QBCore.Functions.GetPlayerData() end
	PlayerData.job = JobInfo
	cache:set('playerData', PlayerData)
	cache:set('playerJob', JobInfo)
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
	if not PlayerData then PlayerData = QBCore.Functions.GetPlayerData() end
	PlayerData.gang = GangInfo
	cache:set('playerData', PlayerData)
	cache:set('playerJob', GangInfo)
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
	if not PlayerData then PlayerData = QBCore.Functions.GetPlayerData() end
	if PlayerData then 
		PlayerData.job.onduty = duty
		cache:set('playerData', PlayerData)
		cache:set('playerJob', PlayerData.job)
		cache:set('playerGang', PlayerData.gang)
	else
		cache:set('playerData', {})
		cache:set('playerJob', {})
		cache:set('playerGang', {})
	end
end)

--CUSTOM CORE
CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(100)
	end
	while not cache.playerId do
		Wait(100)
	end
	local serverId = GetPlayerServerId(cache.playerId)
	local PlayerData = nil
	cache:set('serverId', serverId)
	cache:set('isServer', IsDuplicityVersion())
	cache:set('isClient', not cache.isServer)
	cache:set('playerLoaded', false)
	cache:set('playerData', {})
	cache:set('playerJob', {})
	cache:set('playerGang', {})
end)