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

function GestionCockatoos()
    local open = false
    local mainMenu = RageUI.CreateMenu("Gestion", "Menu")
    mainMenu.Closed = function() open = false end
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    if SocietyAccount ~= nil then
                        RageUI.Button("Argent de la société :", nil, {RightLabel = "~g~"..SocietyAccount.."$"}, true, {})
                    end
                    RageUI.Button("Retirer de l'argent", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local amount = KeyboardInput("Combien voulez vous retirer", nil, 10)
                            TriggerServerEvent("esx_society:withdrawMoney", ESX.PlayerData.job.name, amount)
                            Wait(100)
                            RefreshMoney()
                        end
                    })
                    RageUI.Button("Déposer de l'argent", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local amount = KeyboardInput("Combien voulez vous déposer", nil, 10)
                            TriggerServerEvent("esx_society:depositMoney", ESX.PlayerData.job.name, amount)
                            Wait(100)
                            RefreshMoney()
                        end
                    })
                    RageUI.Button("Ouvrir le menu patron", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            TriggerEvent("esx_society:openBossMenu", ESX.PlayerData.job.name, function(data, menu)
                                menu.close()
                            end, {wash = false})
                            RageUI.CloseAll()
                            open = false
                        end 
                    })
                end)
            Wait(0)
            end
        end)
    end
end

local pos = {{x = BGD_Cockatoos.Pos.Gestion.x, y = BGD_Cockatoos.Pos.Gestion.y, z = BGD_Cockatoos.Pos.Gestion.z}}

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k in pairs(pos) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == "cockatoos" and ESX.PlayerData.job.grade_name == "boss" then 
                local coords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(coords.x, coords.y, coords.z, pos[k].x, pos[k].y, pos[k].z)
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(BGD_Cockatoos.Marker.Type, BGD_Cockatoos.Pos.Gestion.x, BGD_Cockatoos.Pos.Gestion.y, BGD_Cockatoos.Pos.Gestion.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.5, 0.5, 0.5, BGD_Cockatoos.Marker.R, BGD_Cockatoos.Marker.V, BGD_Cockatoos.Marker.B, 255, false, false, p19, false)    
                    if dist <= 1.5 then 
                        wait = 0 
                        ESX.ShowHelpNotification("~INPUT_TALK~ pour ouvrir le ~g~Gestion")
                        if IsControlJustPressed(1,51) then 
                            RefreshMoney()
                            GestionCockatoos()
                        end
                    end
                end
            end
        Citizen.Wait(wait)
        end
    end
end)