-- Copyright (c) 2025, Nathan Dunsworth
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of {{ project }} nor the names of its contributors
--       may be used to endorse or promote products derived from this software
--       without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local _, OpenPvp = ...
local opvp = OpenPvp;

local function cmp_queue_index(a, b)
    return a:queueIndex() < b:queueIndex();
end

opvp.QueueManager = opvp.CreateClass();

function opvp.QueueManager:init()
    self._queues         = opvp.List();
    self._bgs            = opvp.List();
    self._bg_infos       = opvp.List();
    self._active         = nil;
    self._active_index   = 0;
    self._entering_match = false;

    opvp.event.LFG_UPDATE:connect(
        self,
        self._updateLFGStatus
    );

    opvp.event.PLAYER_ENTERING_BATTLEGROUND:connect(
        self,
        self._onMatchEntered
    );

    opvp.event.PVP_ROLE_POPUP_HIDE:connect(
        self,
        self._onPvpRolePopupHide
    );

    opvp.event.PVP_ROLE_POPUP_SHOW:connect(
        self,
        self._onPvpRolePopupShow
    );

    opvp.event.UPDATE_BATTLEFIELD_STATUS:connect(
        self,
        self._updateBattlefieldStatus
    );

    opvp.OnLogin:register(self, self._onLoad);
    opvp.OnReload:register(self, self._onReload);
end

function opvp.QueueManager:active()
    return self._active;
end

function opvp.QueueManager:hasActive()
    return self._active ~= nil;
end

function opvp.QueueManager:hasPending()
    return self._queues:isEmpty() == false;
end

function opvp.QueueManager:index(queue)
    return self._queues:index(queue);
end

function opvp.QueueManager:isEnteringMatch()
    return self._entering_match;
end

function opvp.QueueManager:logPendingStatus()
    for n=1,self._queues:size() do
        self._queues:item(n):logStatus();
    end
end

function opvp.QueueManager:pendingQueues()
    return self._queues:items();
end

function opvp.QueueManager:pendingSize()
    return self._queues:size();
end

function opvp.QueueManager:_addQueue(queue)
    self._queues:append(queue);

    self._queues:sort(cmp_queue_index);
end

function opvp.QueueManager:_convertBattlefieldStatus(status, suspended)
    if status == "queued" then
        if suspended == true then
            return opvp.QueueStatus.SUSPENDED;
        else
            return opvp.QueueStatus.QUEUED;
        end
    elseif status == "confirm" then
        return opvp.QueueStatus.READY;
    elseif status == "active" then
        return opvp.QueueStatus.ACTIVE;
    elseif status == "error" then
        return opvp.QueueStatus.ERROR;
    end

    return opvp.QueueStatus.NOT_QUEUED;
end

function opvp.QueueManager:_convertLFGStatus(status)
    if status == "queued" then
        return opvp.QueueStatus.QUEUED;
    elseif status == "proposal" then
        return opvp.QueueStatus.READY;
    elseif status == "suspended" then
        return opvp.QueueStatus.SUSPENDED;
    elseif status == "lfgparty" then
        return opvp.QueueStatus.ACTIVE;
    elseif status == "abandonedInDungeon" then
        return opvp.QueueStatus.ACTIVE;
    end

    return opvp.QueueStatus.NOT_QUEUED;
end

function opvp.QueueManager:_findBattlegroundInfo(mapName)
    local info;

    for n=1, self._bg_infos:size() do
        info = self._bg_infos:item(n);

        if info:map():name() == mapName then
            return info;
        end
    end

    return nil;
end

function opvp.QueueManager:_findBattlegroundQueue(mapName)
    local info = self:_findBattlegroundInfo(mapName);

    if info ~= nil then
        for n=1, self._bgs:size() do
            queue = self._bgs:item(n);

            if queue:isNull() == true then
                queue:_setInfo(info);

                return queue;
            end
        end
    end

    return nil;
end

