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

opvp.CombatLogFilter = opvp.CreateClass();

function opvp.CombatLogFilter:init(op)
    self._op = op;
    self._connected = false;
end

function opvp.CombatLogFilter:connect()
    if self._connected == false then
        self._connected = opvp.CombatLogFilterManager:instance():addFilter(self);
    end

    return self._connected;
end

function opvp.CombatLogFilter:disconnect()
    if self._connected == true then
        opvp.CombatLogFilterManager:instance():removeFilter(self);

        self._connected = false;
    end
end

function opvp.CombatLogFilter:eval(info)
    if self._op ~= nil then
        return self._op:eval(info);
    else
        return false;
    end
end

function opvp.CombatLogFilter:isConnected()
    return self._connected;
end

function opvp.CombatLogFilter:op()
    return self._op;
end

function opvp.CombatLogFilter:setOp(op)
    if op == self._op then
        return;
    end

    if (
        op ~= nil and
        opvp.IsInstance(op, opvp.CombatLogLogicalOp) == false
    ) then
        return;
    end

    self._op = op;

    self:_onOpChanged();
end

function opvp.CombatLogFilter:triggered(info)

end

function opvp.CombatLogFilter:_onOpChanged()

end
