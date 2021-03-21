---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-21 12:12 p.m.
---

local require = _G.require;
local CTFPlayerStats = require('widgets/CTFPlayerStats');
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

AddClassPostConstruct('widgets/statusdisplays', function(self, owner)
    self.ctfStats = self:AddChild(CTFPlayerStats());
    -- allow space for combined stats
    self.ctfStats:SetPosition(-370, 140, 0);
    self.ctfStats:SetScale(0.85, 0.85);

    local ctfPlayer = CTFTeamManager:getCTFPlayer(owner.userid);
    if ctfPlayer then
        self.ctfStats:setUser(owner.userid);
    else
        self._ctfPlayerHandler = function(_, player)
            if player:getUserID() == owner.userid then
                TheWorld:RemoveEventCallback(CTF_TEAM_CONSTANTS.PLAYER_REGISTERED_EVENT, self._ctfPlayerHandler);
                self.ctfStats:setUser(owner.userid);
            end
        end
        TheWorld:ListenForEvent(CTF_TEAM_CONSTANTS.PLAYER_REGISTERED_EVENT, self._ctfPlayerHandler);
    end
end);