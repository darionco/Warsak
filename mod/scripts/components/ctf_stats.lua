---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-15 8:39 p.m.
---

local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

local CTFStats = Class(function(self, inst)
    self.inst = inst;

    self.helpers = {};
    self.attackers = {};

    self.inst:ListenForEvent('attacked', function(_, data) self:handleAttacked(data) end);
    self.inst:ListenForEvent('healthdelta', function(_, data) self:handleHealthDelta(data) end);
    self.inst:ListenForEvent('death', function() self:handleDeath() end);
end);

function CTFStats:handleAttacked(data)
    if data and data.attacker and data.attacker:HasTag('player') then
        self:updateTableEntry(self.attackers, data.attacker.userid);
    end
end

function CTFStats:handleHealthDelta(data)
    if data and data.cause == CTF_TEAM_CONSTANTS.TEAMMATE_HEAL and data.afflicter then
        self:updateTableEntry(self.helpers, data.afflicter.userid);
    end
end

function CTFStats:updateTableEntry(t, id)
    local index = self:findInRelationTable(t, id);
    if index ~= nil then
        t[index].task:Cancel();
        table.remove(t, index);
    end

    table.insert(t, 1,{
        id = id,
        task = self.inst:DoTaskInTime(CTF_TEAM_CONSTANTS.PLAYER_INTERACTION_SPAN, function()
            local i = self:findInRelationTable(t, userid);
            if i ~= nil then
                table.remove(t, i);
            end
        end),
    });
end

function CTFStats:handleDeath()
    -- wait until the next loop so the stats can be gathered
    self.inst:DoTaskInTime(0, function()
        self:clearRelationTable(self.attackers);
        self:clearRelationTable(self.helpers);
    end);
end

function CTFStats:clearRelationTable(t)
    for i, v in pairs(t) do
        v:Cancel();
        t[i] = nil;
    end
end

function CTFStats:findInRelationTable(t, id)
    for i, v in pairs(t) do
        if v.id == id then
            return i;
        end
    end
    return nil;
end

function CTFStats:getAttackers()
    return self:mapRelationTable(self.attackers);
end

function CTFStats:getHelpers()
    return self:mapRelationTable(self.helpers);
end

function CTFStats:mapRelationTable(t)
    local result = {};
    for _, v in pairs(t) do
        table.insert(result, v.id);
    end
    return result;
end

return CTFStats;
