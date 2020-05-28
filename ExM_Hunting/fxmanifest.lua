fx_version 'bodacious'
game 'gta5'
description 'Hunting script for extendedmode'
version '1.0.0'
author 'Smallo'

client_scripts {
	'jaymenu.lua',
	'client.lua'
}

server_script 'server.lua'

shared_scripts {
	'@extendedmode/imports.lua',
	'config.lua'
}

dependency 'extendedmode'