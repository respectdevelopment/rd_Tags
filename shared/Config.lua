Config = {}

Config.Notification = "esx" -- ["esx" / "qb" / "ox" / "okok" / "rd" / "custom"]

Config.PauseMenu = false
Config.DisabledMicrophone = false

Config.Menu = {

    Permission = {

        DiscordID = {


            -- You can add unlimited more permission
            -- ["discord:624614621273128990"] = true

        },

        License = {

            ["license:aa234d7a8512d560594b0e85d70c6f216b8dffb4"] = true,

            -- You can add unlimited more permission
            -- ["license:code"] = true

        }

    },

    Command = {

        Name = "tag-settings",
        Description = "Open tag-settings menu. (Admin-Only)"

    },

}

Config.Tags = {

    Enable = true,

    Type = { -- You can add unlimited new groups.

        ["Owner"] = { -- Group Name
            Sign = "bzzz_player_sign_owner" -- Prop Name (You can add other prop than default.)
        },

        ["Admin"] = { -- Group Name
            Sign = "bzzz_player_sign_admin" -- Prop Name (You can add other prop than default.)
        },

        ["Staff"] = { -- Group Name
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
