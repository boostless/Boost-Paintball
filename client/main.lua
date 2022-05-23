_game = {}
_playerData = {
    inLobby = false,
    lastPosition = false
}

CreateThread(function()
    Functions.createPoints()
end)

-- Events

AddEventHandler('playerSpawned', Functions.createPoints())

RegisterNetEvent('paintball:startGame', function(data)

end)

RegisterNetEvent('paintball:joinLobby', function(data)
    _game = data
    _playerData.inLobby = true
    _playerData.lastPosition = GetEntityCoords(cache.ped)
    Functions.teleportTo(Config.lobbyLocation)
    lib.showTextUI('Waiting for players (' .. _game.lobby.count .. '/' .. _game.maxPlayers .. ')')
end)

RegisterNetEvent('paintball:leaveLobby', function(data)
    _game = {}
    _playerData.inLobby = false
    Functions.teleportTo(_playerData.lastPosition)
    lib.hideTextUI()
end)

RegisterNetEvent('paintball:updateLobbyCount', function(data)
    _game.lobby = data
    lib.showTextUI('Waiting for players (' .. _game.lobby.count .. '/' .. _game.maxPlayers .. ')')
end)
