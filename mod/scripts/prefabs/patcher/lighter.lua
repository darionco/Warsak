---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-21 11:04 p.m.
---

local require = _G.require;
local Propagator = require('components/propagator');
local CTFClassPatcher = use('scripts/CTFClassPatcher');
local CTF_CHARACTER_CONSTANTS = use('scripts/constants/CTFCharacterConstants');
local CTF_TEAM_CONSTANTS = use('scripts/constants/CTFTeamConstants');

local WILLOW = CTF_CHARACTER_CONSTANTS.WILLOW;

-- disable fire propagation
Propagator.StartSpreading = function() --[[ no op ]]  end

-- temporary method to not stunlock with the lighter
CTFClassPatcher(_G.EventHandler, function(self, ctor, name, fn)
    if name == 'attacked' then
        local new_fn = function(inst, data)
            if not data or not data.weapon or data.weapon.prefab ~= 'lighter' then
                fn(inst, data);
            end
        end
        ctor(self, name, new_fn);
    else
        ctor(self, name, fn);
    end
end);

local function onattack(inst, attacker, target)
    attacker.SoundEmitter:PlaySound('dontstarve/wilson/fireball_explo');

    if not target:IsValid() then
        --target killed or removed in combat damage phase
        return
    elseif target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
        if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then
            target.components.freezable:Unfreeze();
        elseif target.components.burnable.canlight or target.components.combat ~= nil and target.components.burnable.smolder_queue_length < WILLOW.LIGHTER_MAX_SMOLDER_STACKS then
            target.components.burnable:AddSmoldering(
                    WILLOW.LIGHTER_SMOLDER_TICK_COUNT,
                    WILLOW.LIGHTER_SMOLDER_TICK_TIME,
                    WILLOW.LIGHTER_SMOLDER_TICK_DAMAGE,
                    inst.prefab,
                    attacker
            );
        end
    end

    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(-1);
        if target.components.freezable:IsFrozen() then
            target.components.freezable:Unfreeze();
        end
    end

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp();
    end

    if target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker);
    end

    target:PushEvent('attacked', { attacker = attacker, damage = inst.components.weapon.damage, weapon = inst });
end

local function onHitAOE(doer, invobject, pos)
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 4.5, { '_combat' });
    local teamTag = doer.data.ctf_team_tag;
    local damage = WILLOW.LIGHTER_FIRE_BLAST_DAMAGE;
    for _, v in ipairs(ents) do
        if v ~= doer and not v:HasTag(teamTag) and v:IsValid() and not v:IsInLimbo() then
            if v.components then
                if v.components.combat then
                    v.components.combat:GetAttacked(doer, damage, nil);
                end

                if v.components.burnable then
                    if v.components.health:IsDead() then
                        v.components.burnable:Ignite();
                    elseif v.components.burnable.smoldering then
                        local smolderDamage = v.components.burnable.smolder_queue_length * WILLOW.LIGHTER_FIRE_BLAST_FIRE_SMOLDER_STACK_DAMAGE;
                        v.components.burnable:StartBurningDamage(
                                WILLOW.LIGHTER_FIRE_BLAST_FIRE_TICK_COUNT,
                                WILLOW.LIGHTER_FIRE_BLAST_FIRE_TICK_TIME,
                                WILLOW.LIGHTER_FIRE_BLAST_FIRE_TICK_DAMAGE + smolderDamage,
                                invobject.prefab,
                                doer
                        );
                    else
                        v.components.burnable:AddSmoldering(
                                WILLOW.LIGHTER_SMOLDER_TICK_COUNT,
                                WILLOW.LIGHTER_SMOLDER_TICK_TIME,
                                WILLOW.LIGHTER_SMOLDER_TICK_DAMAGE,
                                invobject.prefab,
                                doer
                        );
                    end
                end
            end
        end
    end
end

