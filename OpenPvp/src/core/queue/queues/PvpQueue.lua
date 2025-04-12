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

opvp.PvpQueue = opvp.CreateClass(opvp.Queue);

function opvp.PvpQueue:init(id, pvpType, mask)
    opvp.Queue.init(self, id, mask);

    self._type = pvpType;
end

function opvp.PvpQueue:bracket()
    return nil;
end

function opvp.PvpQueue:confirmExpiration()
    if self:isReady() == true then
        return GetBattlefieldPortExpiration(self._queue_index);
    else
        return 0;
    end
end

function opvp.PvpQueue:hasDampening()
    return bit.band(self._mask, opvp.PvpFlag.DAMPENING) ~= 0;
end

function opvp.PvpQueue:hasEnlistmentBonus()
    return false;
end

function opvp.PvpQueue:isArena()
    return self._type == opvp.PvpType.ARENA;
end

function opvp.PvpQueue:isBattleground()
    return self._type == opvp.PvpType.BATTLEGROUND;
end

function opvp.PvpQueue:isBattlegroundEpic()
    return (
        self._type == opvp.PvpType.BATTLEGROUND and
        bit.band(self._mask, opvp.PvpFlag.EPIC) ~= 0
    );
end

function opvp.PvpQueue:isBrawl()
    return bit.band(self._mask, opvp.PvpFlag.BRAWL) ~= 0;
end

function opvp.PvpQueue:isBlitz()
    return (
        self._type == opvp.PvpType.BATTLEGROUND and
        bit.band(self._mask, opvp.PvpFlag.BLITZ) ~= 0
    );
end

function opvp.PvpQueue:isDisabled()
    return not self:isEnabled();
end

function opvp.PvpQueue:isEnabled()
    return true;
end

function opvp.PvpQueue:isEvent()
    return bit.band(self._mask, opvp.PvpFlag.EVENT) ~= 0;
end

function opvp.PvpQueue:isMapRandom()
    return bit.band(self._mask, opvp.PvpFlag.RANDOM_MAP) ~= 0;
end

function opvp.PvpQueue:isPvp()
    return true;
end

function opvp.PvpQueue:isRandom()
    return bit.band(self._mask, opvp.PvpFlag.RANDOM) ~= 0;
end

function opvp.PvpQueue:isRated()
    return bit.band(self._mask, opvp.PvpFlag.RATED) ~= 0;
end

function opvp.PvpQueue:isRBG()
    return bit.band(self._mask, opvp.PvpFlag.RBG) ~= 0;
end

function opvp.PvpQueue:isRoundBased()
    return bit.band(self._mask, opvp.PvpFlag.ROUND) ~= 0;
end

function opvp.PvpQueue:isShuffle()
    return bit.band(self._mask, opvp.PvpFlag.SHUFFLE) ~= 0;
end

function opvp.PvpQueue:isSkirmish()
    return false;
end

function opvp.PvpQueue:pvpType()
    return self._type;
end

function opvp.PvpQueue:queueTime()
    return self._queue_time;
end

function opvp.PvpQueue:queueTimeElapsed()
    if self._status == opvp.QueueStatus.QUEUED and self._queue_index ~= 0 then
        local wait_time;

        if self:isLFG() == true then
            local hasData,
            leaderNeeds,
            tankNeeds,
            healerNeeds,
            dpsNeeds,
            totalTanks,
            totalHealers,
            totalDPS,
            instanceType,
            instanceSubType,
            instanceName,
            averageWait,
            tankWait,
            healerWait,
            dpsWait,
            myWait,
            queuedTime,
            activeID = GetLFGQueueStats(LE_LFG_CATEGORY_BATTLEFIELD);

            if queuedTime ~= nil then
                wait_time = GetTime() - queuedTime;
            end
        else
            wait_time = GetBattlefieldTimeWaited(self._queue_index) / 1000;
        end

        if opvp.is_number(wait_time) == true then
            return wait_time;
        else
            return 0
        end
    elseif self._queue_time ~= 0 then
        return GetTime() - self._queue_time;
    end

    return 0;
end

function opvp.PvpQueue:queueTimeEstimated()
    if self._status == opvp.QueueStatus.QUEUED and self._queue_index ~= 0 then
        if self:isLFG() == true then
            local hasData,
            leaderNeeds,
            tankNeeds,
            healerNeeds,
            dpsNeeds,
            totalTanks,
            totalHealers,
            totalDPS,
            instanceType,
            instanceSubType,
            instanceName,
            averageWait,
            tankWait,
            healerWait,
            dpsWait,
            myWait,
            queuedTime,
            activeID = GetLFGQueueStats(LE_LFG_CATEGORY_BATTLEFIELD);

            if opvp.is_number(myWait) then
                return myWait;
            else
                return 0;
            end
        else
            return GetBattlefieldEstimatedWaitTime(self._queue_index) / 1000;
        end
    else
        return 0;
    end
