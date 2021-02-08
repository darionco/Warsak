---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 12:42 p.m.
---

local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local CTFTeamCombat = require('teams/CTFTeamCombat');

modimport('scripts/prefabs/patcher/CTFPrefabPatcher');

CTFPrefabPatcher:registerPrefabPatcher('killerbee', function(inst, data)
    if TheWorld.ismastersim then
        inst.components.lootdropper:SetLoot({'goldnugget'});

        CTFPrefabPatcher:patchStats(inst, data);

        local OldRetargetFunction = inst.components.combat.targetfn;
        inst.components.combat:SetRetargetFunction(inst.components.combat.retargetperiod, function(self)
            if self:HasTag(CTF_CONSTANTS.TEAM_MINION_TAG) then
                return CTFTeamCombat.findEnemy(self, SpringCombatMod(8), self.data.ctf_team_tag);
            end
            return OldRetargetFunction(self);
        end)
    end
end);
