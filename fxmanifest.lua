fx_version 'cerulean'
game 'gta5'

name 'My Store'
description 'A store owning script for FiveM'
author 'HKA'

ui_page 'html/store_menu.html'
ui_page 'html/store_menu.css'

files {
    'html/*',
    'client.lua',
    'server.lua'
}

client_script {
    'client.lua'
}

server_script {
    'server.lua'
}
