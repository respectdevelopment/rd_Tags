-- {{ FX Information }} --
fx_version 'cerulean'
game 'gta5'

-- {{ Resource Information }} --
author 'Respect Development'
description 'Tag System'
version '1.2'

-- {{ Manifest }} --
lua54 'yes'

shared_scripts {

    '@ox_lib/init.lua',
    'shared/Config.lua'

}

client_scripts {

    'client/main.lua',
    'shared/cl_edit.lua'

}

server_scripts {

    '@oxmysql/lib/MySQL.lua',

    'server/main.lua',
    'shared/sv_edit.lua'

}

files {
    'locales/*.json'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_player_signs.ytyp'