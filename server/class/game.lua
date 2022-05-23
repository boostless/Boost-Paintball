local random = math.random
local function uuid()
    local template ='boost-yyyxxyxxyyyxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function getIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = ''
    for _, v in pairs(identifiers) do
        if string.find(v, 'license:') then
            identifier = string.gsub('license:', '', v)
        end
    end
    return identifier
end

local game = {
    count = 0,
    list = {}
}

setmetatable(game, {
	__add = function(self, obj)
		self.list[obj.uid] = obj
		self.count += 1
	end,

	__sub = function(self, obj)
		self.list[obj.uid] = nil
		self.count -= 1
	end,

	__call = function(self, uid)
		return self.list[uid]
	end
})

local CGame = {}
CGame.__index = CGame

function CGame:addPlayer(source)
    if not self.lobby.players[source] and self.lobby.maxPlayers ~= self.lobby.count + 1 then
        if self.gamemode == 'tdm' then end
        self.lobby.players[source] = {
            identifier = getIdentifier(source),
            name = GetPlayerName(source)
        }
        self.lobby.count += 1
        SetPlayerRoutingBucket(source, self.dimension)
        SetRoutingBucketPopulationEnabled(self.dimension, false)
        TriggerClientEvent('paintball:joinLobby', source, {uid = self.uid, maxPlayers = self.maxPlayers, lobby = self.lobby, name = self.name})

        for k,v in pairs(self.lobby.players) do
            TriggerClientEvent('paintball:updateLobbyCount', k, self.lobby)
        end
    end
end

function CGame:removePlayer(source)
    if self.lobby.players[source] then
        self.lobby.players[source] = nil
        self.lobby.count -= 1
        SetPlayerRoutingBucket(source, Config.routingBucket)
        TriggerClientEvent('paintball:leaveLobby', source, {uid = self.uid, lobby = self.lobby})
    end
end

function CGame:startGame() 
    for k,v in pairs(self.lobby.players) do
        TriggerClientEvent('paintball:startGame', k, {map = self.map, mode = self.mode})
    end
end

function CGame:startLobby()
    CreateThread(function()
        while self.minPlayers < self.lobby.count do
            Wait(1000)
        end
        self:startGame()
    end)
end

function CGame:getUid()
    return self.uid
end

function CGame:getPlayerCount()
    return self.lobby.count
end

---@param name string
---@param maxPlayers number
---@param minPlayers number
---@param map string
---@param mode string
---@param password string
---Creates an instance of CGame.
function game.new(name, maxPlayers, minPlayers, map, mode, password)
    local uid = uuid()
    if not game(uid) then
        local self = {
            uid = uid,
            name = name,
            maxPlayers = tonumber(maxPlayers) or 4,
            minPlayers = tonumber(minPlayers) or 2,
            map = map or 'dust',
            mode = mode or 'tdm',
            password = password,
            lobby = {
                players = {},
                count = 0
            },
            dimension = game.count + 1
        }

        setmetatable(self, CGame)

        return game + self
    else
        return game.new(name, maxPlayers, minPlayers, map, mode, password)
    end
end

_ENV.game = game