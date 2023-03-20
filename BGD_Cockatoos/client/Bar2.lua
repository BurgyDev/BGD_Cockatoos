local mainMenu = RageUI.CreateMenu("Bar", "Bar")
local open,craftencours,fermerlemenu,chargement = false,false,false,0

mainMenu.Closed = function() open = false end

function Bar2()
	if not open then open = true RageUI.Visible(mainMenu, true)
		CreateThread(function()
			while open do
                if fermerlemenu then mainMenu.Closable = false else mainMenu.Closable = true end
                RageUI.IsVisible(mainMenu, function()
                    if not craftencours then
                        for k,v in pairs(BGD_Cockatoos.Bar2.List) do
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    craftencours = true
                                    label = v.label
                                    name = v.name
                                    FreezeEntityPosition(GetPlayerPed(-1), true)
                                    ESX.Streaming.RequestAnimDict("mini@repair", function()
                                        TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 51, 0, false, false, false)
                                        RemoveAnimDict("mini@repair")
                                    end)
                                end
                            })
                        end
                    else
                        RageUI.Separator("Fabrication de "..BGD_Cockatoos.Color..""..label.. " ~s~en cours...")
                        RageUI.PercentagePanel(chargement, "("..BGD_Cockatoos.Color..""..math.floor(chargement * 100).."%~s~)", "", "", {})
                        if chargement < 1.0 then
                            chargement = chargement + 0.001
                            fermerlemenu = true
                        else 
                            chargement = 0 
                        end
                        if chargement >= 1.0 then
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            ESX.Streaming.RequestAnimDict("move_m@_idles@shake_off", function()
                                TaskPlayAnim(GetPlayerPed(-1), "move_m@_idles@shake_off", "shakeoff_1", 8.0, -8.0, -1, 51, 0, false, false, false)
                                RemoveAnimDict("move_m@_idles@shake_off")
                            end)
                            TriggerServerEvent('preparation:preparer', name)
                            Wait(2000)
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            FreezeEntityPosition(GetPlayerPed(-1), false)
                            chargement = 0
                            craftencours = false
                            fermerlemenu = false
                            RageUI.CloseAll()
                            open = false
                        end
                    end
                end)
            Wait(0)
          	end
      	end)
    end
end

Citizen.CreateThread(function()
    while true do
    	local wait = 900
    	for k,v in pairs(BGD_Cockatoos.Bar2.Pos) do
        	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cockatoos' then
            	local coords = GetEntityCoords(GetPlayerPed(-1), false)
            	local dist = Vdist(coords.x, coords.y, coords.z, v.x, v.y, v.z)
            	if dist <= 8.0 then 
		        wait = 0
                    DrawMarker(BGD_Cockatoos.Marker.Type, BGD_Cockatoos.Pos.Coffre.x, BGD_Cockatoos.Pos.Coffre.y, BGD_Cockatoos.Pos.Coffre.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.6, 0.6, 0.6, BGD_Cockatoos.Marker.R, BGD_Cockatoos.Marker.V, BGD_Cockatoos.Marker.B, 255, false, false, p19, false)    
            		if dist <= 1.0 then 
						wait = 0
						ESX.ShowHelpNotification("~INPUT_TALK~ pour ouvrir le Bar a boissons")
                		if IsControlJustPressed(1,51) then
							Bar2()
           				end
        			end
        		end
    		end
		end
    Citizen.Wait(wait)
	end
end)