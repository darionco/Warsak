---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-25 12:01 a.m.
---

local Equippable = require('components/equippable_replica');
local CTFClassPatcher = use('scripts/CTFClassPatcher');

CTFClassPatcher(Equippable, function(self, ctor, inst)
    ctor(self, inst);

    self.ctf_cooldown_charged = net_bool(inst.GUID, 'ctf_cooldown_charged', 'ctf_cooldown_charged');
    self.ctf_cooldown_charged:set(false);

    self.ctf_cooldown_time = net_float(inst.GUID, 'ctf_cooldown_time', 'ctf_cooldown_time');
    self.ctf_cooldown_time:set(0);
end);