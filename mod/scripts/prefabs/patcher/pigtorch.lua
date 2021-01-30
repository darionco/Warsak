---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 5:09 p.m.
---

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');
modimport('scripts/teams/CTFTeamManager');

CTFPrefabPatcher:registerPrefabPatcher('pigtorch', function(inst, data)
    if TheWorld.ismastersim then
        if data.ctf_team then
            CTFTeamManager:registerTeamObject(inst, data);
        end
    end
end)