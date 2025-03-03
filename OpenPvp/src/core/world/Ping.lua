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

opvp.PingType = {
    NONE      = 0,
    ATTACK    = 1,
    ASSIST    = 2,
    GENERIC   = 3,
    ON_MY_WAY = 4,
    WARNING   = 5
};

opvp.Ping = opvp.CreateClass();

function opvp.Ping:init(id, name, token)
   self._id = id;
   self._name = name;
   self._token = token;
end

function opvp.Ping:id()
    return self._id;
end

function opvp.Ping:markup()
    if self._id ~= opvp.PingType.NONE then
        return "|A:ping_chat_" .. self._token .. ":0:0:0:0|a";
    else
        return "";
    end
end

function opvp.Ping:name()
    return self._name;
end

opvp.Ping.NONE      = opvp.Ping(opvp.PingType.NONE,      "",          "");
opvp.Ping.ATTACK    = opvp.Ping(opvp.PingType.ATTACK,    "Attack",    "attack");
opvp.Ping.ASSIST    = opvp.Ping(opvp.PingType.ASSIST,    "Look here", "assist");
opvp.Ping.GENERIC   = opvp.Ping(opvp.PingType.GENERIC,   "Look here", "nonthreat");
opvp.Ping.ON_MY_WAY = opvp.Ping(opvp.PingType.ON_MY_WAY, "On my way", "onmyway");
opvp.Ping.WARNING   = opvp.Ping(opvp.PingType.WARNING,   "Warning",   "warning");
