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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.Thread = opvp.CreateClass();

function opvp.Thread:yield()
    coroutine.yield(false)
end

function opvp.Thread:init()
    self._thread    = nil;
    self._timer     = nil;
    self._has_error = false;
    self._error     = "";
    self._abort     = false;
    self._func      = false;
    self._interval  = 0;

    self.finished   = opvp.Signal("opvp.Thread.finished");
    self.started    = opvp.Signal("opvp.Thread.started");
end

function opvp.Thread:abort()
    if self:isRunning() == true then
        self._abort = true;
    end
end

function opvp.Thread:error()
    return self._error;
end

function opvp.Thread:exec(func)
    if self:isRunning() == true then
        return;
    end

    self._thread = coroutine.create(
        function() self:_run() end
    );

    self._abort     = false;
    self._has_error = false;
    self._error     = "";
    self._func      = func;

    self._timer = C_Timer.NewTicker(
        self._interval,
        function()
            self:_onResume();
        end
    );

    self.started:emit();
end

function opvp.Thread:hasError()
    return self._has_error;
end

function opvp.Thread:resumeInterval()
    return self._interval;
end

function opvp.Thread:isAborting()
    return self._abort;
end

function opvp.Thread:isRunning()
    return self._thread ~= nil;
end

function opvp.Thread:run()
    if self._func ~= nil then
        self._func()
    end
end

function opvp.Thread:setResumeInterval(interval)
    self._interval = max(0, interval);
end

function opvp.Thread:setError(msg)
    self._has_error = true;
    self._error = msg;
end

function opvp.Thread:_run()
    self:run();

    return true;
end

function opvp.Thread:_onResume()
    local success, result = coroutine.resume(self._thread);

    local cleanup = true;

    if success == true then
        cleanup = result;
    elseif self:hasError() == false then
        self:setError(result);
    end

    if cleanup == true then
        self._timer:Cancel();

        self._abort = false;
        self._timer = nil;

        self.finished:emit();
    end
end
