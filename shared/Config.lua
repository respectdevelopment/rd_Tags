Config = {}

Config.Framework = "esx" -- ["esx" / "qb"]
Config.Notification = "esx" -- ["esx" / "qb" / "ox" / "okok" / "rd" / "custom"]

Config.PauseMenu = false
Config.DisabledMicrophone = false

Config.Tags = {

    Enable = true,

    Type = { -- You can add unlimited new groups.

        ["owner"] = { -- Group Name
            Sign = "bzzz_player_sign_owner" -- Prop Name (You can add other prop than default.)
        },

        ["admin"] = { -- Group Name
            Sign = "bzzz_player_sign_admin" -- Prop Name (You can add other prop than default.)
        },

        ["staff"] = { -- Group Name
            Sign = "bzzz_player_sign_staff" -- Prop Name (You can add other prop than default.)
        },  
        
    },

    Command = {

        Name = "tag",
        Description = "Set your tag above head. (Admin-Only)"

    },

}

Config.AFK = {

    Enable = false,

    Command = {

        Name = "afk",
        Description = "Set your status to afk."

    }

}
