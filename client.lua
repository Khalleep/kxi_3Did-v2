local isIdDisplaying = false
local isThreadRunning = false
local showplayercfxname = true

RegisterCommand("toggleid", function()
    isIdDisplaying = not isIdDisplaying
    if isIdDisplaying then
        if not isThreadRunning then
            StartIdDisplayThread()
            isThreadRunning = true
        end
        lib.notify({
            title = 'Player IDs',
            description = 'Player IDs are now on',
            type = 'info'
        })
    else
        lib.notify({
            title = 'Player IDs',
            description = 'Player IDs are now off',
            type = 'info'
        })
    end
end)

RegisterKeyMapping("toggleid", "Toggle Player IDs", "keyboard", "pageup")

function StartIdDisplayThread()
    Citizen.CreateThread(function()
        while isIdDisplaying do
            Citizen.Wait(0)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local playerid = GetPlayerServerId(PlayerId())  

           if showplayercfxname then
                local playername = GetPlayerName(PlayerId()) 
                DrawPlayerId(playerCoords.x, playerCoords.y, playerCoords.z + 1.2, playername .. "~n~" .. playerid)
            else
                DrawPlayerId(playerCoords.x, playerCoords.y, playerCoords.z + 1.2, playerid)
            end        

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)
                local playerid2 = GetPlayerServerId(player)

                if distance < 20.0 and playerPed ~= targetPed then
                    if showplayercfxname then
                        local playername2 = GetPlayerName(player) 
                        DrawPlayerId(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, playername2 .. "~n~" .. playerid2)
                    else
                        DrawPlayerId(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, playerid2)
                    end
                end
            end
        end
        isThreadRunning = false
    end)
end

function DrawPlayerId(x, y, z, id)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.31, 0.31)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(tostring(id))
        DrawText(_x, _y)
    end
end
