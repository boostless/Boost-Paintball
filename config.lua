Config = {}

Config.routingBucket = 0 -- Default dimension

Config.maps = {
    ['paintball'] = {
        label = 'Paintball',
        startingPoints = {
            red = {
                {coords = vec3(1784.163, 3261.811, -152.3275)}
            },
            blue = {
                {coords = vec3(1718.387, 3234.633, -152.3275)}
            }
        }
    }
}

Config.lobbyLocation = vec3(-1039.9, -2737.8, 20.9)

Config.locations = {
    {
        createLobby = {
            coords = vec3(412.8, -1647.705, 29.27991),
            marker = {
                type = 1,
                color = {r = 255, g = 255, b = 255, a = 255},
                distance = 5.0
            },
            blip = {
                sprite = 160,
                color = 1,
                name = "Lobby"
            }
        },
    }
}