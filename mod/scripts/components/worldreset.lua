---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-14 2:10 p.m.
---

local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');
local WorldResetTimer = require('widgets/worldresettimer');
local Text = require('widgets/text');

STRINGS.UI.WORLDRESETDIALOG.RESET_MSG = 'Game will restart in: %d';

local OldCTOR = WorldResetTimer._ctor;
WorldResetTimer._ctor = function (self, owner)
    OldCTOR(self, owner);
    self.root:RemoveChild(self.title);
    self.title = self.root:AddChild(Text(TALKINGFONT, 50));
    self.title:SetColour(0, 0, 0, 1);
    self.title:SetPosition(0, 130, 0);
end

WorldResetTimer.UpdateCycles = function(self, _)
    local id = CTFTeamManager.ctf_winning_team_id:value();
    if id then
        self.title:SetString('Team ' .. id .. ' wins!');
        self.title:SetColour(unpack(CTF_TEAM_CONSTANTS.TEAM_COLORS[math.min(id, 5)]));
    else
        self.title:SetString('The game has ended!');
    end
end

local CTFWorldReset = Class(function(self, inst)
    -- Empty class, this components is mostly useless at this point
    self.inst = inst;
    -- test the screen
    --self.inst:DoTaskInTime(20, function()
    --    TheWorld:PushEvent(CTF_TEAM_CONSTANTS.GAME_ENDED, { teamID = 2, teamTag = 'le_tag' });
    --end);
end);

return CTFWorldReset;