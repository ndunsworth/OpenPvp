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

opvp.QueueStatus = {
   ERROR      = -1,
   NOT_QUEUED = 0,
   ROLE_CHECK = 1,
   QUEUED     = 2,
   SUSPENDED  = 3,
   READY      = 4,
   ACTIVE     = 5,
};

opvp.Queue = opvp.CreateClass();

function opvp.Queue:init(id, mask)
    self._id                   = id;
    self._mask                 = mask;
    self._queue_index          = 0;
    self._queue_time           = 0;
    self._status               = opvp.QueueStatus.NOT_QUEUED;
    self._ready_check          = false;
    self._ready_check_attempts = 0;
    self._ready_check_accepted = 0;
    self._ready_check_declined = 0;
    self._ready_check_size     = 0;

    self.statusChanged = opvp.Signal("opvp.Queue.queueStatusChanged");
end

function opvp.Queue:bonusRoles()
    return {};
end

function opvp.Queue:canQueue()
    return false;
end

function opvp.Queue:confirmExpiration()
    return 0;
end

function opvp.Queue:description()
    return self:name();
end

function opvp.Queue:hasDailyWin()
    return false;
end

function opvp.Queue:hasMinimumItemLevel()
    return false;
end

function opvp.Queue:hasReadyCheck()
    return false;
end

function opvp.Queue:hasRoleBonus(roleType)
    local roles = self:bonusRoles();

    for n=1, #roles do
        if roles[n]:id() == roleType then
            return true;
        end
    end

    return false;
end

function opvp.Queue:id()
    return self._id;
end

function opvp.Queue:isActive()
    return self._status == opvp.QueueStatus.ACTIVE;
end

function opvp.Queue:isLFG()
    return false;
end

function opvp.Queue:isPve()
    return false;
end

function opvp.Queue:isPvp()
    return false;
end

function opvp.Queue:isPaused()
    return self._status == opvp.QueueStatus.SUSPENDED;
end

function opvp.Queue:isQueued()
    return self._status > opvp.QueueStatus.ROLE_CHECK;
end

function opvp.Queue:isReady()
    return self._status == opvp.QueueStatus.READY;
end

function opvp.Queue:isReadyCheck()
    return self._ready_check;
end

function opvp.Queue:readyCheckAccepted()
    return self._ready_check_accepted;
end

function opvp.Queue:readyCheckAttempts()
    return self._ready_check_attempts;
end

function opvp.Queue:readyCheckDeclined()
    return self._ready_check_declined;
end

function opvp.Queue:readyCheckPending()
    return (
        self._ready_check_size - (
            self._ready_check_accepted +
            self._ready_check_declined
        )
    );
end

function opvp.Queue:readyCheckSize()
    return self._ready_check_size;
end

function opvp.Queue:logStatus()
    local elapsed = self:queueTimeElapsed();
    local estimate = self:queueTimeEstimated();

    self:_logStatus(
        self._status,
        self._status,
        elapsed,
        estimate,
        true
    );
end

function opvp.Queue:manager()
    return opvp.match.manager();
end

function opvp.Queue:map()
    return opvp.Map.UNKNOWN;
end

function opvp.Queue:mask()
    return self._mask;
end

function opvp.Queue:maximumPlayerLevel()
    return GetMaxLevelForPlayerExpansion();
end

function opvp.Queue:minimumItemLevel()
    return 0;
end

function opvp.Queue:minimumPlayerLevel()
    return GetMaxLevelForPlayerExpansion();
end

function opvp.Queue:name()
    return "";
end

function opvp.Queue:queueIndex()
    return self._queue_index;
end

function opvp.Queue:queueTime()
    return self._queue_time;
end

function opvp.Queue:queueTimeElapsed()
    if self._queue_time > 0 then
        return GetTime() - self._queue_time;
    else
        return 0;
    end
end

function opvp.Queue:queueTimeEstimated()
    return 0;
end

function opvp.Queue:status()
    return self._status;
end

function opvp.Queue:updateInfo()
end