local function castAOE(act)
    local doer = act.doer;
    local invobject = act.invobject;
    local pos = act:GetActionPoint();

    if doer and doer.components.cooldown and invobject and invobject.components.aoetargeting then
        invobject.components.aoetargeting:SetEnabled(false);
        doer.components.cooldown:StartCharging();

        local projectile = SpawnPrefab('ctf_fire_blast');
        if projectile then
            local x, y, z = doer.Transform:GetWorldPosition();
            projectile.Transform:SetPosition(x, y, z);
            projectile.targetPosition = pos;
            projectile.components.complexprojectile:Launch(pos, doer, doer);
            if doer.data and doer.data.ctf_team_tag then
                projectile.onhitfn = function()
                    onHitAOE(doer, invobject, pos);
                end;
            end
        end

        return true;
    end
end

local function patchWeapon(weapon)
    weapon:SetDamage(WILLOW.LIGHTER_HIT_DAMAGE);
    weapon:SetRange(WILLOW.LIGHTER_ATTACK_RANGE_MIN, WILLOW.LIGHTER_ATTACK_RANGE_MAX);
    weapon:SetOnAttack(onattack);
    weapon:SetProjectile('fire_projectile');
end

local function patchOnEquip(equippable)
    local OldOnEquip = equippable.onequipfn;
    equippable:SetOnEquip(function(inst, owner)
        OldOnEquip(inst, owner);
        if owner.components then
            if owner.components.combat then
                inst.ctf_old_attack_period = owner.components.combat.min_attack_period;
                owner.components.combat:SetAttackPeriod(WILLOW.LIGHTER_ATTACK_PERIOD);
            end

            if owner.components.cooldown then
                inst.components.aoetargeting:SetEnabled(owner.components.cooldown:IsCharged());
                owner.components.cooldown.onchargedfn = function()
                    inst.components.aoetargeting:SetEnabled(true);
                end
            end
        end

        if TheWorld.ismastersim then
            if owner.data and owner.data.ctf_team_id then
                inst.components.aoetargeting.reticule.validcolour = CTF_TEAM_CONSTANTS.TEAM_COLORS[owner.data.ctf_team_id];
            end
        end
    end);
end

local function patchOnUnequip(equippable)
    local OldOnUnequip = equippable.onunequipfn;
    equippable:SetOnUnequip(function(inst, owner)
        OldOnUnequip(inst, owner);
        if owner.components then
            if owner.components.combat then
                owner.components.combat:SetAttackPeriod(inst.ctf_old_attack_period or TUNING.WILSON_ATTACK_PERIOD);
            end

            if owner.components.cooldown then
                owner.components.cooldown.onchargedfn = nil;
            end
        end
    end);
end

local function patchEquippable(equippable)
    equippable.restrictedtag = 'pyromaniac';
    patchOnEquip(equippable);
    patchOnUnequip(equippable);
end

AddPrefabPostInit('lighter', function(inst)
    inst:AddComponent('aoetargeting');
    inst.components.aoetargeting.reticule.reticuleprefab = 'reticuleaoe';
    inst.components.aoetargeting.reticule.pingprefab = 'reticuleaoeping';
    inst.components.aoetargeting.reticule.targetfn = nil;
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 };
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 };
    inst.components.aoetargeting.reticule.ease = true;
    inst.components.aoetargeting.reticule.mouseenabled = true;
    inst.components.aoetargeting:SetEnabled(false);

    inst:AddComponent('aoespell');
    inst.components.aoespell.cast_spell = castAOE;
    inst.components.aoespell.str = 'Fire Blast!';
    inst.components.aoespell.action = 'ctf_fire_blast';
    inst.components.aoespell.distance = WILLOW.LIGHTER_FIRE_BLAST_DISTANCE;
    inst.components.aoespell.can_cast = function(act)
        local doer = act.doer;
        if doer and doer.components and doer.components.cooldown then
            return doer.components.cooldown:IsCharged();
        end
        return false;
    end;

    if inst.components then
        inst:RemoveComponent('fueled');
        inst:RemoveComponent('lighter');
        inst:RemoveComponent('cooker');

        inst:AddTag('lighter');

        if inst.components.weapon then
            patchWeapon(inst.components.weapon);
        end

        if inst.components.equippable then
            patchEquippable(inst.components.equippable);
        end
    end
end);

AddPrefabPostInit('fire_projectile', function(inst)
    if inst.components and inst.components.projectile then
        inst.components.projectile:SetSpeed(35);
    end
end);
