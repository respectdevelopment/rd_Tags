local Table = {
    AFK = {},
    TAG = {},
    PAUSEMENU = {},
    DISABLEDMIC = {}
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

            Notify(locale("error"), locale("afkon"), "error")

            lib.callback.await("rd_Tags:Server:SetActiveAFK", source, "set", prop)
        else

            for _, k in pairs(Table.AFK) do
                DeleteEntity(k)
            end

            Table.AFK = {}
            lib.callback.await("rd_Tags:Server:SetActiveAFK", source, "clear")
            Notify(locale("error"), locale("afkoff"), "error")

        end
    end)
end

RegisterCommand(Config.Menu.Command.Name, function()

    local Permission = lib.callback.await("rd_Server:GetPlayerIdentifiers", source)

    if Config.Menu.Permission.DiscordID[Permission.discord] or Config.Menu.Permission.License[Permission.license] then

        Citizen.Wait(250)

        lib.registerContext({
            id = 'rd_Tags:Main',
            title = locale("tagsettings"),
            options = {
                
                {
                    title = locale("administrators"),
                    description = locale("clickforviewadministrators"),
                    icon = "fas fa-list",

                    onSelect = function()

                        local Options = {}

                        local cb = lib.callback.await("rd_Tags:Server:GetAdmins", source)

                        if next(cb) == nil then
                            Notify(locale("error"), locale("anyadmin"), "error")
                            return
                        end
                
                        for _, k in pairs(cb) do
                
                            local options = {
                                title = k.name,
                                description = locale("clicktoeditadmin"),
                                icon = "fas fa-user",
                
                                metadata = {
                                    {label = locale("tag"), value = k.tag},                
                                },

                                onSelect = function()

                                    lib.registerContext({
                                        id = k.name,
                                        menu = "rd_Tags:Main",
                                        title = locale("tagsettings"),
                                        options = {

                                            {
                                                title = locale("edittag"),
                                                description = locale("clicktoefittag"),
                                                icon = "fas fa-pen",

                                                onSelect = function()

                                                    local Options = {}
                                                    local Tags = {}

                                                    for tag in pairs(Config.Tags.Type) do

                                                        if tag ~= k.tag then
                                                            table.insert(Tags, tag)
                                                        end 

                                                    end

                                                    for _, v in pairs(Tags) do
                                                        
                                                        local option = {
                                                            title = v,
                                                            description = locale("clicktoselectthistag"),
                                                            icon = "fas fa-shield",

                                                            onSelect = function()

                                                                local alert = lib.alertDialog({
                                                                    header = locale("edittag"),
                                                                    content = locale("confirmedit", k.name),
                                                                    centered = true,
                                                                    cancel = true
                                                                })

                                                                if alert == "confirm" then

                                                                    local cb = lib.callback.await("rd_Tags:Server:ChangeAdminTag", source, v, k.license)

                                                                    if cb then
                                                                        Notify(locale("success"), locale("changedtag", k.name), "success")
                                                                    end
                                                                else
                                                                    Notify(locale("success"), locale("canceledit", k.name), "success")
                                                                end

                                                            end
                                                        }

                                                        table.insert(Options, option)

                                                    end

                                                    lib.registerContext({
                                                        id = 'rd_Tags:TagList',
                                                        menu = k.name,
                                                        title = locale("tagsettings"),
                                                        options = Options 
                                                    })
                                                     
                                                    lib.showContext('rd_Tags:TagList')

                                                end


                                            },
                                            {
                                                title = locale("deleteadministrator"),
                                                description = locale("clicktodelete"),
                                                icon = "fas fa-trash",

                                                onSelect = function()

                                                    local alert = lib.alertDialog({
                                                        header = locale("deleteadministrator"),
                                                        content = locale("configmrdelete", k.name),
                                                        centered = true,
                                                        cancel = true
                                                    })

                                                    if alert == "confirm" then
                                                        local cb = lib.callback.await("rd_Tags:Server:DeleteAdministrator", source, k.license)

                                                        if cb then
                                                            Notify(locale("success"), locale("deletetedadmin", k.name), "success")
                                                        end
                                                    else
                                                        Notify(locale("success"), locale("canceldeleteadmin", k.name), "success")
                                                    end

                                                end
                                            }

                                        } 
                                    })
                                     
                                    lib.showContext(k.name)

                                end
                            }
                
                            table.insert(Options, options)
                
                        end
                
                        lib.registerContext({
                            id = 'rd_Tags:AdminList',
                            menu = "rd_Tags:Main",
                            title = locale("tagsettings"),
                            options = Options 
                        })
                         
                        lib.showContext('rd_Tags:AdminList')

                    end
                },

                {
                    title = locale("addnewadministrator"),
                    description = locale("clickforaddnewadministrator"),
                    icon = "fas fa-user-plus",

                    onSelect = function()

                        if Config.Menu.Permission.DiscordID[Permission.discord] or Config.Menu.Permission.License[Permission.license] then

                            local Options = {}
                            local Options2 = {}

                            local cb = lib.callback.await("rd_Tags:Server:GetPlayers", source)

                            for _, k in pairs(cb) do
                                Options[#Options + 1] = {label = k.name.." | ID: "..k.id, value = k.id}
                            end

                            for k, v in pairs(Config.Tags.Type) do
                                Options2[#Options2 + 1] = {label = k, value = k}
                            end

                            if next(Options) then

                                local input = lib.inputDialog(locale("give_vehicle"), {
                                    {type = 'select', label = locale('chooseplayer'), required = true, searchable = true, options = Options},
                                    {type = 'select', label = locale('choosetag'), required = true, searchable = true, options = Options2},
                                })

                                if input then

                                    local cb = lib.callback.await("rd_Tags:Server:AddAdministrator", source, Permission, input[1], input[2])

                                    if cb then
                                        Notify(locale("success"), locale("addednewaming", input[2], cb), "success")
                                    end

                                end

                            else
                                
                                Notify(locale("error"), locale("anyactiveplayer"), "error")

                            end

                        end
                    end
                },
            } 
        })

        lib.showContext("rd_Tags:Main")

    end
end)

if Config.Tags.Enable then

    TriggerEvent('chat:addSuggestion', '/' ..Config.Tags.Command.Name.. '', '' ..Config.Tags.Command.Description.. '')

    RegisterCommand(Config.Tags.Command.Name, function()
        
        local cb = lib.callback.await("rd_Tags:Server:GetPlayerTag", source)

        if next(cb) == nil then
            Notify(locale("error"), locale("yourdonthavepermission"), "error")
            return
        end

        if Config.Tags.Type[cb[1].tag] then
            
            Citizen.Wait(250)

            if next(Table.TAG) == nil then

                lib.requestModel(Config.Tags.Type[cb[1].tag].Sign, 500)
    
                local PlayerPed = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerPed)
        
                local prop = CreateObject(Config.Tags.Type[cb[1].tag].Sign, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.85, true, true, true)
                SetEntityHeading(prop, PlayerCoords.w)
                SetEntityRotation(prop, 0.0, 0.0, 0.0, 2, false)
                FreezeEntityPosition(prop, true)  
        
                table.insert(Table.TAG, prop)
                AttachEntityToEntity(prop, PlayerPed, GetPedBoneIndex(PlayerPed, 0x796e), 0.0, 0.0, 0.3, true, true, false, true, 1, true)

                Notify(locale("error"), locale("tagon"), "error")

                lib.callback.await("rd_Tags:Server:SetActiveAdmin", source, "set", prop)
            else
    
                for _, k in pairs(Table.TAG) do
                    DeleteEntity(k)
                end

                Table.TAG = {}
                lib.callback.await("rd_Tags:Server:SetActiveAdmin", source, "clear")
                Notify(locale("error"), locale("tagoff"), "error")
        
            end

        end

    end)
end

if Config.PauseMenu then

    Citizen.CreateThread(function()

        while true do

            Citizen.Wait(7)
            local sleep = true

            if IsPauseMenuActive() and next(Table.PAUSEMENU) == nil then
                
                lib.requestModel("bzzz_player_sign_pause", 500)
    
                local PlayerPed = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerPed)
        
                local prop = CreateObject("bzzz_player_sign_pause", PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.85, true, true, true)
                SetEntityHeading(prop, PlayerCoords.w)
                SetEntityRotation(prop, 0.0, 0.0, 0.0, 2, false)
                FreezeEntityPosition(prop, true)  
        
                table.insert(Table.PAUSEMENU, prop)
                AttachEntityToEntity(prop, PlayerPed, GetPedBoneIndex(PlayerPed, 0x796e), 0.0, 0.0, 0.3, true, true, false, true, 1, true)

                lib.callback.await("rd_Tags:Server:SetActivePauseMenu", source, "set", prop)

            elseif not IsPauseMenuActive() and next(Table.PAUSEMENU) ~= nil then

                for _, k in pairs(Table.PAUSEMENU) do
                    if k ~= nil then
                        DeleteEntity(k)
                        Table.PAUSEMENU = {}
                    end
                end

                lib.callback.await("rd_Tags:Server:SetActivePauseMenu", source, "clear")
                Table.PAUSEMENU = {}

            end

            if sleep then
                Citizen.Wait(3000)
            end

        end

    end)

