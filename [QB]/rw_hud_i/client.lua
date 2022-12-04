

local lastValues = {}
local PlayerData = {}
local isPauseMenu = false

local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = QBCore.Functions.GetPlayerData()

Citizen.CreateThread(function()

    while true do

        Wait(700)

		PlayerData = QBCore.Functions.GetPlayerData()
		

        TriggerServerEvent('rw_hud:getServerInfo')	

        local hunger = PlayerData.metadata['hunger']
        local thirst = PlayerData.metadata['thirst']   


        
        local status = {
            hunger		= hunger,
            thirst		= thirst
        }
        SendNUIMessage({action = 'update', type = 'status', data = {status = status}})

		SendNUIMessage({action = 'update', type = 'serverId', data = GetPlayerServerId(PlayerId())})

---------------------------POSTAL-------------------------------------------------------------------------------------------------
        ped = PlayerPedId()
        id = GetPlayerServerId(PlayerId())
        position = GetEntityCoords(ped)
        streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
		local postal =  streetName
		SendNUIMessage({action = 'update', type = 'postal-id', data = postal})
		SendNUIMessage({action = 'update', type = 'player-count', data = GetNumberOfPlayers()})
--------------------GLOBAL------------------------------------------------------------------------------------------------------
		local ped = PlayerPedId()
		local playerId = PlayerId()
--------------------------------------------AMMO-------------------------------------------------------------------------------
		local player = GetPlayerPed(-1)
		 if IsPedArmed(player, 7) then
		  SendNUIMessage({action = 'showElement', type = 'bottom-left-weapon'})
		  local weapon = GetSelectedPedWeapon(player)
		  local ammoTotal = GetAmmoInPedWeapon(player,weapon)
		  local bool,ammoClip = GetAmmoInClip(player,weapon)
		  local ammoRemaining = math.floor(ammoTotal - ammoClip)
		--   local wpnData = ESX.GetWeaponFromHash(weapon)
		  SendNUIMessage({action = 'setWeaponImg',data = weapon})
		  SendNUIMessage({action = 'update', type = 'weapon-info', data = ammoClip.."/ "..ammoRemaining})				  
	    else
		  SendNUIMessage({action = 'hideElement', type = 'bottom-left-weapon'})
		end
------------------------HEALTH-------------------------------------------------------------------------------------------------				
		SetPlayerHealthRechargeMultiplier(playerId,0.0)
		local maxHealth = 250 --GetEntityMaxHealth(ped)-100
		local health = GetEntityHealth(ped)-100
		if health < 0 then health = 0 end
		if lastValues.health ~= health then
			lastValues.health = health
			SendNUIMessage({action = 'updateBar', type = 'health', current = health, max = maxHealth})
			SendNUIMessage({action = 'update', type = 'healthbar-value', data = health})
		end
---------------------ARMOR-----------------------------------------------------------------------------------------------------
        SetPlayerHealthRechargeMultiplier(playerId,0.0)
        local maxArmor = 250 --GetPlayerMaxArmour(playerId)
        local armor = GetPedArmour(ped)
        if armor < 0 then armor = 0 end
        if lastValues.armor ~= armor then
	      lastValues.armor = armor
	      SendNUIMessage({action = 'updateBar', type = 'vest', current = armor, max = maxArmor})
	      SendNUIMessage({action = 'update', type = 'vestbar-value', data = armor})
        end

---------------------STAMINA---------------------------------------------------------------------------------------------------				
		local stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
		if lastValues.stamina ~= stamina then
			lastValues.stamina = stamina
			SendNUIMessage({action = 'updateBar', type = 'stamina', current = stamina, max = 100})
		end
----------------------PAUSE-MENU-------------------------------------
		if IsPauseMenuActive() then 
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = 'hide'})
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = 'show'})
			end
		end
----------------------------------------------
    end	
end)

-- Overall Info
RegisterNetEvent('rw_hud:setInfo')
AddEventHandler('rw_hud:setInfo', function(info)

	SendNUIMessage({action = 'update', type = 'society-name', data = PlayerData.job.label or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'money', data = info['money'] or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'bank-account', data = info['bank'] or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'black_money', data = info['blackm'] or 'ERORR_1'})
    SendNUIMessage({action = 'update', type = 'tmda-time-text', data = info['time'] or 'ERORR_1'})
    SendNUIMessage({action = 'update', type = 'tmda-date-text', data = info['date'] or 'ERORR_1' })
    SendNUIMessage({action = 'update', type = 'donate-coins', data = info['dnates'] or 'ERORR_1'})



end)

---- VEHICLE
CreateThread(function()
	while true do
		Wait(150)
		------- vehicle ------
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			SendNUIMessage({action = 'showElement', type = 'in-vehicle'})

			local vehicle = GetVehiclePedIsIn(ped)

			local data = {
				health = GetVehicleEngineHealth(vehicle),
				speed = GetEntitySpeed(vehicle)*2.2,
				maxSpeed = GetVehicleMaxSpeed(vehicle)*2.2,
				fuel = GetVehicleFuelLevel(vehicle),
			}
			SendNUIMessage({action = 'speedometer', data = data})
		else
			SendNUIMessage({action = 'hideElement', type = 'in-vehicle'})
		
		end
	end
end)