end

function opvp.PvpQueue:teamSizeMaximum()
    return 1;
end

function opvp.PvpQueue:teamSizeMinimum()
    return self:teamSizeMaximum();
end

function opvp.PvpQueue:_createMatch(map, isTest)
    if map == nil or map:isValid() == false then
        return nil;
    end

    local desc = self:_createMatchDescription(map);

    if desc ~= nil then
        return desc:createMatch(self);
    else
        return nil;
    end
end

function opvp.PvpQueue:_createMatchDescription(map)
    return nil;
end

function opvp.PvpQueue:_onPvpRolePopupHide(info)
    if self._ready_check == false then
        return;
    end

    self._ready_check_accepted = info.numPlayersAccepted;
    self._ready_check_declined = info.numPlayersDeclined;

    self:_onReadyCheckEnd();
end

function opvp.PvpQueue:_onPvpRolePopupShow(info)
    if self._ready_check == false then
        if info.totalNumPlayers == 0 then
            self._ready_check_size = self:teamSizeMaximum();

            self._ready_check_accepted = self._ready_check_size;
            self._ready_check_declined = 0;

            self:_onReadyCheckBegin();

            self:_onReadyCheckEnd();
        else
            self._ready_check_size = info.totalNumPlayers;

            self._ready_check_accepted = info.numPlayersAccepted;
            self._ready_check_declined = info.numPlayersDeclined;

            self:_onReadyCheckBegin();
        end
    else
        if info.totalNumPlayers == 0 then
            self._ready_check_accepted = self._ready_check_size;
            self._ready_check_declined = 0;

            self:_onReadyCheckEnd();
        else
            self._ready_check_accepted = info.numPlayersAccepted;
            self._ready_check_declined = info.numPlayersDeclined;

            self:_onReadyCheckUpdate();
        end
    end
end

function opvp.PvpQueue:_onStatusChanged(index, status)
    if status == self._status then
        return;
    end

    local old_status = self._status;
    local elapsed = 0;
    local estimate = 0;

    if old_status ~= opvp.QueueStatus.NOT_QUEUED then
        if self._queue_time > 0 then
            elapsed = GetTime() - self._queue_time;
        end

        estimate = self:queueTimeEstimated();
    end

    if status == opvp.QueueStatus.NOT_QUEUED then
        self:_setQueueIndex(0);

        self:_onStatusLeave();
    else
        self:_setQueueIndex(index);

        if self._queue_time == 0 then
            if self:isLFG() == true then
                local hasData,
                leaderNeeds,
                tankNeeds,
                healerNeeds,
                dpsNeeds,
                totalTanks,
                totalHealers,
                totalDPS,
                instanceType,
                instanceSubType,
                instanceName,
                averageWait,
                tankWait,
                healerWait,
                dpsWait,
                myWait,
                queuedTime,
                activeID = GetLFGQueueStats(LE_LFG_CATEGORY_BATTLEFIELD);

                if queuedTime ~= nil and opvp.system.isReload() == true then
                    self._queue_time = queuedTime + myWait;
                end
            else
                self._queue_time = GetBattlefieldTimeWaited(index) / 1000;
            end

            self._queue_time = GetTime() - self._queue_time;
        end

        if status == opvp.QueueStatus.ROLE_CHECK then
            self:_onStatusRoleCheck();
        elseif status == opvp.QueueStatus.QUEUED then
            self:_onStatusJoin();
        elseif status == opvp.QueueStatus.ACTIVE then
            self:_onStatusActive();
        elseif status == opvp.QueueStatus.READY then
            self:_onStatusReady();
        elseif status == opvp.QueueStatus.SUSPENDED then
            self:_onStatusSuspended();
        else
            return;
        end
    end

    self:_logStatus(
        self._status,
        old_status,
        elapsed,
        estimate
    );

    self.statusChanged:emit(status, old_status);
end

function opvp.PvpQueue:_onStatusJoin()
    --~ stupid when a bg is finished it goes from active to queued again
    --~ that or i have a bug :x
    if self._status ~= opvp.QueueStatus.ACTIVE then
        self._status = opvp.QueueStatus.QUEUED;
    end
end

function opvp.PvpQueue:_onStatusLeave()
    opvp.Queue._onStatusLeave(self);
end
