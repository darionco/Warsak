---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-02 11:54 a.m.
---

-- SUITS
modimport('scripts/prefabs/armour/grass');
modimport('scripts/prefabs/armour/sanity');
modimport('scripts/prefabs/armour/skeleton');
modimport('scripts/prefabs/armour/ruins');
modimport('scripts/prefabs/armour/dragonfly');

-- HATS
modimport('scripts/prefabs/armour/beehat');

local CTF_ARMOUR = use('scripts/constants/CTFArmourConstants');

for k, v in pairs(CTF_ARMOUR) do
    local upper = k:upper();
    local key;
    if v.key then
        key = v.key;
    elseif TUNING[upper] ~= nil then
        key = upper;
    elseif TUNING['ARMOR_' .. upper] then
        key = 'ARMOR_' .. upper;
    else
        print('========================================= CANNOT FIND KEY FOR ' .. upper);
    end

    if key then
        TUNING[key] = v.durability;
        TUNING[key .. '_ABSORPTION'] = v.absorption;
    end
end
