---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-21 1:38 p.m.
---

local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local PlayerStatusScreen = require('screens/playerstatusscreen');

local OldGetDisplayName = PlayerStatusScreen.GetDisplayName;
PlayerStatusScreen.GetDisplayName = function(self, clientrecord)
    local result = OldGetDisplayName(self, clientrecord);
    local player = CTFTeamManager:findPlayer(clientrecord.prefab, clientrecord.userid);
    if player and player.data and player.data.ctf_team_id then
        -- patch the client color here
        clientrecord.colour = CTF_CONSTANTS.TEAM_COLORS[player.data.ctf_team_id];
        return '[T' .. player.data.ctf_team_id .. '] ' .. result;
    end

    return result;
end