function opvp.Queue:_logStatus(newStatus, oldStatus, elapsed, estimate, override)
    local msg = "";
    local valid = false;

    if newStatus == opvp.QueueStatus.ROLE_CHECK then
        msg = opvp.strs.QUEUE_ROLE_CHECK:format(self:name());
    elseif newStatus == opvp.QueueStatus.NOT_QUEUED then
        if (
            oldStatus ~= opvp.QueueStatus.NOT_QUEUED and
            oldStatus ~= opvp.QueueStatus.ACTIVE
        ) then
            if elapsed > 1 then
                msg = opvp.strs.QUEUE_CANCELED_WITH_WAIT_TIME:format(
                    self:name(),
                    opvp.time.formatSeconds(elapsed)
                );
            else
                msg = opvp.strs.QUEUE_CANCELED:format(
                    self:name()
                );
            end

            valid = opvp.options.announcements.queue.joinLeave:value();
        end
    elseif newStatus == opvp.QueueStatus.QUEUED then
        if oldStatus == opvp.QueueStatus.SUSPENDED then
            if elapsed > 1 then
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_RESUMED_WITH_WAIT_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_RESUMED_WITH_WAIT_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed)
                    );
                end
            else
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_RESUMED_WITH_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_RESUMED:format(self:name());
                end
            end

            valid = opvp.options.announcements.queue.joinLeave:value();
        elseif oldStatus == opvp.QueueStatus.READY then
            if elapsed > 1 then
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_REJOINED_WITH_WAIT_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_REJOINED_WITH_WAIT_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed)
                    );
                end
            else
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_REJOINED_WITH_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_REJOINED:format(
                        self:name()
                    );
                end
            end

            valid = opvp.options.announcements.queue.joinLeave:value();
        else
            if elapsed > 1 then
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_JOINED_WITH_WAIT_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_JOINED_WITH_WAIT_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(elapsed)
                    );
                end
            else
                if estimate > 0 then
                    msg = opvp.strs.QUEUE_JOINED_WITH_EST_TIME:format(
                        self:name(),
                        opvp.time.formatSeconds(estimate)
                    );
                else
                    msg = opvp.strs.QUEUE_JOINED:format(self:name());
                end
            end

            valid = opvp.options.announcements.queue.joinLeave:value();
        end
    elseif newStatus == opvp.QueueStatus.READY then
        if elapsed > 1 then
            if self._ready_check_attempts > 0 then
                msg = opvp.strs.QUEUE_READY_WITH_WAIT_TIME_FAILED:format(
                    self:name(),
                    opvp.time.formatSeconds(elapsed),
                    self._ready_check_attempts
                );
            else
                msg = opvp.strs.QUEUE_READY_WITH_WAIT_TIME:format(
                    self:name(),
                    opvp.time.formatSeconds(elapsed)
                );
            end
        else
            msg = opvp.strs.QUEUE_READY:format(self:name());
        end

        valid = opvp.options.announcements.queue.ready:value() == true;
    elseif newStatus == opvp.QueueStatus.SUSPENDED then
        if elapsed > 1 then
            msg = opvp.strs.QUEUE_SUSPENDED_WITH_WAIT_TIME:format(
                self:name(),
                opvp.time.formatSeconds(elapsed)
            );
        else
            msg = opvp.strs.QUEUE_SUSPENDED:format(self:name());
        end

        valid = opvp.options.announcements.queue.suspended:value();
    end

    if msg ~= "" then
        if valid == true or override == true then
            opvp.printMessage(msg);
        else
            opvp.printDebug(msg);
        end
    end
end

function opvp.Queue:_onReadyCheckBegin()
    self._ready_check = true;

    if self._ready_check_accepted > 0 then
        opvp.printMessageOrDebug(
            opvp.options.announcements.queue.readyCheck:value(),
            opvp.strs.QUEUE_READY_CHECK,
            self:name(),
            self._ready_check_accepted,
            self._ready_check_size
        );
    end

    opvp.queue.readyCheckBegin:emit(self);
end

function opvp.Queue:_onReadyCheckEnd()
    local msg;

    if self._ready_check_declined == 0 then
        msg = opvp.strs.QUEUE_READY_CHECK;
    else
        self._ready_check_attempts = self._ready_check_attempts + 1;

        msg = opvp.strs.QUEUE_READY_CHECK_FAILED;
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.queue.readyCheck:value(),
        msg,
        self:name(),
        self._ready_check_accepted,
        self._ready_check_size
    );

    self._ready_check = false;

    opvp.queue.readyCheckEnd:emit(self);
end

function opvp.Queue:_onReadyCheckUpdate()
    opvp.printMessageOrDebug(
        opvp.options.announcements.queue.readyCheck:value(),
        opvp.strs.QUEUE_READY_CHECK,
        self:name(),
        self._ready_check_accepted,
        self._ready_check_size
    );

    opvp.queue.readyCheckUpdate:emit(self);
end

function opvp.Queue:_onStatusActive()

end

function opvp.Queue:_onStatusJoin()

end

function opvp.Queue:_onStatusLeave()
    self._queue_time = 0;
    self._ready_check_attempts = 0;
end

function opvp.Queue:_onStatusReady()

end

function opvp.Queue:_onStatusRoleCheck()

end

function opvp.Queue:_onStatusSuspended()

end

function opvp.Queue:_setQueueIndex(index)
    if index == self._queue_index then
        return;
    end

    local old_index = self._queue_index;

    self._queue_index = index;

    if old_index == 0 and self._queue_index ~= 0 then
        opvp.queue.manager():_addQueue(self);
    elseif old_index ~= 0 and self._queue_index == 0 then
        opvp.queue.manager():_removeQueue(self);
    end
end

function opvp.Queue:_setStatus(status)
    if status == self._status then
        return;
    end

    local old_status = self._status;

    self._status = status;

    if status == opvp.QueueStatus.NOT_QUEUED then
        self:_onStatusLeave();
    elseif status == opvp.QueueStatus.ROLE_CHECK then
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

    self.statusChanged:emit(status, old_status);
end
