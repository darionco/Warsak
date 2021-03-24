---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-23 9:27 p.m.
---

local function createFire(level, position)
    local ground = TheWorld.Map;
    if ground:IsPassableAtPoint(position:Get()) and not ground:IsGroundTargetBlocked(position) then
        local fire = SpawnPrefab('fire');
        if fire then
            fire:RemoveComponent('heater');
            fire.Transform:SetPosition(position.x, position.y, position.z);
            fire.components.firefx:SetLevel(level, true);
            fire.components.firefx:AttachLightTo(fire);
            local extinguish = level == 4 and true or false;
            fire._task = fire:DoPeriodicTask(0.5, function()
                if fire.components.firefx.level <= 1 then
                    if extinguish then
                        fire.components.firefx:Extinguish();
                    end
                    fire:Remove();
                    fire._task:Cancel();
                else
                    fire.components.firefx:SetLevel(fire.components.firefx.level - 1);
                end
            end);
        end
    end
end

local function createFireRing(level, position, radius, count)
    local step = (math.pi * 2) / count;
    for i = 1, count do
        local pos = Vector3(position.x + math.cos(step * i) * radius, position.y, position.z + math.sin(step * i) * radius);
        createFire(level, pos);
    end
end

local function fn()
    local inst = CreateEntity();

    inst.entity:AddTransform();
    inst.entity:AddNetwork();
    inst.entity:AddLight();
    inst.entity:AddSoundEmitter();
    inst.entity:AddPhysics();

    inst:AddTag('FX');
    inst:AddTag('NOCLICK');

    inst.Physics:SetMass(0.1);
    inst.Physics:SetFriction(0);
    inst.Physics:SetDamping(0);
    inst.Physics:SetRestitution(.5);
    inst.Physics:SetCollisionGroup(COLLISION.ITEMS);
    inst.Physics:ClearCollisionMask();
    inst.Physics:CollidesWith(COLLISION.GROUND);
    inst.Physics:SetCapsule(.1, .1);

    inst.Light:SetColour(unpack({ 223 / 255, 208 / 255, 69 / 255 }));
    inst.Light:Enable(true);
    inst.Light:EnableClientModulation(true);
    inst.Light:SetFalloff(0.7);
    inst.Light:SetIntensity(0.7);
    inst.Light:SetRadius(11);

    inst.SoundEmitter:PlaySound('dontstarve/common/staff_star_LP', 'staff_star_loop', nil, not TheWorld.ismastersim);
    inst.SoundEmitter:PlaySound('dontstarve/common/staff_star_create');

    inst.fx = inst:SpawnChild('ctf_fire_blast_fx');

    inst.onhitfn = nil;

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent('complexprojectile');
    inst.components.complexprojectile:SetHorizontalSpeed(25);
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.35, 2.25, 0));
    inst.components.complexprojectile.usehigharc = false;
    inst.components.complexprojectile:SetOnHit(function()
        if inst.targetPosition then
            createFire(4, inst.targetPosition);
            createFireRing(4, inst.targetPosition, 1, 3);
            createFireRing(3, inst.targetPosition, 2, 6);
            createFireRing(2, inst.targetPosition, 3, 12);
            createFireRing(1, inst.targetPosition, 4, 24);
        end
        inst.SoundEmitter:KillSound('staff_star_loop');
        inst:Remove();
        if inst.onhitfn then
            inst.onhitfn(inst);
        end
    end);

    inst.persists = false;

    return inst
end

local function fn_fx()
    local inst = CreateEntity();

    inst.entity:AddTransform();
    inst.entity:AddAnimState();
    --inst.entity:AddNetwork();

    inst:AddTag('FX');
    inst:AddTag('NOCLICK');

    inst.AnimState:SetBank('star_hot');
    inst.AnimState:SetBuild('star_hot');
    inst.AnimState:PlayAnimation('appear');
    inst.AnimState:PushAnimation('idle_loop', true);
    inst.AnimState:SetBloomEffectHandle('shaders/anim.ksh');

    inst.AnimState:HideSymbol('shdw');

    local offset = Vector3(inst.AnimState:GetSymbolPosition('base', 0, 0, 0));
    inst.Transform:SetPosition(0, -offset.y, 0);

    inst.persists = false;

    return inst;
end

return Prefab('ctf_fire_blast', fn),
        Prefab('ctf_fire_blast_fx', fn_fx, { Asset("ANIM", "anim/star_hot.zip") });