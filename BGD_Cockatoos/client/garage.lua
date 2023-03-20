ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function GarageCockatoos()
    local open = false
    local mainMenu = RageUI.CreateMenu("Garage", "Menu")
    mainMenu.Closed = function() open = false end
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local veh, dist2 = ESX.Game.GetClosestVehicle(playerCoords)
                            if dist2 < 4 then
                                DeleteEntity(veh)
                            end
                        end
                    })
                    RageUI.Button("Schachter", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            if ESX.Game.IsSpawnPointClear({x = BGD_Cockatoos.Pos.SpawnVehicule.x, y = BGD_Cockatoos.Pos.SpawnVehicule.y, z = BGD_Cockatoos.Pos.SpawnVehicule.z}, 2.0) then
                                ESX.Game.SpawnVehicle("schafter4", {x = BGD_Cockatoos.Pos.SpawnVehicule.x, y = BGD_Cockatoos.Pos.SpawnVehicule.y, z = BGD_Cockatoos.Pos.SpawnVehicule.z}, BGD_Cockatoos.Pos.SpawnVehicule.h, function(vehicle) 
                                    SetVehicleNumberPlateText(vehicle, ESX.PlayerData.job.name)
                                    SetVehicleFixed(vehicle)
                                end)
                                RageUI.CloseAll()
                                open = false
                            else
                                ESX.ShowNotification("La sortie est bloqué")
                            end
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end

local pos = {{x = BGD_Cockatoos.Pos.Garage.x, y = BGD_Cockatoos.Pos.Garage.y, z = BGD_Cockatoos.Pos.Garage.z}}

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k in pairs(pos) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cockatoos' then 
                local coords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(coords.x, coords.y, coords.z, pos[k].x, pos[k].y, pos[k].z)
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(BGD_Cockatoos.Marker.Type, BGD_Cockatoos.Pos.Garage.x, BGD_Cockatoos.Pos.Garage.y, BGD_Cockatoos.Pos.Garage.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.5, 0.5, 0.5, BGD_Cockatoos.Marker.R, BGD_Cockatoos.Marker.V, BGD_Cockatoos.Marker.B, 255, false, false, p19, false)    
                    if dist <= 1.5 then 
                        wait = 0 
                        ESX.ShowHelpNotification("~INPUT_TALK~ pour ouvrir le ~g~Garage")
                        if IsControlJustPressed(1,51) then 
                            GarageCockatoos()
                        end
                    end
                end
            end
        Citizen.Wait(wait)
        end
    end
end)