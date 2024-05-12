Citizen.CreateThread(function()
    
    lib.locale()

    if Config.Framework == "esx" then
        ESX = exports["es_extended"]:getSharedObject()
    elseif Config.Framework == "qb" then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    PerformHttpRequest("https://raw.githubusercontent.com/respectdevelopment/versions/main/Tags", function(err, text, headers)

        if text then

            local ScriptVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
    
            if ScriptVersion == text then
                print("^2[INFO] rd_Tags have latest version! ("..ScriptVersion..")^7")
            else
                print("^3[UPDATE] Update for rd_Tags is avaible! ("..ScriptVersion.. " -> " ..text.. ")^7")
                print("^3[UPDATE] https://github.com/respectdevelopment/rd_Tags^7")
            end

        else

            print("^1[ERROR] ^7Problem with API.")

        end
    end)

end)

local ActiveAdmin = {}
local ActiveAFK = {}
local PauseMenu = {}
local DisabledMic = {}

lib.callback.register("rd_Tags:Server:GetPlayerGroup", function(source)

    if Config.Framework == "esx" then

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer == nil then return end

        local Group = xPlayer.getGroup()

        return Group
    elseif Config.Framework == "qb" then

        local xPlayer = QBCore.Functions.GetPlayer(playerId)

        if xPlayer == nil then return end

        local Group = xPlayer.PlayerData.group

        return Group
    end
end)

lib.callback.register("rd_Tags:Server:SetActiveAdmin", function(source, action, prop)

    if Config.Framework == "esx" then

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer == nil then return end

        if Config.Tags.Type[xPlayer.getGroup()] then

            if action == "set" then
                ActiveAdmin[GetPlayerName(source)] = prop

                if DiscordWebhook.TurnOnTag ~= nil then

                    local DiscordLog = {
                        {
                            ["color"] = 2600155,
                            ["title"] = locale("admintagontitle"),
                            ["description"] = locale("admintagondescription", GetPlayerName(source)),
                            ["footer"] = {
                                ["text"] = "Respect Development 〢 " ..os.date("%H:%M").. "",
                                ["icon_url"] = "https://media.discordapp.net/attachments/1236061492432994437/1236064086777794580/Picsart_24-05-04_00-15-07-775-removebg-preview.png?ex=663f37a3&is=663de623&hm=54cfdf0b05571750afb27b0a755363adae5f4d5e18d5d868f651007df0d7064e&=&format=webp&quality=lossless",
                            },
                        }
                    }
                    PerformHttpRequest(DiscordWebhook.TurnOnTag, function(err, text, headers) end, 'POST', json.encode({ username = "rd_Tags", embeds = DiscordLog, avatar_url = "https://media.discordapp.net/attachments/1236061492432994437/1236064086777794580/Picsart_24-05-04_00-15-07-775-removebg-preview.png?ex=663f37a3&is=663de623&hm=54cfdf0b05571750afb27b0a755363adae5f4d5e18d5d868f651007df0d7064e&=&format=webp&quality=lossless" }), { ['Content-Type'] = 'application/json' })
                end

            elseif action == "clear" then
                ActiveAdmin[GetPlayerName(source)] = nil

                if DiscordWebhook.TurnOffTag ~= nil then

                    local DiscordLog = {
                        {
                            ["color"] = 2600155,
                            ["title"] = locale("admintagofftitle"),
                            ["description"] = locale("admintagoffdescription", GetPlayerName(source)),
                            ["footer"] = {
                                ["text"] = "Respect Development 〢 " ..os.date("%H:%M").. "",
                                ["icon_url"] = "https://media.discordapp.net/attachments/1236061492432994437/1236064086777794580/Picsart_24-05-04_00-15-07-775-removebg-preview.png?ex=663f37a3&is=663de623&hm=54cfdf0b05571750afb27b0a755363adae5f4d5e18d5d868f651007df0d7064e&=&format=webp&quality=lossless",
                            },
                        }
                    }
                    PerformHttpRequest(DiscordWebhook.TurnOffTag, function(err, text, headers) end, 'POST', json.encode({ username = "rd_Tags", embeds = DiscordLog, avatar_url = "https://media.discordapp.net/attachments/1236061492432994437/1236064086777794580/Picsart_24-05-04_00-15-07-775-removebg-preview.png?ex=663f37a3&is=663de623&hm=54cfdf0b05571750afb27b0a755363adae5f4d5e18d5d868f651007df0d7064e&=&format=webp&quality=lossless" }), { ['Content-Type'] = 'application/json' })
                end
            end
        else
            DropPlayer(source, "Cheating.")
        end

    elseif Config.Framework == "qb" then

        local xPlayer = QBCore.Functions.GetPlayer(playerId)

        if xPlayer == nil then return end

        if Config.Tags.Type[xPlayer.PlayerData.group] then

            if action == "set" then
                ActiveAdmin[GetPlayerName(source)] = prop
            elseif action == "clear" then
                ActiveAdmin[GetPlayerName(source)] = nil
            end
        else
            DropPlayer(source, "Cheating.")
        end
    end

end)

lib.callback.register("rd_Tags:Server:SetActiveAFK", function(source, action, prop)

    if action == "set" then
        ActiveAFK[GetPlayerName(source)] = prop
    elseif action == "clear" then
        ActiveAFK[GetPlayerName(source)] = nil
    end

end)

lib.callback.register("rd_Tags:Server:SetActivePauseMenu", function(source, action, prop)

    if action == "set" then
        PauseMenu[GetPlayerName(source)] = prop
    elseif action == "clear" then
        PauseMenu[GetPlayerName(source)] = nil
    end

end)

lib.callback.register("rd_Tags:Server:SetDisabledMic", function(source, action, prop)

    if action == "set" then
        DisabledMic[GetPlayerName(source)] = prop
    elseif action == "clear" then
        DisabledMic[GetPlayerName(source)] = nil
    end

end)

AddEventHandler('playerDropped', function (reason)
    
    if ActiveAdmin[GetPlayerName(source)] then

        TriggerClientEvent("rd_Tags:Client:DeleteEntity", source, ActiveAdmin[GetPlayerName(source)], "tag")
        ActiveAdmin[GetPlayerName(source)] = nil
    end

    if ActiveAFK[GetPlayerName(source)] then

        TriggerClientEvent("rd_Tags:Client:DeleteEntity", source, ActiveAFK[GetPlayerName(source)], "afk")
        ActiveAFK[GetPlayerName(source)] = nil
    end

    if DisabledMic[GetPlayerName(source)] then

        TriggerClientEvent("rd_Tags:Client:DeleteEntity", source, DisabledMic[GetPlayerName(source)], "disabledmic")
        DisabledMic[GetPlayerName(source)] = nil
    end

    if PauseMenu[GetPlayerName(source)] then

        TriggerClientEvent("rd_Tags:Client:DeleteEntity", source, PauseMenu[GetPlayerName(source)], "pausemenu")
        PauseMenu[GetPlayerName(source)] = nil
    end

end)



