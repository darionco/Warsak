---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 1:47 p.m.
---
---
local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local CTFTeamCombat = require('teams/CTFTeamCombat');

AddPrefabPostInit('spider', function(inst)
    if TheWorld.ismastersim then
        inst.components.lootdropper:SetLoot({'goldnugget'});

        local OldRetargetFunction = inst.components.combat.targetfn;
        inst.components.combat:SetRetargetFunction(inst.components.combat.retargetperiod, function(self)
            if self:HasTag(CTF_CONSTANTS.TEAM_MINION_TAG) then
                local radius = self.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST;
                return CTFTeamCombat.findEnemy(self, SpringCombatMod(radius), self.data.ctf_team_tag);
            end
            return OldRetargetFunction(self);
        end)
    end
end);
