---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-23 4:49 p.m.
---

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');
modimport('scripts/teams/CTFTeamManager');

CTFPrefabPatcher:registerPrefabPatcher('wall_ruins_2', function(inst, data)
    if TheWorld.ismastersim then
        CTFTeamManager:registerTeamObject(inst, data);
    end
end)
