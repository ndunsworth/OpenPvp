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

opvp.Timer = opvp.CreateClass();

function opvp.Timer:runNextFrame(callback)
    opvp.Timer:singleShot(0, callback);
end

function opvp.Timer:singleShot(interval, callback)
    C_Timer.After(interval, callback);
end

function opvp.Timer:init(interval)
    self._timer = nil;
    self._interval = 0;
    self._count = 0;
    self._limit = -1;
    self._last_trigger = 0;

    if opvp.is_number(interval) == true then
        self._interval = max(0, interval);
    end

    self.timeout = opvp.Signal("opvp.Timer.timeout");
end

function opvp.Timer:interval()
    return self._interval;
end

function opvp.Timer:isActive()
    return self._timer ~= nil;
end

function opvp.Timer:isSingleShot()
    return self._limit == 1;
end

function opvp.Timer:remainingTime()
    if self:isActive() == true then
        return max(0, self._interval - (GetTime() - self._last_trigger));
    else
        return -1;
    end
end

function opvp.Timer:remainingTriggers()
    return self._count;
end

function opvp.Timer:restart(interval)
    self:stop();

    if interval ~= nil then
        self:setInterval(interval);
    end

    self:start();
end

function opvp.Timer:setInterval(interval)
    if opvp.is_number(interval) == false then
        return;
    end

    local new_interval = tonumber(interval);

    if self:isActive() == true then
        self:stop();

        self._interval = new_interval;

        self:start();
    else
        self._interval = new_interval;
    end
end

function opvp.Timer:setTriggerLimit(limit)
    if limit <= 0 then
        self._limit = -1;
    else
        self._limit = limit;
    end

    self._count = self._limit;
end

function opvp.Timer:start()
    if self:isActive() == true then
        return;
    end

    self._last_trigger = 0;
    self._count = self._limit;

    if self._limit == 1 then
        self._timer = C_Timer.NewTimer(
            self._interval,
            function(obj)
                if obj == self._timer then
                    self:_onTriggered();
                end
            end
        );
    elseif self._limit > -1 then
        self._timer = C_Timer.NewTicker(
            self._interval,
            function(obj)
                if obj == self._timer then
                    self:_onTriggered();
                end
            end,
            self._limit
        );
    else
        self._timer = C_Timer.NewTicker(
            self._interval,
            function(obj)
                if obj == self._timer then
                    self:_onTriggered();
                end
            end
        );
    end
end

function opvp.Timer:stop()
    if self:isActive() == false then
        return;
    end

    self._timer:Cancel();

    self._timer = nil;
end

function opvp.Timer:triggerLimit()
    return self._limit;
end

function opvp.Timer:triggered()
    self.timeout:emit();
end

function opvp.Timer:_onTriggered()
    self._last_trigger = GetTime();

    if self._limit > -1 then
        self._count = self._count - 1;

        if self._count == 0 then
            self._timer = nil;
        end
    end

    self:triggered();
end
