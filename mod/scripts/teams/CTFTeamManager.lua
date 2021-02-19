---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 4:45 p.m.
---
modimport('scripts/teams/CTFTeam');

local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local CTFInstructionsPopup = require "screens/CTFInstructionsPopup"

local CTF_RPC = 'CTF::PLAYER';

local function registerPlayer(player)
    print('============== REGISTERING PLAYER: ' .. player.name .. ' ================');
    CTFTeamManager:onWelcomeScreenClosed(player);
end

AddModRPCHandler(CTF_RPC, "ctf_register_player", registerPlayer);

local function showWelcomeScreen(cb)
    GLOBAL.TheFrontEnd:PushScreen(CTFInstructionsPopup(
            'Welcome to Capture the Flag!',
            'The are two teams in this game, each team has a different hue.\nThe goal of the game is to bring the opponent\'s piggyback to your base.\nUse gold to craft weapons, armor and food.\nYou can get gold by defeating enemies.\nSome creatures are your friends, some aren\'t, either way, they all drop gold.\n\nGood luck!',
            {
                {
                    text = "Discord",
                    cb = function()
                        VisitURL('https://discord.gg/2kBJkTaN');
                    end
                },
                {
                    -- Set Text
                    text = "OK",

                    -- Create Callback
                    cb = function()
                        print('OK CLICKED =====================================');
                        GLOBAL.TheFrontEnd:PopScreen();
                        cb();
                    end
                },
                {
                    text = "Video Tutorial",
                    cb = function()
                        VisitURL('https://www.youtube.com/embed/_LN5mRUN6cE?autoplay=1');
                    end
                },
            }
    ));
end

CTFTeamManager = {
    teamCount = 0,
    teams = {},
    gameStarted = false,
    gameStartCount = 0,
};

function CTFTeamManager:registerTeamObject(obj, data)
    if (self.teams[data.ctf_team] == nil) then
        print('Creating CTF team ' .. data.ctf_team);
        table.insert(self.teams, data.ctf_team, CTFTeam(data.ctf_team));
        self.teamCount = self.teamCount + 1;
    end
    self.teams[data.ctf_team]:registerObject(obj, data);
end

function CTFTeamManager:getTeamWithLeastPlayers()
    local minPlayerCount = 9999999;
    local team = nil;
    for _, v in ipairs(self.teams) do
        if v.playerCount < minPlayerCount then
            minPlayerCount = v.playerCount;
            team = v;
        end
    end
    return team;
end

function CTFTeamManager:shouldStartGame()
    -- gameStartCount other than 0 means the game is starting
    if self.gameStarted == false and self.gameStartCount == 0 then
        local totalPlayers = 0;
        for _, v in ipairs(self.teams) do
            totalPlayers = totalPlayers + v.playerCount;
        end
        local minPlayerCount = GetModConfigData('CTF_MIN_PLAYERS_TO_START');
        if totalPlayers >= minPlayerCount then
            return true;
        end
    end
    return false;
end

function CTFTeamManager:gameStartTick()
    if self.gameStartCount > 0 then
        c_announce('Game starting in ' .. self.gameStartCount);
        self.gameStartCount = self.gameStartCount - 1;
        TheWorld:DoTaskInTime(1, function() CTFTeamManager:gameStartTick() end);
    else
        self.gameStartCount = 0;
        self:startGame();
    end
end

function CTFTeamManager:scheduleGameStart()
    if self.gameStarted == false and self.gameStartCount == 0 then
        self.gameStartCount = 5;
        self:gameStartTick();
    end
end

function CTFTeamManager:startGame()
    if self.gameStarted == false and self.gameStartCount == 0 then
        self.gameStarted = true;
        for _, v in ipairs(self.teams) do
            v:teleportAllPlayersToBase();
        end
        TheWorld:PushEvent(CTF_CONSTANTS.GAME_STARTED);
    end
end

function CTFTeamManager:getPlayerTeam(player)
    if player.data and player.data.ctf_team_id ~= nil then
        return self.teams[player.data.ctf_team_id];
    end

    for _, v in ipairs(self.teams) do
        if v:hasPlayer(player) then
            return v;
        end
    end
    return nil;
end

function CTFTeamManager:getObjectTeam(obj)
    if obj.data and obj.data.ctf_team_id ~= nil then
        return self.teams[obj.data.ctf_team_id];
    end
    return nil;
end

function CTFTeamManager:onWelcomeScreenClosed(player)
    if TheWorld.ismastersim then
        if self.gameStarted then
            local team = self:getPlayerTeam(player);
            if team then
                team:teleportPlayerToBase(player);
            end
        elseif self:shouldStartGame() then
            self:scheduleGameStart();
        end
    end
end

function CTFTeamManager:registerPlayer(player)
    if TheWorld.ismastersim then
        local team = self:getTeamWithLeastPlayers();
        if not team then
            c_regenerateworld();
        else
            c_announce(player.name .. ' joins team ' .. team.id);
            team:registerPlayer(player);
            team:setPlayerInvincibility(player, true);
        end
    end

    -- try this again later, but it's not that important
    --player.components.playercontroller:RotRight();

    if not TheWorld.ismastersim then
        showWelcomeScreen(function()
            print('SENDING REMOTE EVENT =====================================');
            SendModRPCToServer(MOD_RPC[CTF_RPC]['ctf_register_player']);
        end);
    elseif TheWorld.ismastersim and player == ThePlayer then
        -- host
        showWelcomeScreen(function()
            registerPlayer(player);
        end);
    end
end

function CTFTeamManager:removePlayer(player)
    for _, v in ipairs(self.teams) do
        v:removePlayer(player);
    end
end
