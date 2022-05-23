Utils = {}

Utils.dumpTable = function(table, nb)
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
			s = s .. '['..k..'] = ' .. Utils.dumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

Utils.getGame = function(from,value)
    for k,v in pairs(game.list) do
        if v[from] == value then
            return v
        end
    end
end

Utils.getGameList = function()
	local list = {}
	for k,v in pairs(game.list) do
		list[#list+1] = {
			uid = v.uid,
			name = v.name,
			maxPlayers = v.maxPlayers,
			minPlayers = v.minPlayers,
			map = v.map,
			mode = v.mode,
			password = v.password,
			lobby = v.lobby
		}
	end

	return list
end