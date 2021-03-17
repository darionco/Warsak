---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 2:10 p.m.
---

local CTF_TEAM_CONSTANTS = use('scripts/constants/CTFTeamConstants');

local function handlePlayerJoined(world, player)
    world:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_CONNECTED_EVENT, player);
end

local function handlePlayerDisconnected(world, args)
    world:PushEvent(CTF_TEAM_CONSTANTS.PLAYER_DISCONNECTED_EVENT, args.player);
    CTFTeamManager:removePlayer(args.player);
end

local function handlePlayerSpawn(world, player)
    player:ListenForEvent('setowner', function()
        local existing = CTFTeamManager:getDisconnectedCTFPlayer(player.userid);
        if existing then
            CTFTeamManager:removeDisconnectedCTFPlayer(player.userid);
            CTFPlayer(CTFPlayer.copyPlayerNet(player, existing.net));
        else
            CTFPlayer(CTFPlayer.createPlayerNet(player));
        end
        player:AddComponent('itemtyperestrictions');
        if TheWorld.ismastersim then
            player:AddComponent('ctf_stats');
        end
    end);
end

AddPrefabPostInit('world', function(inst)
    inst:ListenForEvent('ms_playerjoined', handlePlayerJoined);
    inst:ListenForEvent('ms_playerdisconnected', handlePlayerDisconnected);
    inst:ListenForEvent("ms_playerspawn", handlePlayerSpawn);
end);
