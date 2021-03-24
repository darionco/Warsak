---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-07 11:13 p.m.
---

local require = _G.require;
local LootDropper = require('components/lootdropper');

local LOOT_TABLE = {
    bishop_nightmare = { gold = 5 },
    killerbee = { gold = 1 },
    merm = { gold = 6 },
    pigguard = { gold = 4 },
    spider = { gold = 1 },
    spider_warrior = { gold = 2 },
    spiderden = { gold = 4 },
    spiderqueen = { gold = 20 },
    tallbird = { gold = 3 },
    wasphive = { gold = 4 },
    skeleton_player = { gold = 5 },
    molebat = { gold = 2 },
    koalefant_summer = { gold = 40 },
};

LootDropper.DropLoot = function(self, pt)
    local prefabs;
    if self.inst and self.inst.prefab and LOOT_TABLE[self.inst.prefab] then
        prefabs = LOOT_TABLE[self.inst.prefab];
    else
        prefabs = { gold =  1 };
    end

    if prefabs.gold then
        for _ = 1, prefabs.gold do
            self:SpawnLootPrefab('goldnugget', pt)
        end
    end

    if prefabs.other then
        for _, v in ipairs(prefabs.other) do
            self:SpawnLootPrefab(v, pt)
        end
    end

    TheWorld:PushEvent("entity_droploot", { inst = self.inst });
end