function opvp.QueueManager:_findPvpQueue(
    index,
    status,
    queueType,
    gameType,
    registeredMatch,
    isSoloQueue,
    mapName,
    shortDescription,
    longDescription
)
    --~ opvp.printDebug(
        --~ [[\n
            --~ index=%s,
            --~ status=%s,
            --~ queueType=%s,
            --~ gameType=%s,
            --~ registeredMatch=%s,
            --~ isSoloQueue=%s,
            --~ mapName=%s,
            --~ shortDescription=%s,
            --~ longDescription=%s
        --~ ]],
        --~ tostring(index),
        --~ tostring(status),
        --~ tostring(queueType),
        --~ tostring(gameType),
        --~ tostring(registeredMatch),
        --~ tostring(isSoloQueue),
        --~ tostring(mapName),
        --~ tostring(shortDescription),
        --~ tostring(longDescription)
    --~ );

    if mapName == nil then
        mapName = "";
    end

   for n=1, self._queues:size() do
        local q = self._queues:item(n);

        if q:queueIndex() == index then
            return q;
        end
    end

    local queue = nil;

    if registeredMatch == true then
        if queueType == "ARENA" then
            if mapName == CONQUEST_BRACKET_NAME_2V2 then
                queue = opvp.Queue.ARENA_2V2;
            elseif mapName == CONQUEST_BRACKET_NAME_3V3 then
                queue = opvp.Queue.ARENA_3V3;
            elseif mapName == CONQUEST_BRACKET_NAME_SOLO_SHUFFLE then
                queue = opvp.Queue.SHUFFLE;
            end
        elseif queueType == "RATEDSOLORBG" then
            queue = opvp.Queue.BLITZ;
        elseif queueType == "RATEDSHUFFLE" then
            queue = opvp.Queue.SHUFFLE;
        elseif queueType == "ARENASKIRMISH" then
            queue = opvp.Queue.ARENA_SKIRMISH;
        elseif status == opvp.QueueStatus.ACTIVE then
            local index = C_PvP.GetActiveMatchBracket();

            queue = opvp.RatedQueue:fromBracketIndex(index);
        end
    else
        if queueType == "ARENASKIRMISH" then
            queue = opvp.Queue.ARENA_SKIRMISH;
        elseif queueType == "BATTLEGROUND" then
            if mapName == RANDOM_BATTLEGROUND then
                queue = opvp.Queue.RANDOM_BATTLEGROUND;
            elseif mapName == RANDOM_EPIC_BATTLEGROUND or mapName .. "s" == RANDOM_EPIC_BATTLEGROUND then
                queue = opvp.Queue.RANDOM_EPIC_BATTLEGROUND;
            elseif gameType == "Brawl" or mapName == opvp.Queue.BRAWL:name() then
                queue = opvp.Queue.BRAWL;
            elseif gameType == "Limited Time Event" or mapName == opvp.Queue.EVENT:name() then
                queue = opvp.Queue.EVENT;
            elseif C_PvP.IsBattleground() == true then
                if opvp.system.isLoading() == true then
                    local bg_info_size = GetNumBattlegroundTypes();

                    for n=1, bg_info_size do
                        local _, _, _, is_random, _, _, _, max_players = GetBattlegroundInfo(n);

                        if is_random == true then
                            if max_players >= 35 then
                                queue = opvp.Queue.RANDOM_BATTLEGROUND;
                            else
                                queue = opvp.Queue.RANDOM_EPIC_BATTLEGROUND;
                            end

                            break;
                        end
                    end
                end

                if queue == nil then
                    queue = self:_findBattlegroundQueue(mapName);
                end
            else
                queue = self:_findBattlegroundQueue(mapName);
            end
        elseif queueType == "WARGAME" then
            --~
        end
    end

    return queue;
end

function opvp.QueueManager:_initializeBattlegrounds()
    self._bgs:append(opvp.Queue.BATTLEGROUND_1);
    self._bgs:append(opvp.Queue.BATTLEGROUND_2);
    self._bgs:append(opvp.Queue.BATTLEGROUND_3);

    local bg_info_size = GetNumBattlegroundTypes();

    for n=1, bg_info_size do
        self._bg_infos:append(opvp.BattlegroundInfo(n));
    end
end

function opvp.QueueManager:_initializeQueues()
    for n=1,GetMaxBattlefieldID() do
        self:_updateBattlefieldStatus(n)
    end
end

function opvp.QueueManager:_onLoad()
    self:_initializeBattlegrounds();

    self:_initializeQueues();
end

function opvp.QueueManager:_onMatchEntered()
    if self._active == nil and opvp.system.isLoading() == true then
        self:_initializeQueues();
    else
        assert(self._active ~= nil);
    end

    opvp.printDebug(
        "opvp.QueueManager:_onMatchEntered(\"%s\"), begin",
        self._active:name()
    );

    self._active:_onStatusChanged(self._active_index, opvp.QueueStatus.ACTIVE);

    opvp.queue.statusChanged:emit(self._active, opvp.QueueStatus.ACTIVE, opvp.QueueStatus.READY);

    opvp.queue.activeChanged:emit(self._active);

    self._entering_match = false;

    opvp.printDebug(
        "opvp.QueueManager:_onMatchEntered(\"%s\"), end",
        self._active:name()
    );
