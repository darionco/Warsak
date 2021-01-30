---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-16 4:51 p.m.
---

local require = GLOBAL.require;
local CTF_CONSTANTS = require('teams/CTFTeamConstants');
local CTFTeamCombat = require('teams/CTFTeamCombat');

local function TestWinState(inst, self)
    local player = FindClosestPlayerInRange(
            self.basePosition.x,
            self.basePosition.y,
            self.basePosition.z,
            10, -- range
            true -- is alive
    );
    if player ~= nil then
        local item = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY);
        if item ~= nil and item:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) and not item:HasTag(self.teamTag) then
            c_announce('Team ' .. self.id .. ' wins!');
            c_announce('Game restarting in 10 seconds!');
            TheWorld:DoTaskInTime(10, c_regenerateworld);
            TheWorld:PushEvent(CTF_CONSTANTS.GAME_ENDED);
        end
    end

    self.flag.AnimState:SetMultColour(self:getTeamColor(self.id));
end

local function FindSpawnerTarget(inst, team)
    local spawner = team.minionSpawners[inst.data.ctf_minion_spawner];
    if spawner then
        return spawner:GetPosition();
    end
    return team.basePosition;
end

local function SpawnMinions(inst, team)
    if CTFTeamManager.gameStarted then
        if inst.components and inst.components.health and inst.components.health.currenthealth <= 0 then
            return;
        end

        local instPosition = inst:GetPosition();
        for _, v in ipairs(CTFTeamManager.teams) do
            if v.id ~= team.id then
                local target = FindSpawnerTarget(inst, v);
                local minionPrefab = CTF_CONSTANTS.MINION_PREFABS[(inst.data.ctf_minion_count % 4) + 1];
                local minion = inst.components.childspawner:DoSpawnChild(nil, minionPrefab, 5);
                if minion ~= nil then
                    inst.data.ctf_minion_count = inst.data.ctf_minion_count + 1;
                    local targetVector = {
                        x = target.x - instPosition.x,
                        y = target.y - instPosition.y,
                        z = target.z - instPosition.z,
                    };
                    local targetDistance = math.sqrt(math.pow(targetVector.x, 2) + math.pow(targetVector.y, 2) + math.pow(targetVector.z, 2));
                    local targetNormal = {
                        x = targetVector.x / targetDistance,
                        y = targetVector.y / targetDistance,
                        z = targetVector.z / targetDistance,
                    };

                    minion.Transform:SetPosition(instPosition.x + targetNormal.x * 3, instPosition.y + targetNormal.y * 3, instPosition.z + targetNormal.z * 3);

                    if minion.components.knownlocations then
                        minion.components.knownlocations:RememberLocation("investigate", target);
                    end

                    if minion.components.sleeper then
                        minion.components.sleeper:SetSleepTest(function() return false end);
                    end
                end
            end
        end
    end
end

CTFTeam = Class(function(self, id)
    self.id = id;
    self.teamTag = self:makeTeamTag(self.id);
    self.noTeamTag = self:makeExcludeTag(self.teamTag);
    self.flag = nil;
    self.winTask = nil;
    self.players = {};
    self.minionSpawners = {};
    self.playerCount = 0;
    self.basePosition = {
        x = 0,
        y = 0,
        z = 0,
    };
end);

function CTFTeam:makeTeamTag(id)
    return CTF_CONSTANTS.TEAM_PREFIX_TAG .. id;
end

function CTFTeam:makeExcludeTag(teamTag)
    return CTF_CONSTANTS.EXCLUDE_PREFIX_TAG .. teamTag;
end

function CTFTeam:getTeamColor(id)
    return unpack(CTF_CONSTANTS.TEAM_COLORS[math.min(id, 5)]);
end

function CTFTeam:makeMinionSpawner(obj)
    if obj.components then
        if obj.components.childspawner then
            obj:RemoveComponent('childspawner');
        end

        obj:AddComponent('childspawner');
        TheWorld:ListenForEvent(CTF_CONSTANTS.GAME_STARTED, function()
            SpawnMinions(obj, self);
            obj:DoPeriodicTask(10, SpawnMinions, nil, self);
        end);

        obj:AddTag(CTF_CONSTANTS.TEAM_MINION_SPAWNER_TAG);
    end
end

