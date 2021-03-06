---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-04 5:09 p.m.
---

local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

local function addPlayerNetFunctions(inst)
    inst.addPlayerNetVars = function(self, userid)
        print('=================================================== addPlayerNetVars', userid);
        local spawn_event_key = 'ctf_spawn_event.' .. userid;
        local team_id_key = 'ctf_team_id.' .. userid;
        local ready_key = 'ctf_ready.' .. userid;

        local ret = {
            inst = self,
            spawn_event = { var = net_event(self.GUID, spawn_event_key), event = spawn_event_key },
            team_id = { var = net_tinybyte(self.GUID, team_id_key, team_id_key), event = team_id_key },
            ready = { var = net_bool(self.GUID, ready_key, ready_key), event = ready_key },
        };

        ret.team_id.var:set(0);
        ret.ready.var:set(false);

        return ret;
    end
end

AddModRPCHandler(CTF_TEAM_CONSTANTS.RPC_NAMESPACE, CTF_TEAM_CONSTANTS.RPC.PLAYER_JOINED_CTF, function(player)
    local ctfPlayer = CTFTeamManager:getCTFPlayer(player.userid);
    if ctfPlayer then
        ctfPlayer:setReady(true);
    end
end);

AddPrefabPostInit('forest_network', function(inst)
    addPlayerNetFunctions(inst);
    CTFTeamManager:initNet(inst);
end);
