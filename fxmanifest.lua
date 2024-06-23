fx_version 'cerulean'
game 'gta5'

author 'Creative#6720'
description 'cr-picking'
version '1.0.2'

server_script 'server/main.lua'

client_scripts {
	'client/main.lua',
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
}

shared_script 'config.lua'

dependencies {
	'qb-minigames',
	'progressbar',
	'qb-core'
}

lua54 'yes'
