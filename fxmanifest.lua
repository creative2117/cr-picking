fx_version 'cerulean'
game 'gta5'

description 'cr-picking'
version '1.0.0'

server_script 'server/main.lua'

client_script 'client/main.lua'

shared_script 'config.lua'

dependencies {
	'qb-skillbar',
	'progressbar',
	'qb-core'
}

lua54 'yes'
