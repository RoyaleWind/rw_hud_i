ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('rw_hud:getServerInfo')
AddEventHandler('rw_hud:getServerInfo', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)


	local time = '22:00'
	local date = '00/00/2022'



		time = os.date("%H:%M", os.time() + 1 * 60 * 60 )
		date = os.date("%d/%m/%Y",os.time() + 1 * 60 * 60 ) 

		Citizen.Wait(100)

		local info = {
			money = xPlayer.getMoney(),
			bank = xPlayer.getAccount('bank').money,
			blackm = xPlayer.getAccount('black_money').money, 
			dnates = xPlayer.getAccount('donate_coins').money, 
			time = time,
			date = date
		}
	

		TriggerClientEvent('rw_hud:setInfo', source, info) 
 	
end)
