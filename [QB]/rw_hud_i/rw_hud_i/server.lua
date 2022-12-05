

local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('rw_hud:getServerInfo')

AddEventHandler('rw_hud:getServerInfo', function()

	local source = source
	local Player = QBCore.Functions.GetPlayer(source)
	local time = '22:00'
	local date = '00/00/2022'


		time = os.date("%H:%M", os.time() + 0 * 60 * 60 )
		date = os.date("%d/%m/%Y",os.time() + 0 * 60 * 60 ) 

		Citizen.Wait(100)

		local info = {
			money = Player.PlayerData.money.cash,
			bank = Player.PlayerData.money.bank,
--[[ 			blackm = Player.PlayerData.money.crypto,  ]]
			dnates = Player.PlayerData.money.donate, 
			time = time,
			date = date
		}
	

		TriggerClientEvent('rw_hud:setInfo', source, info) 
 	
end)
