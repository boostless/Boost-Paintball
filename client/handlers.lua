AddEventHandler('gameEventTriggered', function (name, args)
    
    local hit, bone = GetPedLastDamageBone(cache.ped)
    if name == 'CEventNetworkEntityDamage' then
        if args[1] == cache.ped then
            
        end
    end
end)
