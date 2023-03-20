ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_phone:registerNumber', 'cockatoos', 'alert_cockatoos', true, true)
TriggerEvent('esx_society:registerSociety', 'cockatoos', 'cockatoos', 'society_cockatoos', 'society_cockatoos', 'society_cockatoos', {type = 'public'})

RegisterServerEvent("BGD_Cockatoos:Open")
AddEventHandler("BGD_Cockatoos:Open", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("esx:showAdvancedNotification", xPlayers[i], "Cockatoos", "Annonce", "Le Cockatoos est désormais ~g~Ouvert", "CHAR_CHAT_CALL", 8)
    end
end)

RegisterServerEvent("BGD_Cockatoos:Close")
AddEventHandler("BGD_Cockatoos:Close", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("esx:showAdvancedNotification", xPlayers[i], "Cockatoos", "Annonce", "Le Cockatoos est désormais ~r~Fermé", "CHAR_CHAT_CALL", 8)
    end
end)

RegisterServerEvent("BGD_Cockatoos:Perso")
AddEventHandler("BGD_Cockatoos:Perso", function(msg)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent("esx:showAdvancedNotification", xPlayers[i], "Cockatoos", "Annonce", msg, "CHAR_CHAT_CALL", 8)
    end
end)

ESX.RegisterServerCallback("BGD_Cockatoos:getInventoryItem", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.inventory
    local data = {}
    for _,v in pairs(result) do
        if v.count > 0 then
            table.insert(data, {label = v.label, name = v.name, count = v.count})
        end
    end
    cb(data)
end)

ESX.RegisterServerCallback("BGD_Cockatoos:getCoffreItem", function(source, cb, society)
    local data = {}
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..society, function(inventory)
        for _,v in pairs(inventory.items) do
            if v.count > 0 then
                table.insert(data, {label = v.label, name = v.name, count = v.count}) 
            end
        end 
    end)
    cb(data)
end)

RegisterServerEvent("BGD_Cockatoos:putCoffreItem")
AddEventHandler("BGD_Cockatoos:putCoffreItem", function(name, count, society)
    local xPlayer = ESX.GetPlayerFromId(source)
    local getInventory = xPlayer.getInventoryItem(name).count
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..society, function(inventory)
        if getInventory >= count and count > 0 then
            xPlayer.removeInventoryItem(name, count)
            inventory.addItem(name, count)
            TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous venez de déposer ~y~x"..count.." ~b~"..name)
        else 
            TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Vous n'en avez pas assez")
        end
    end)
end)

RegisterServerEvent("BGD_Cockatoos:putInventoryItem")
AddEventHandler("BGD_Cockatoos:putInventoryItem", function(name, count, society)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent("esx_addoninventory:getSharedInventory", "society_"..society, function(inventory)
        xPlayer.addInventoryItem(name, count)
        inventory.removeItem(name, count)
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous venez de retiré ~y~x"..count.." ~b~"..name)
    end)
end)

RegisterServerEvent("BGD_Cockatoos:recolte")
AddEventHandler("BGD_Cockatoos:recolte", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    if result >= 50 then
        TriggerClientEvent("esx:showNotification", source, "Vous ne pouvez pas en porter d'avantage")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent("esx:showNotification", source, "Récolte en cours...")
    end
end)

RegisterServerEvent("BGD_Cockatoos:traitement")
AddEventHandler("BGD_Cockatoos:traitement", function(item, xitem)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    local xresult = xPlayer.getInventoryItem(xitem).count
    if xresult > 50 then
        TriggerClientEvent("esx:showNotification", source, "Vous ne pouvez pas en porter d'avantage")
    elseif result < 5 then
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez plus assez de ~b~"..item.."~s~ pour traiter")
    else
        xPlayer.removeInventoryItem(item, 5)
        xPlayer.addInventoryItem(xitem, 1)
    end
end)

RegisterServerEvent("BGD_Cockatoos:vente")
AddEventHandler("BGD_Cockatoos:vente", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    if result > 0 then
        xPlayer.removeInventoryItem(item, 1)
        xPlayer.addMoney(BGD_Cockatoos.SellPrice)
        TriggerClientEvent("esx:showNotification", source, "Vous venez de gagner ~g~"..BGD_Cockatoos.SellPrice.."$")
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez plus rien à vendre")
    end
end)

RegisterServerEvent('preparation:preparer')
AddEventHandler('preparation:preparer', function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(name, 1)
end)