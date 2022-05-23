Menu = {}

--- Local functions

local function getLobbiesCount()
    return #lib.callback.await('paintball:getActiveLobbies')
end

local function getLobbies()
    local lobbies = {}
    local sLobbies = lib.callback.await('paintball:getActiveLobbies')

    for i=1, #sLobbies, 1 do
        lobbies[#lobbies+1] = {
            title = sLobbies[i].name .. ' lobby',
            description = 'Click to join',
            arrow = true,
            metadata = {
                {label = 'Players', value = sLobbies[i].lobby.count and tostring(sLobbies[i].lobby.count)..'/'..tostring(sLobbies[i].maxPlayers) or '0/'..tostring(sLobbies[i].maxPlayers)},
                {label = 'Map', value = sLobbies[i].map},
                {label = 'Mode', value = sLobbies[i].mode},
                {label = 'Password', value = sLobbies[i].password and 'Yes' or 'No'}
            },
            serverEvent = 'paintball:joinGame',
            args = {
                uid = sLobbies[i].uid,
            } 
        }
    end

    return lobbies
end

local function getMaps()
    local maps = {}
    for k,v in pairs(Config.maps) do
        maps[#maps+1] = {
            value = k, label = v.label
        }
    end
 
    return maps
end

AddEventHandler('paintball:createLobby', function()
    local input = lib.inputDialog('Create lobby', {
        {type = 'input', label = 'Lobby name'},
        {type = 'input', label = 'Lobby password (optional)', password = true, icon = 'lock'},
        {type = 'input', label = 'Max players (default 4)'},
        {type = 'input', label = 'Min players (default 2)'},
        {type = 'select', label = 'Gamemode', options = {
            {value = 'ffa', label = 'Free for all'},
            {value = 'tdm', label = 'Team deathmatch'}
        }},
        {type = 'select', label = 'Map', options = getMaps()},
    })

    if input then
        TriggerServerEvent('paintball:createGame', input)
    end
end)

---

Menu.openMain = function()
    lib.registerContext({
        id = 'main_menu',
        title = 'Paintball lobbies', 
        options = {
            {
                title = 'Active lobbies',
                menu = 'active_lobby_menu',
                description = 'Shows active lobbies you can join',
                metadata = {
                    {label = 'Current active lobbies', value = getLobbiesCount()},
                }
            },
            {
                title = 'Create Lobby',
                description = 'Takes you to another menu!',
                event = 'paintball:createLobby',
                arrow = true
            }
        },
        {
            id = 'active_lobby_menu',
            title = 'Active lobbies',
            menu = 'main_menu',
            options = getLobbies()
        }
    })
    lib.showContext('main_menu')
end

Menu.openLobby = function()
    lib.registerContext({
        id = 'lobby_menu',
        title = _game.name, 
        options = {
            {
                title = 'Leave lobby',
                serverEvent = 'paintball:leaveGame',
                arrow = true,
                args = {
                    uid = _game.uid
                }
            }
        }
    })
    lib.showContext('lobby_menu')
end

--- Commands

RegisterKeyMapping('openlobby', 'Open lobby menu', 'keyboard', 'F3')
RegisterCommand('openlobby', function()
    if _playerData.inLobby then
        Menu.openLobby()
    end
end)


dumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. dumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end