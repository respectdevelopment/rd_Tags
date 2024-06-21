Citizen.CreateThread(function()
    
    lib.locale()

    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS rd_Tags (name TEXT, license TEXT, tag TEXT)")

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

lib.callback.register("rd_Tags:Server:GetPlayerIdentifier", function(source)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end
    return GetPlayerLicense(source)

end)

lib.callback.register("rd_Tags:Server:DeleteAdministrator", function(source, license)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

    local query = MySQL.query.await("DELETE FROM rd_Tags WHERE license = ?", {license})
    return true

end)

lib.callback.register("rd_Tags:Server:ChangeAdminTag", function(source, tag, license)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

    local query = MySQL.update("UPDATE rd_Tags SET tag = ? WHERE license = ?", {tag, license})
    return true


end)

lib.callback.register("rd_Tags:Server:GetPlayers", function(source)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

    local Query = MySQL.query.await("SELECT license FROM rd_Tags")
    local Players = {}

    for _, k in pairs (GetActivePlayers()) do

        if not Query[GetPlayerIdentifier(k, 0)] then

            Players[#Players+1] = {
                name = GetPlayerName(k),
                id = k
            }

        end

    end

    return Players

end)

lib.callback.register("rd_Tags:Server:GetPlayerTag", function(source)

    local query = MySQL.query.await("SELECT * FROM rd_Tags WHERE license = ?", {GetPlayerLicense(source)})
    return query

end)

lib.callback.register("rd_Tags:Server:AddAdministrator", function(source, player, tag)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

    local query = MySQL.insert.await("INSERT INTO rd_Tags (name, license, tag) VALUES (?, ?, ?)", {
        GetPlayerName(player),
        GetPlayerLicense(source),
        tag
    })

    return GetPlayerName(source)

end)

lib.callback.register("rd_Tags:Server:GetAdmins", function()

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

    local query = MySQL.query.await("SELECT * FROM rd_Tags")
    return query

end)

lib.callback.register("rd_Tags:Server:SetActiveAdmin", function(source, action, prop)

    if not Config.Menu.Permission[GetPlayerLicense(source)] then return end

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

function GetPlayerLicense(id)

    local identifiers = GetPlayerIdentifiers(id)

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license" .. ":") then
            return identifier
        end
    end

    return nil

end