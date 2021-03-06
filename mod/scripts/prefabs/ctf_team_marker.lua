---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-02 6:38 p.m.
---

local assets = {
    Asset('ANIM', 'anim/ctf_team_marker.zip'),
};

local function ctf()
    print('============================================ ctf_team_marker');
    --local inst = CreateEntity();
    --
    --inst.entity:AddTransform();
    --inst.entity:AddAnimState();
    --inst.entity:AddNetwork();
    --inst.entity:AddFollower();
    ----inst:AddTag('FX');
    --inst:AddTag("CLASSIFIED");
    --
    --inst.AnimState:SetBank('ctf_team_marker');
    --inst.AnimState:SetBuild('ctf_team_marker');
    --inst.AnimState:PlayAnimation('idle');
    --inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround);
    --
    --inst.ctf_owner = net_entity(inst.GUID, 'ctf_owner', 'ctf_owner');
    --inst.ctf_health = net_float(inst.GUID, 'ctf_health', 'ctf_health');
    --
    ----if not TheNet:IsDedicated() then
    ----    inst:ListenForEvent(inst.user_id.event, function()
    ----        CTFPlayer(inst);
    ----    end);
    ----end
    --
    --if TheWorld.ismastersim then
    --    inst:DoTaskInTime(0, function()
    --        local owner = inst.entity:GetParent();
    --        print('============================= ctf_team_marker owner:', owner);
    --        inst.ctf_owner:set(owner);
    --        if owner then
    --            -- do something
    --        end
    --    end);
    --end
    --
    --inst.entity:SetPristine();
    --inst.persists = false;

    local inst = CreateEntity();

    inst.entity:AddTransform();
    inst.entity:AddNetwork();
    inst.entity:AddAnimState();
    --inst.entity:AddFollower();

    --inst.entity:SetCanSleep(false);
    --inst:AddTag("CLASSIFIED");

    inst.AnimState:SetBank('ctf_team_marker');
    inst.AnimState:SetBuild('ctf_team_marker');
    inst.AnimState:PlayAnimation('idle');
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround);

    --inst.ctf_owner = net_entity(inst.GUID, 'ctf_owner', 'ctf_owner');
    --inst.ctf_health = net_float(inst.GUID, 'ctf_health', 'ctf_health');

    inst.entity:SetPristine();
    inst.persists = false;

    return inst;
end

return Prefab('ctf_team_marker', ctf, assets);
