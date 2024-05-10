function Notify(title, description, type)
    if Config.Notification == "esx" then
        ESX = exports["es_extended"]:getSharedObject()
        ESX.ShowNotification(description)
    elseif Config.Notification == "qb" then
        QBCore = exports['qb-core']:GetCoreObject()
        if type == "success" then
            QBCore.Functions.Notify(description, 'success', 5000)
        elseif type == "error" then
            QBCore.Functions.Notify(description, 'error', 5000)
        end
    elseif Config.Notification == "ox" then
        if type == "success" then
            lib.notify({
                title = title,
                description = description,
                type = 'success'
            })
        elseif type == "error" then
            lib.notify({
                title = title,
                description = description,
                type = 'error'
            })
        end
    elseif Config.Notification == "okok" then
        if type == "success" then
            exports['okokNotify']:Alert(title, description, 3000, 'success', true)
        elseif type == "error" then
            exports['okokNotify']:Alert(title, description, 3000, 'error', true)
        end
    elseif Config.Notification == "rd" then
        if type == "success" then
            exports['rd_Notify']:Notify("success", title, description, 3, true)
        elseif type == "error" then
            exports['rd_Notify']:Notify("error", title, description, 3, true)
        end
    elseif Config.Notification == "custom" then
        print("^3[INFORMATION] ^7Set your custom notification type in rd_Tags/shared/cl_edit.lua")
    end
end