function CTFTeam:patchPlayerProx(obj)
    if obj.components and obj.components.playerprox then
        local OldOnNear = obj.components.playerprox.onnear;
        local teamTag = self.teamTag;

        obj.components.playerprox:SetTargetMode(function(inst, comp)
            if not comp.isclose then
                local target = CTFTeamCombat.findEnemy(inst, comp.near, teamTag);
                if target ~= nil then
                    comp.isclose = true
                    if comp.onnear ~= nil then
                        comp.onnear(inst, target)
                    end
                end
            elseif not CTFTeamCombat.findEnemy(inst, comp.far, teamTag) then
                comp.isclose = false
                if comp.onfar ~= nil then
                    comp.onfar(inst)
                end
            end
        end);

        obj.components.playerprox:SetOnPlayerNear(function (inst, player)
            if not player:HasTag(teamTag) then
                OldOnNear(inst, player);
            end
        end);
    end
end

function CTFTeam:patchChildSpawner(obj)
    if obj.components and obj.components.childspawner then
        local OldOnSpawned = obj.components.childspawner.onspawned;
        local team = self;
        obj.components.childspawner:SetSpawnedFn(function(inst, child)
            child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
            team:registerObject(child, nil);
            if OldOnSpawned then
                OldOnSpawned(inst, child);
            end
        end);
    end
end

function CTFTeam:patchSpawner(obj)
    if obj.components and obj.components.spawner then
        local OldTakeOwnership = obj.components.spawner.TakeOwnership;
        local team = self;
        obj.components.spawner.TakeOwnership = function(inst, child)
            if inst.child ~= child then
                child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
                team:registerObject(child, nil);
                OldTakeOwnership(inst, child);
            end
        end
        if obj.components.spawner.child then
            obj.components.spawner.child:AddTag(CTF_CONSTANTS.TEAM_MINION_TAG);
            team:registerObject(obj.components.spawner.child, nil);
        end
    end
end

function CTFTeam:patchBuilder(obj, teamTag)
    if obj.components and obj.components.builder then
        local OldOnBuild = obj.components.builder.onBuild;
        obj.components.builder.onBuild = function(inst, prod)
            if prod and (not prod.components or not prod.components.edible) then
                prod:AddTag(CTF_CONSTANTS.TEAM_ITEM_TAG);
                prod:AddTag(teamTag);
            end

            if OldOnBuild then
                OldOnBuild(inst, prod);
            end
        end
    end
end

function CTFTeam:patchCombat(obj, teamTag)
    if obj.components and obj.components.combat then
        obj.components.combat.IsAlly = function(inst, target)
            return target:HasTag(teamTag);
        end

        if obj.components.combat then
            local OldCanTarget = obj.components.combat.CanTarget;
            obj.components.combat.CanTarget = function(inst, target)
                if target and target:HasTag(teamTag) then
                    return false;
                end
                return OldCanTarget(inst, target);
            end
        end

        
        local OldIsValidTarget = obj.components.combat.IsValidTarget;
        obj.components.combat.IsValidTarget = function(inst, target)
            if target then
                if target:HasTag(teamTag) then
                    return false;
                elseif target:HasTag(CTF_CONSTANTS.TEAM_MINION_TAG) then
                    return true;
                end
            end
            return OldIsValidTarget(inst, target);
        end
    end

    if obj.replica and obj.replica.combat then
        local OldCanTarget = obj.replica.combat.CanTarget;
        obj.replica.combat.CanTarget = function(inst, target)
            if target and target:HasTag(teamTag) then
                return false;
            end
            return OldCanTarget(inst, target);
        end
    end
end

function CTFTeam:patchPlayerController(player, teamTag)
    if player.components.playercontroller then
        local OldGetActionButtonAction = player.components.playercontroller.GetActionButtonAction;
        player.components.playercontroller.GetActionButtonAction = function(inst, force_target)
            local result = OldGetActionButtonAction(inst, force_target);
            if result
                    and result.target
                    and ((result.target:HasTag(CTF_CONSTANTS.TEAM_FLAG_TAG) and result.target:HasTag(teamTag))
                    or (result.target:HasTag(CTF_CONSTANTS.TEAM_ITEM_TAG) and not result.target:HasTag(teamTag))) then
                local target = result.target;
                target:AddTag('fire');
                result = OldGetActionButtonAction(inst, force_target)
                target:RemoveTag('fire');
            end
            return result;
        end
    end
