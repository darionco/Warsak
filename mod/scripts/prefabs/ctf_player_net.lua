---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-05 12:01 p.m.
---

local function createNetVar(inst, name, type)
    local key = 'ctf_' .. name;
    inst[name] = { var = type(inst.GUID, key, key), event = key };
end

local function ctf()
    print('============================================ ctf_player_net');
    local inst = CreateEntity();

    inst.entity:AddTransform();
    inst.entity:AddNetwork();
    inst.entity:SetCanSleep(false);
    inst:AddTag("CLASSIFIED");

    createNetVar(inst, 'player', net_entity);
    createNetVar(inst, 'user_id', net_string);
    createNetVar(inst, 'name', net_string);
    createNetVar(inst, 'team_id', net_tinybyte);
    createNetVar(inst, 'spawned', net_event);
    createNetVar(inst, 'ready', net_bool);

    inst.entity:SetPristine();

    return inst;
end

return Prefab('ctf_player_net', ctf);