end
    

if Config.DisabledMicrophone then

    Citizen.CreateThread(function()
    
        while true do
            Citizen.Wait(7)
            local sleep = true

            if MumbleIsConnected() == false and next(Table.DISABLEDMIC) == nil then

                lib.requestModel("bzzz_player_sign_voice", 500)
    
                local PlayerPed = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerPed)
        
                local prop = CreateObject("bzzz_player_sign_voice", PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.85, true, true, true)
                SetEntityHeading(prop, PlayerCoords.w)
                SetEntityRotation(prop, 0.0, 0.0, 0.0, 2, false)
                FreezeEntityPosition(prop, true)  
        
                table.insert(Table.DISABLEDMIC, prop)
                AttachEntityToEntity(prop, PlayerPed, GetPedBoneIndex(PlayerPed, 0x796e), 0.0, 0.0, 0.4, true, true, false, true, 1, true)

                lib.callback.await("rd_Tags:Server:SetDisabledMic", source, "set", prop)

            elseif MumbleIsConnected() == 1 and next(Table.DISABLEDMIC) ~= nil then

                for _, k in pairs(Table.DISABLEDMIC) do
                    if k ~= nil then
                        DeleteEntity(k)
                        Table.DISABLEDMIC = {}
                    end
                end

                lib.callback.await("rd_Tags:Server:SetDisabledMic", source, "clear")
                Table.DISABLEDMIC = {}

            end

            if sleep then
                Citizen.Wait(3000)
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
    elseif action == "disabledmic" and next(Table.DISABLEDMIC) ~= nil then
        Table.DISABLEDMIC = {}
        DeleteEntity(prop)
    elseif action == "pausemenu" and next(Table.PAUSEMENU) ~= nil then
        Table.PAUSEMENU = {}
        DeleteEntity(prop)
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

    for _, k in pairs(Table.PAUSEMENU) do
        if k ~= nil then
            DeleteEntity(k)
            Table.PAUSEMENU = {}
        end
    end

    for _, k in pairs(Table.DISABLEDMIC) do
        if k ~= nil then
            DeleteEntity(k)
            Table.DISABLEDMIC = {}
        end
    end

end)

