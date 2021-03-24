---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-22 7:03 p.m.
---

local Burnable = require('components/burnable');
local CTFClassPatcher = use('scripts/CTFClassPatcher');

local function smolderUpdate(inst, self, entry)
    entry.currentTick = entry.currentTick + 1;

    -- when raining do half the damage? -- maybe later
    --if TheWorld.state.israining then
    --    -- half the damage, skip a tick
    --end

    if inst.components and inst.components.health then
        if not inst.components.health:IsDead() then
            inst.components.health:DoDelta(-entry.damage, true, entry.cause, true, entry.afflicter, true);
        end

        if inst.components.health:IsDead() then
            self:StopSmoldering();
            self:Ignite();
            return;
        end
    end

    if entry.currentTick >= entry.ticks then
        self.smolder_queue[entry.id]:Cancel();
        self.smolder_queue[entry.id] = nil;
        self.smolder_queue_length = math.max(0, self.smolder_queue_length - 1);
        if self.smolder_queue_length == 0 then
            self:StopSmoldering();
        end
    end
end

CTFClassPatcher(Burnable, function(self, ctor, inst)
    ctor(self, inst);
    self.smolder_queue_length = 0;
    self.smolder_queue = {};
end);

function Burnable:AddSmoldering(ticks, tickTime, tickDamage, cause, afflicter)
    if not (self.burning or self.smoldering or self.inst:HasTag("fireimmune")) then
        self.smoldering = true;
        self.smoke = SpawnPrefab("smoke_plant");
        if self.smoke ~= nil then
            if #self.fxdata == 1 and self.fxdata[1].follow then
                if self.fxdata[1].followaschild then
                    self.inst:AddChild(self.smoke);
                end
                local follower = self.smoke.entity:AddFollower();
                local xoffs, yoffs, zoffs = self.fxdata[1].x, self.fxdata[1].y, self.fxdata[1].z;
                if self.fxoffset ~= nil then
                    xoffs = xoffs + self.fxoffset.x;
                    yoffs = yoffs + self.fxoffset.y;
                    zoffs = zoffs + self.fxoffset.z;
                end
                follower:FollowSymbol(self.inst.GUID, self.fxdata[1].follow, xoffs, yoffs, zoffs);
            else
                self.inst:AddChild(self.smoke);
            end
            self.smoke.Transform:SetPosition(0, 0, 0);
        end
    end

    if self.smoldering then
        local smolder_entry = {
            id = '' .. GetTime(),
            damage = tickDamage,
            ticks = ticks,
            currentTick = 0,
            cause = cause,
            afflicter = afflicter,
        }
        self.smolder_queue[smolder_entry.id] = self.inst:DoPeriodicTask(tickTime, smolderUpdate, nil, self, smolder_entry);
        self.smolder_queue_length = self.smolder_queue_length + 1;
    end
end

function Burnable:StopSmoldering()
    if self.smoldering then
        if self.smoke ~= nil then
            self.smoke.SoundEmitter:KillSound('smolder');
            self.smoke:Remove();
        end

        self.smoldering = false;

        for k, v in pairs(self.smolder_queue) do
            if v then
                v:Cancel();
                self.smolder_queue[k] = nil;
            end
        end
        self.smolder_queue_length = 0;

        if self.onstopsmoldering ~= nil then
            self.onstopsmoldering(self.inst)
        end
    end
end
