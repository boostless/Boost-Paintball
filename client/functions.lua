Functions = {}
local points = {}
local menuOpen = false

-- Local functions
local function drawText3D(coords, text, customEntry)
    local str = text

    local start, stop = string.find(text, "~([^~]+)~")
    if start then
        start = start - 2
        stop = stop + 2
        str = ""
        str = str .. string.sub(text, 0, start)
    end

    if customEntry ~= nil then
        AddTextEntry(customEntry, str)
        BeginTextCommandDisplayHelp(customEntry)
    else
        AddTextEntry(GetCurrentResourceName(), str)
        BeginTextCommandDisplayHelp(GetCurrentResourceName())
    end
    EndTextCommandDisplayHelp(2, false, false, -1)

    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

Functions.createPoints = function()
    for i=1, #Config.locations, 1 do
        local location = Config.locations[i]

        local blip = AddBlipForCoord(location.createLobby.coords)
        SetBlipSprite(blip, location.createLobby.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, location.createLobby.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.createLobby.blip.name)
        EndTextCommandSetBlipName(blip)

        local point = lib.points.new(location.createLobby.coords, location.createLobby.marker.distance, {
            marker = location.createLobby.marker
        })

        function point:nearby()
            DrawMarker(self.marker.type, self.coords.x, self.coords.y, self.coords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, self.marker.color.r, self.marker.color.g, self.marker.color.b, self.marker.color.a, false, true, 2, nil, nil, false)

            if self.currentDistance < 1.5 then
                drawText3D(vec3(self.coords.x, self.coords.y, self.coords.z), "~INPUT_PICKUP~ Open lobby menu")
                if IsControlJustReleased(0, 38) and not menuOpen then
                    Menu.openMain()
                end
            end
        end

        points[i] = point
    end
end

Functions.teleportTo = function(coords)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
end