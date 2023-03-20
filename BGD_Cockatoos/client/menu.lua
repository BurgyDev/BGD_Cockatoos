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

function MenuCockatoos()
    local open = false
    local xIndex = 1
    local mainMenu = RageUI.CreateMenu("Cockatoos", "Menu")
    local Localisation = RageUI.CreateSubMenu(mainMenu, "Cockatoos", "Cockatoos")
    mainMenu.Closed = function() open = false end
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    RageUI.List("Annonce", {"Ouvert", "Fermé", "Personnalisé"}, xIndex, nil, {}, true, {
                        onListChange = function(Index)
                            xIndex = Index
                        end,
                        onSelected = function()
                            if xIndex == 1 then
                                TriggerServerEvent("BGD_Cockatoos:Open")
                            elseif xIndex == 2 then
                                TriggerServerEvent("BGD_Cockatoos:Close")
                            elseif xIndex == 3 then
                                local msg = KeyboardInput("Message", nil, 100)
                                TriggerServerEvent("BGD_Cockatoos:Perso", msg)
                            end
                        end
                    })
                    RageUI.Button("Facture", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Personne Autour")
                            else
                                local amount = KeyboardInput("Veuillez saisir le montant de la facture", nil, 8)
                                TriggerServerEvent("esx_billing:sendBill", GetPlayerServerId(closestPlayer), "society_"..ESX.PlayerData.job.name, ESX.PlayerData.job.name, amount)
                            end
                        end
                    })
                    RageUI.Button("Position GPS du circuit", nil, {RightLabel = "→"}, true, {}, Localisation)
                end)
                RageUI.IsVisible(Localisation, function()
                    RageUI.Button("Obtenir la récolte", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            SetNewWaypoint(2932.11, 4624.8, 48.72)
                        end
                    })
                    RageUI.Button("Obtenir le traitement", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            SetNewWaypoint(-1406.66, -253.90, 46.38)
                        end
                    })
                    RageUI.Button("Obtenir la vente", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            SetNewWaypoint(-767.60, -2596.37, 13.88)
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end

Keys.Register("F6", "cockatoos", "Ouvrir le menu Cockatoos", function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "cockatoos" then
        MenuCockatoos()
    end
end)