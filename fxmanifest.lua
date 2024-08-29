fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

description "Advanced PedManager"
author "FiveBazaar"
version      '1.0'
repository ''

dependencies {
    '/onesync',
}



client_scripts {
    'client.lua',
    'bridge/client.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
    'server.lua',
}