end

function opvp.QueueManager:_onReload()
    self:_onLoad();
end

function opvp.QueueManager:_onPvpRolePopupHide(info)
    if self._active ~= nil then
        self._active:_onPvpRolePopupHide(info)
    end
end

function opvp.QueueManager:_onPvpRolePopupShow(info)
    if self._active ~= nil then
        self._active:_onPvpRolePopupShow(info)
    end
end

function opvp.QueueManager:_removeQueue(queue)
    self._queues:removeItem(queue);
end

function opvp.QueueManager:_updateBattlefieldStatus(index)
    local status, mapName, teamSize, registeredMatch, suspendedQueue, queueType, gameType, role, asGroup, shortDescription, longDescription, isSoloQueue = GetBattlefieldStatus(index);

    local queue_status = self:_convertBattlefieldStatus(status, suspendedQueue);

    if queue_status == opvp.QueueStatus.ERROR then
        return;
    end

    local queue = self:_findPvpQueue(
        index,
        status,
        queueType,
        gameType,
        registeredMatch,
        isSoloQueue,
        mapName,
        shortDescription,
        longDescription
    );

    if queue == nil then
        return;
    end

    opvp.printDebug(
        "opvp.QueueManager:_updateBattlefieldStatus[%d], %s, %d, %d",
        index,
        queue:name(),
        queue_status,
        queue:status()
    );

    if queue:status() == queue_status then
        return;
    end

    local old_status = queue:status();
    local is_active = queue == self._active;

    self._entering_match = queue_status == opvp.QueueStatus.ACTIVE;

    if (
        queue_status == opvp.QueueStatus.ACTIVE or
        queue_status == opvp.QueueStatus.READY
    ) then
        self._active = queue;
        self._active_index = index;

        --~ We let PLAYER_ENTERING_BATTLEGROUND handle this status
        --~ through opvp.QueueManager:_onMatchEntered()
        if queue_status == opvp.QueueStatus.ACTIVE then
            return;
        end
    elseif is_active == true then
        self._active = queue;
        self._active_index = 0;

        opvp.queue.activeChanged:emit(nil);
    end

    queue:_onStatusChanged(index, queue_status);

    opvp.queue.statusChanged:emit(queue, queue_status, old_status);

    if (
        queue_status == opvp.QueueStatus.NOT_QUEUED and
        opvp.IsInstance(queue, opvp.BattlegroundQueue) == true
    ) then
        queue:_setInfo(opvp.BattlegroundInfo:null());
    end
end

function opvp.QueueManager:_updateLFGStatus()
    local queue = opvp.Queue.BRAWL;

    if queue:isLFG() == false then
        return;
    end

    local mode, submode = GetLFGMode(LE_LFG_CATEGORY_BATTLEFIELD);
    local queue_status = self:_convertLFGStatus(mode);

    opvp.printDebug(
        "opvp.QueueManager:_updateLFGStatus, name=%s, new_status=%d, current_status=%d",
        queue:name(),
        queue_status,
        queue:status()
    );

    --~ Some odd ass reason when you join a queue it will first have a status
    --~ of suspended.  This mucks with the initial join msg workflow so just
    --~ pretend it didnt happen.  Blizz does the same for when you cancel the
    --~ queue as well *sigh*
    if (
        queue:status() == queue_status or
        (
            queue_status == opvp.QueueStatus.SUSPENDED and
            queue:status() == opvp.QueueStatus.NOT_QUEUED
        )
    ) then
        return;
    end

    local old_status = queue:status();

    self._entering_match = queue_status == opvp.QueueStatus.ACTIVE;

    if (
        queue_status == opvp.QueueStatus.ACTIVE or
        queue_status == opvp.QueueStatus.READY
    ) then
        self._active = queue;
        self._active_index = 4;

        --~ We let PLAYER_ENTERING_BATTLEGROUND handle this status
        --~ through opvp.QueueManager:_onMatchEntered()
        if queue_status == opvp.QueueStatus.ACTIVE then
            return;
        end
    elseif is_active == true then
        self._active = queue;
        self._active_index = 0;

        opvp.queue.activeChanged:emit(nil);
    end

    queue:_onStatusChanged(4, queue_status);

    opvp.queue.statusChanged:emit(queue, queue_status, old_status);
end
