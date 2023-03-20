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

function TraitementCockatoos()
    local open = false
    local mainMenu = RageUI.CreateMenu("Traitement", "Menu")
    mainMenu.Closed = function() open = false end
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Lancer/Stopper le Traitement", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            xTraitement()
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end

function xTraitement()
    traitement = not traitement
    while traitement do
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(2000)
        TriggerServerEvent("BGD_Cockatoos:traitement", "verre", "cartons_verres")
    end
    if not traitement then
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local pos = {{x = BGD_Cockatoos.Pos.Traitement.x, y = BGD_Cockatoos.Pos.Traitement.y, z = BGD_Cockatoos.Pos.Traitement.z}}

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k in pairs(pos) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cockatoos' then 
                local coords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(coords.x, coords.y, coords.z, pos[k].x, pos[k].y, pos[k].z)
                if dist <= 10.0 then 
                    wait = 0
                    DrawMarker(BGD_Cockatoos.Marker.Type, BGD_Cockatoos.Pos.Traitement.x, BGD_Cockatoos.Pos.Traitement.y, BGD_Cockatoos.Pos.Traitement.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.5, 0.5, 0.5, BGD_Cockatoos.Marker.R, BGD_Cockatoos.Marker.V, BGD_Cockatoos.Marker.B, 255, false, false, p19, false)  
                    if dist <= 8.0 then 
                        wait = 0 
                        ESX.ShowHelpNotification("~INPUT_TALK~ pour ouvrir la ~g~Traitement")
                        if IsControlJustPressed(1,51) then 
                            TraitementCockatoos()
                        end
                    end
                end
            end
        Citizen.Wait(wait)
        end
    end
end)