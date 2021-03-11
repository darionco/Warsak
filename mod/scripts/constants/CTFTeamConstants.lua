---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-22 3:58 p.m.
---

local CTF_TEAM_CONSTANTS = {
    EXCLUDE_PREFIX_TAG = 'CTF_EXCLUDE_',

    MINION_PREFABS = { 'spider', 'spider', 'spider', 'spider_warrior' },

    ITEM_LOCKED_TAG = 'CTF_ITEM_LOCKED',

    TEAM_FLAG_GUARD_PREFAB = 'bishop_nightmare',
    TEAM_FLAG_PREFAB = 'piggyback',
    TEAM_FLAG_WALK_SPEED_MULT = 0.45,

    TEAM_PREFIX_TAG = 'CTF_TEAM_',
    TEAM_FLAG_TAG = 'CTF_TEAM_FLAG',
    TEAM_ITEM_TAG = 'CTF_TEAM_ITEM',
    TEAM_PLAYER_TAG = 'CTF_TEAM_PLAYER',
    TEAM_OBJECT_TAG = 'CTF_TEAM_MINION',
    TEAM_MINION_TAG = 'CTF_TEAM_MINION',
    TEAM_MINION_SPAWNER_TAG = 'CTF_TEAM_MINION_SPAWNER',

    TEAM_COLORS = {
        { 0.666, 0.407, 0.784, 1 },
        { 0.996, 1, 0.454, 1 },
        { 0.403, 0.756, 0.764, 1 },
        { 0.996, 0.674, 0.407, 1 },
        { 1, 0, 1, 1 },
    },

    PLAYER_CONNECTED_EVENT = 'CTF_PLAYER_CONNECTED',
    PLAYER_DISCONNECTED_EVENT = 'CTF_PLAYER_DISCONNECTED',
    PLAYER_JOINED_TEAM_EVENT = 'CTF_PLAYER_JOINED_TEAM',
    PLAYER_LEFT_TEAM_EVENT = 'CTF_PLAYER_LEFT_TEAM',

    GAME_STARTED = 'CTF_GAME_STARTED',
    GAME_ENDED = 'CTF_GAME_ENDED',

    WASPHIVE_HEALTH = 500,

    RPC_NAMESPACE = 'CTF::RPC::NAMESPACE';
    RPC = {
        PLAYER_JOINED_CTF = 'CTF::RPC::PLAYER::JOIN';
    }
}

return CTF_TEAM_CONSTANTS;
