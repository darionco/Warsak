---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-02 11:31 p.m.
---

local CTFInit = use('scripts/tools/CTFInit');
local CTF_ARMOUR = use('scripts/constants/CTFArmourConstants');
local CTF_TEAM_CONSTANTS = use('scripts/constants/CTFTeamConstants');

local function master_post_init(inst)
    -- fuels with poop
    inst.components.fueled.fueltype = FUELTYPE.POOP;

    -- do aoe raw damage when in return to attackers for which their damage is blocked
    local OldSetOnResistDamageFn = inst.components.resistance.SetOnResistDamageFn;
    inst.components.resistance.SetOnResistDamageFn = function(self, fn)
        if fn then
            local OldOnResistDamage = fn;
            fn = function(f_inst)
                OldOnResistDamage(f_inst);
                local owner = f_inst.components.inventoryitem:GetGrandOwner();
                if owner and owner:HasTag(CTF_TEAM_CONSTANTS.TEAM_PLAYER_TAG) and owner.data and owner.data.ctf_team_tag then
                    local teamTag = owner.data.ctf_team_tag;
                    local x, y, z = owner.Transform:GetWorldPosition();
                    local ents = TheSim:FindEntities(x, y, z, CTF_ARMOUR.armorskeleton.aoe_damage_radius, { '_combat', '_health' }, { teamTag });
                    for _, v in ipairs(ents) do
                        if v:IsValid() and not v:IsInLimbo() and not v.components.health:IsDead() then
                            v.components.health:DoRawDamage(CTF_ARMOUR.armorskeleton.aoe_damage, f_inst.prefab, owner, false);
                        end
                    end
                end
            end
        end
        OldSetOnResistDamageFn(self, fn);
    end
    inst.components.resistance:SetOnResistDamageFn(inst.components.resistance.onresistdamage);
end

CTFInit:Prefab('armorskeleton', nil, master_post_init);