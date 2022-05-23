local activeGames = {}

RegisterCommand('test', function()
    game.new('test', 4, 2, 'dust', 'ffa', '')
end)

RegisterCommand('reset', function(source)
    SetPlayerRoutingBucket(source, Config.routingBucket)
end)

RegisterServerEvent('paintball:createGame', function(data)
    if (tonumber(data?[3]) or tonumber(data?[4])) < 2 then return end 
    game.new(data[1] or GetPlayerName(source), data[3], data[4], data[6], data[5], data[2])
end)

RegisterServerEvent('paintball:joinGame', function(data)
    local _source = source
    local obj = Utils.getGame('uid', data.uid)
    obj:addPlayer(_source)
end)

RegisterServerEvent('paintball:leaveGame', function(data)
    local _source = source
    local obj = Utils.getGame('uid', data.uid)
    obj:removePlayer(_source)
end)

lib.callback.register('paintball:getActiveLobbies', function(source)
    return Utils.getGameList()
end)