local Table = {
    AFK = {},
    TAG = {}
}

lib.locale()

if Config.AFK.Enable then

    TriggerEvent('chat:addSuggestion', '/' ..Config.AFK.Command.Name.. '', '' ..Config.AFK.Command.Description.. '')

    RegisterCommand(Config.AFK.Command.Name, function()

        if next(Table.AFK) == nil then

            local PlayerPed = PlayerPedId()
            local PlayerCoords = GetEntityCoords(PlayerPed)
    
            local prop = CreateObject("bzzz_player_sign_afkafk", PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.85, true, true, true)
            SetEntityHeading(prop, PlayerCoords.w)
            SetEntityRotation(prop, 0.0, 0.0, 0.0, 2, false)
            FreezeEntityPosition(prop, true)  
    
            table.insert(Table.AFK, prop)
            AttachEntityToEntity(prop, PlayerPed, GetPedBoneIndex(PlayerPed, 0x796e), 0.0, 0.0, 0.3, true, true, false, true, 1, true)

            Notify(locale("error"), locale("afkon"))

            lib.callback.await("rd_Tags:Server:SetActiveAFK", source, "set", prop)
        else

            for _, k in pairs(Table.AFK) do
                DeleteEntity(k)
            end

            Table.AFK = {}
            lib.callback.await("rd_Tags:Server:SetActiveAFK", source, "clear")
            Notify(locale("error"), locale("afkoff"))

        end
    end)
end

if Config.Tags.Enable then

    TriggerEvent('chat:addSuggestion', '/' ..Config.Tags.Command.Name.. '', '' ..Config.Tags.Command.Description.. '')

    RegisterCommand(Config.Tags.Command.Name, function()
        
        local cb = lib.callback.await("rd_Tags:Server:GetPlayerGroup")

        if Config.Tags.Type[cb] then
            
            Citizen.Wait(250)

            if next(Table.TAG) == nil then

                lib.requestModel(Config.Tags.Type[cb].Sign, 500)
    
                local PlayerPed = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerPed)
        
                local prop = CreateObject(Config.Tags.Type[cb].Sign, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.85, true, true, true)
                SetEntityHeading(prop, PlayerCoords.w)
                SetEntityRotation(prop, 0.0, 0.0, 0.0, 2, false)
                FreezeEntityPosition(prop, true)  
        
                table.insert(Table.TAG, prop)
                AttachEntityToEntity(prop, PlayerPed, GetPedBoneIndex(PlayerPed, 0x796e), 0.0, 0.0, 0.3, true, true, false, true, 1, true)

                Notify(locale("error"), locale("tagon"))

                lib.callback.await("rd_Tags:Server:SetActiveAdmin", source, "set", prop)
            else
    
                for _, k in pairs(Table.TAG) do
                    DeleteEntity(k)
                end

                Table.TAG = {}
                lib.callback.await("rd_Tags:Server:SetActiveAdmin", source, "clear")
                Notify(locale("error"), locale("tagoff"))
        
            end

        end

    end)
end

RegisterNetEvent("rd_Tags:Client:DeleteEntity", function(prop, action)

    if action == "tag" and next(Table.TAG) ~= nil then
        Table.TAG = {}
        DeleteEntity(prop)
    elseif action == "afk" and next(Table.AFK) ~= nil then
        Table.AFK = {}
        DeleteEntity(prop)
    else
        return 
    end

end)

AddEventHandler('onResourceStop', function(resourceName)

    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for _, k in pairs(Table.AFK) do
        if k ~= nil then
            DeleteEntity(k)
            Table.AFK = {}
        end
    end

    for _, k in pairs(Table.TAG) do
        if k ~= nil then
            DeleteEntity(k)
            Table.TAG = {}
        end
    end

end)

