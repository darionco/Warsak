---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 5:10 p.m.
---
local require = _G.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');
modimport('scripts/teams/CTFTeamManager');

CTFPrefabPatcher:registerPrefabPatcher('bishop_nightmare', function(inst, data)
    if TheWorld.ismastersim then
        inst.components.lootdropper.chanceloottable = false;
        inst.components.lootdropper:SetLoot({'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget', 'goldnugget'});

        CTFPrefabPatcher:patchStats(inst, data);

        if data.ctf_team then
            TheWorld:ListenForEvent(CTF_CONSTANTS.PLAYER_CONNECTED_EVENT, function()
                CTFTeamManager:registerTeamObject(inst, data);
            end);
        end
    end
end)