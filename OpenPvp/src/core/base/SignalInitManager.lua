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

opvp.SignalInitManager = opvp.CreateClass();

function opvp.SignalInitManager:init(name, signal)
    self._name         = name;
    self._cbs          = {};
    self._signal       = signal;
    self._err_handler  = nil;
    self._has_errors   = false;
    self._reverse      = false;
    self._load_time    = 0;

    self._signal:connect(self, self._onSignal);
end

function opvp.SignalInitManager:activated(...)
    return true;
end

function opvp.SignalInitManager:connect(...)
    self:register(...);
end

function opvp.SignalInitManager:hadErrors()
    return self._has_errors;
end

function opvp.SignalInitManager:name()
    return self._name;
end

function opvp.SignalInitManager:register(...)
    local arg_count = select("#", ...);

    local connection;

    if arg_count == 1 then
        connection = {0, select(1, ...)};
    elseif arg_count == 2 then
        connection = {select(1, ...), select(2, ...)};
    end

    if (
        connection ~= nil and
        connection[1] ~= nil and
        connection[2] ~= nil and
        type(connection[2]) == "function"
    ) then
        table.insert(self._cbs, connection);
    end
end

function opvp.SignalInitManager:runTime()
    return self._load_time;
end

function opvp.SignalInitManager:_emitBegin()
    self._has_errors   = false;
    self._err_handler  = geterrorhandler();
    self._load_time = debugprofilestop();

    seterrorhandler(
        function(...)
            self._has_error = true;

            if self._err_handler ~= nil then
                self._err_handler(...);
            end
        end
    );
end

function opvp.SignalInitManager:_emitEnd()
    self._load_time = (debugprofilestop() - self._load_time) / 1000;

    if self._err_handler ~= nil then
        seterrorhandler(self._err_handler);
    end
end

function opvp.SignalInitManager:_onSignal(...)
    if self:activated(...) == false then
        return;
    end

    self:_emitBegin();

    --~ opvp.printDebug(
        --~ "SignalInitManager(\"%s\") - Starting",
        --~ self._name
    --~ );

    if self._reverse == true then
        for n=#self._cbs, 1, -1 do
            local callback = self._cbs[n];

            opvp.signal_emit(self._name, callback, ...);
        end
    else
        for n=1, #self._cbs do
            local callback = self._cbs[n];

            opvp.signal_emit(self._name, callback, ...);
        end
    end

    self._signal:disconnect(self, self._onSignal);

    --~ opvp.printDebug(
        --~ "SignalInitManager(\"%s\") - Finished",
        --~ self._name
    --~ );

    self:_emitEnd();
end
