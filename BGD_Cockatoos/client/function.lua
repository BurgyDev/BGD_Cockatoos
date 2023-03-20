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

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

data_coffre = {}

function GetCoffre()
    ESX.TriggerServerCallback("BGD_Cockatoos:getCoffreItem", function(data) 
        data_coffre = data
    end, ESX.PlayerData.job.name)
end

data_inventory = {}

function GetInventory()
    ESX.TriggerServerCallback("BGD_Cockatoos:getInventoryItem", function(data) 
        data_inventory = data
    end)
end

function RefreshMoney()
    ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money) 
        SocietyAccount = ESX.Math.GroupDigits(money)
    end, ESX.PlayerData.job.name)
end

function entreprise()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent("skinchanger:getSkin", function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = BGD_Cockatoos.Tenue.male.tshirt_1, ['tshirt_2'] = BGD_Cockatoos.Tenue.male.tshirt_2,
                ['torso_1'] = BGD_Cockatoos.Tenue.male.torso_1, ['torso_2'] = BGD_Cockatoos.Tenue.male.torso_2,
                ['decals_1'] = BGD_Cockatoos.Tenue.male.decals_1, ['decals_2'] = BGD_Cockatoos.Tenue.male.decals_2,
                ['chain_1'] = BGD_Cockatoos.Tenue.male.chain_1, ['chain_2'] = BGD_Cockatoos.Tenue.male.chain_2,
                ['arms'] = BGD_Cockatoos.Tenue.male.arms,
                ['pants_1'] = BGD_Cockatoos.Tenue.male.pants_1, ['pants_2'] = BGD_Cockatoos.Tenue.male.pants_2,
                ['shoes_1'] = BGD_Cockatoos.Tenue.male.shoes_1, ['shoes_2'] = BGD_Cockatoos.Tenue.male.shoes_2,
                ['helmet_1'] = BGD_Cockatoos.Tenue.male.helmet_1, ['helmet_2'] = BGD_Cockatoos.Tenue.male.helmet_2
            }
        else
            clothesSkin = {
                ['tshirt_1'] = BGD_Cockatoos.Tenue.female.tshirt_1, ['tshirt_2'] = BGD_Cockatoos.Tenue.female.tshirt_2,
                ['torso_1'] = BGD_Cockatoos.Tenue.female.torso_1, ['torso_2'] = BGD_Cockatoos.Tenue.female.torso_2,
                ['decals_1'] = BGD_Cockatoos.Tenue.female.decals_1, ['decals_2'] = BGD_Cockatoos.Tenue.female.decals_2,
                ['chain_1'] = BGD_Cockatoos.Tenue.female.chain_1, ['chain_2'] = BGD_Cockatoos.Tenue.female.chain_2,
                ['arms'] = BGD_Cockatoos.Tenue.female.arms,
                ['pants_1'] = BGD_Cockatoos.Tenue.female.pants_1, ['pants_2'] = BGD_Cockatoos.Tenue.female.pants_2,
                ['shoes_1'] = BGD_Cockatoos.Tenue.female.shoes_1, ['shoes_2'] = BGD_Cockatoos.Tenue.female.shoes_2,
                ['helmet_1'] = BGD_Cockatoos.Tenue.female.helmet_1, ['helmet_2'] = BGD_Cockatoos.Tenue.female.helmet_2
            }
        end
        TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
    end)
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(BGD_Cockatoos.Blip.Pos.x, BGD_Cockatoos.Blip.Pos.y, BGD_Cockatoos.Blip.Pos.z)
    SetBlipSprite(blip, BGD_Cockatoos.Blip.Sprite)
    SetBlipDisplay(blip, BGD_Cockatoos.Blip.Display)
    SetBlipScale(blip, BGD_Cockatoos.Blip.Scale)
    SetBlipColour(blip, BGD_Cockatoos.Blip.Colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(BGD_Cockatoos.Blip.Title)
    EndTextCommandSetBlipName(blip)
end)