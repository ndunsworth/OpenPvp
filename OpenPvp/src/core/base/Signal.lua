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

local null_obj = 0;

local function null_cb(...) end

local null_connection = {null_obj, null_cb};

local function cmp_connection(a, b)
    return a[1] == b[1] and a[2] == b[2];
end

local function signal_emit_dbg(name, connection, ...)
    if connection[1] ~= 0 then
        connection[2](connection[1], ...);
    else
        connection[2](...);
    end
end

local function signal_emit_safe(name, connection, ...)
    local status, err;

    if connection[1] ~= 0 then
        status, err = pcall(connection[2], connection[1], ...);
    else
        status, err = pcall(connection[2], ...);
    end

    if status == false then
        opvp.printWarning(
            "opvp.Signal(\"%s\"):emit, %s",
            name,
            err
        );
    end
end

function opvp.signal_emit(name, connection, ...)
    --~ if opvp.DEBUG == false then
        --~ signal_emit_safe(name, connection, ...);
    --~ else
        signal_emit_dbg(name, connection, ...);
    --~ end
end

opvp.Signal = opvp.CreateClass();

function opvp.Signal:init(name, reverse)
    self._name          = name;
    self._cbs           = opvp.List();
    self._depth         = 0;
    self._needs_cleanup = false;
    self._blocked       = false;
    self._reverse       = reverse == true;
end

function opvp.Signal:block(state)
    if state == self._state then
        return state;
    end

    local old_state = self._blocked;

    self._blocked = state;

    return old_state;
end

function opvp.Signal:connect(...)
    local arg_count = select("#", ...);

    local connection;

    if arg_count == 1 then
        connection = {0, select(1, ...)};

        if opvp.IsInstance(connection[2], opvp.Signal) then
            connection[1] = connection[2];
            connection[2] = connection[2].emit;
        end
    elseif arg_count == 2 then
        connection = {select(1, ...), select(2, ...)};
    end

    if connection[1] == nil or connection[2] == nil or type(connection[2]) ~= "function" then
        opvp.printWarning(debugstack());

        return false;
    end

    if self._cbs:index(connection, cmp_connection) == 0 then
        self._cbs:append(connection);
    end

    return true;
end

function opvp.Signal:depth(...)
    return self._depth;
end

function opvp.Signal:disconnect(...)
    local arg_count = select("#", ...);

    local connection;

    if arg_count == 1 then
        connection = {0, select(1, ...)};

        if opvp.IsInstance(connection[2], opvp.Signal) then
            connection[1] = connection[2];
            connection[2] = connection[2].emit;
        end
    elseif arg_count == 2 then
        connection = {select(1, ...), select(2, ...)};
    end

    if connection[1] == nil or connection[2] == nil or type(connection[2]) ~= "function" then
        return;
    end

    local index = self._cbs:index(connection, cmp_connection);

    if index == 0 then
        return;
    end

    --~ Currently emitting when > 0 so replace the connection with a null.
    --~ The list should remain static in size until executing is complete.
    --~ New connections are fine but wont be executed until the next emit.
    if self._depth > 0 then
        self._cbs:replaceIndex(index, null_connection)

        self._needs_cleanup = true;
    else
        self._cbs:removeIndex(index);
    end
end

function opvp.Signal:disconnectAll(reciever)
    if reciever == nil then
        if self._depth == 0 then
            self._cbs:clear();
        else
            for n=1, self._cbs:size() do
                self._cbs:replaceIndex(n, null_connection);
            end
        end
    else
        local cb;

        if self._depth == 0 then
            local n = 1;

            while n <= self._cbs:size() do
                cb = self._cbs:item(n);

                if cb[1] == reciever or cb[2] == reciever then
                    self._cbs:replaceIndex(n, null_connection);
                else
                    n = n + 1;
                end
            end
        else
            for n=1, self._cbs:size() do
                cb = self._cbs:item(n);

                if cb[1] == reciever or cb[2] == reciever then
                    self._cbs:replaceIndex(n, null_connection);
                end
            end
        end
    end
end

function opvp.Signal:emit(...)
    if self._block == true or self._cbs:isEmpty() == true then
        return;
    end

    if self._depth == 0 and self._needs_cleanup == true then
        self:_cleanup();
    end

    self._depth = self._depth + 1;

    local max_index = self._cbs:size();

    local status, err;

    --~ opvp.printDebug(
        --~ "opvp.Signal(\"%s\"), begin",
        --~ self._name
    --~ );

    if self._reverse == false then
        for n=1, max_index do
            local callback = self._cbs:item(n);

            opvp.signal_emit(self._name, callback, ...);
        end
    else
        for n=max_index, 1, -1 do
            local callback = self._cbs:item(n);

            opvp.signal_emit(self._name, callback, ...);
        end
    end

    --~ opvp.printDebug(
        --~ "opvp.Signal(\"%s\"), end",
        --~ self._name
    --~ );

    self._depth = self._depth - 1;
end

function opvp.Signal:hasConnections()
    return self._cbs:isEmpty() == false;
end

function opvp.Signal:isBlocked()
    return self._block;
end

function opvp.Signal:isConnected(...)
    local connection;

    if arg_count == 1 then
        connection = {0, select(1, ...)};
    elseif arg_count == 2 then
        connection = {select(1, ...), select(2, ...)};
    else
        return false
    end

    return self._cbs:index(connection, cmp_connection) ~= 0;
end

function opvp.Signal:isEmitting()
    return self._depth > 0;
end

function opvp.Signal:name()
    return self._name;
end

function opvp.Signal:size()
    return self._cbs:size();
end

function opvp.Signal:_cleanup()
    local index = self._cbs:index(null_connection);

    while index > 0 do
        self._cbs:removeIndex(index);

        index = self._cbs:index(null_connection);
    end

    self._needs_cleanup = false;
end
