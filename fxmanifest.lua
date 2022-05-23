fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Boost#4383'
description 'Boost`s paintball'
version '1.0.0'

lua54 'yes'

shared_scripts{
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts{
    'client/menu.lua',
    'client/functions.lua',
    'client/main.lua'
}

server_scripts{
    'server/class/game.lua',
    'server/utils.lua',
    'server/main.lua'
}