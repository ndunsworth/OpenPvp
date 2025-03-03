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

opvp.ChatMessageFilter = opvp.CreateClass();

function opvp.ChatMessageFilter:escapeDigitPattern(msg)
    return string.gsub(msg, "%%d", "%d+");
end

function opvp.ChatMessageFilter:escapeStringPattern(msg)
    return string.gsub(msg, "%%s", "%s+");
end

function opvp.ChatMessageFilter:escapeStringPatternWildcard(msg)
    return string.gsub(msg, "%%s", "%.+");
end

function opvp.ChatMessageFilter:init()
    self._registered = false;
end

function opvp.ChatMessageFilter:connect()
    if self._registered == false then
        self._registered = self:_connect();
    end
end

function opvp.ChatMessageFilter:disconnect()
    if self._registered == true then
        self:_disconnect();

        self._registered = false;
    end
end

function opvp.ChatMessageFilter:isConnected()
    return self._registered;
end

function opvp.ChatMessageFilter:escape(msg)
    return msg:gsub("(%W)", "%%%1");
end

function opvp.ChatMessageFilter:eval(chatFrame, event, msg, ...)
    return false;
end

function opvp.ChatMessageFilter:_connect()
    return false;
end

function opvp.ChatMessageFilter:_disconnect()
end