end

function CTFTeam:registerObject(obj, data)
    if obj:HasTag(self.teamTag) then
        return;
    end

    if not obj.data then
        obj.data = {};
    end
    obj.data.ctf_team_tag = self.teamTag;
    obj:AddTag(self.teamTag);

    if obj.prefab == CTF_CONSTANTS.TEAM_FLAG_PREFAB then
        self.flag = obj;
        self.flag:AddTag(CTF_CONSTANTS.TEAM_FLAG_TAG);
        self.flag:AddTag(self.noTeamTag);

        self.basePosition = obj:GetPosition();
        self.winTask = self.flag:DoPeriodicTask(0.25, TestWinState, nil, self);
        TheWorld:ListenForEvent(CTF_CONSTANTS.GAME_ENDED, function()
            if self.winTask then
                self.winTask:Cancel();
                self.winTask = nil;
            end
        end);
    end

    if data and data.ctf_minion_spawner then
        obj.data.ctf_minion_spawner = data.ctf_minion_spawner;
        obj.data.ctf_minion_count = 0;
        self.minionSpawners[data.ctf_minion_spawner] = obj;
        self:makeMinionSpawner(obj);
    end

    self:patchPlayerProx(obj);
    self:patchChildSpawner(obj);
    self:patchSpawner(obj);
    self:patchCombat(obj, self.teamTag);

    if obj.AnimState then
        obj.AnimState:SetMultColour(self:getTeamColor(self.id));
    end
end

function CTFTeam:teleportPlayerToBase(player, setStats)
    c_teleport(self.basePosition.x, self.basePosition.y, self.basePosition.z, player);
    if setStats then
        c_supergodmode(player);
        c_maintainsanity(player, 1);
    end
end

function CTFTeam:teleportAllPlayersToBase(setStats)
    for _, v in ipairs(self.players) do
        self:teleportPlayerToBase(v, setStats);
    end
end

function CTFTeam:registerPlayer(player)
    player.components.itemtyperestrictions.ctfTeamTag = self.teamTag;
    player.components.itemtyperestrictions.noCtfTeamTag = self.noTeamTag;

    if not player.data then
        player.data = {};
    end
    player.data.ctf_team_tag = self.teamTag;
    player:AddTag(self.teamTag);
    player:AddTag(CTF_CONSTANTS.TEAM_PLAYER_TAG);

    table.insert(self.players, player);

    self:patchCombat(player, self.teamTag);
    self:patchPlayerController(player, self.teamTag);
    self:patchBuilder(player, self.teamTag);

    self.playerCount = self.playerCount + 1;
    player:ListenForEvent('death', function()
        c_announce(player.name .. ' will revive in 15 seconds');
        player:DoTaskInTime(15, function ()
            self:teleportPlayerToBase(player, false);
            c_godmode(player);
        end);
    end);

    player:ListenForEvent("ms_respawnedfromghost", function ()
        player.components.health:SetPercent(1);
        player.components.sanity:SetPercent(1);
        player.components.hunger:SetPercent(1);
        player.components.moisture:SetPercent(0);
        player.components.temperature:SetTemperature(25);
    end);

    --player:DoPeriodicTask(0.5, function()
        player.AnimState:SetMultColour(self:getTeamColor(self.id));
    --end);

    if player.player_classified and player.player_classified.ctf_net_on_player_team_id then
        player.player_classified.ctf_net_on_player_team_id:set(self.id);
    end

    TheWorld:PushEvent(CTF_CONSTANTS.PLAYER_JOINED_TEAM_EVENT, player, team);
end

function CTFTeam:hasPlayer(player)
    for i, v in ipairs(self.players) do
        if v == player then
            return true;
        end
    end
    return false;
end

function CTFTeam:removePlayer(player)
    for i, v in ipairs(self.players) do
        if v == player then
            c_announce(player.name .. ' has left team ' .. self.id);
            table.remove(self.players, i);
            self.playerCount = self.playerCount - 1;
            TheWorld:PushEvent(CTF_CONSTANTS.PLAYER_LEFT_TEAM_EVENT, player, team);
            return;
        end
    end
end
