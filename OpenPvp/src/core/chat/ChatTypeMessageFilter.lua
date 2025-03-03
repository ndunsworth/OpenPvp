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

opvp.ChatTypeMessageFilter = opvp.CreateClass(opvp.ChatMessageFilter);

function opvp.ChatTypeMessageFilter:init(chatType, msgs, escape)
    opvp.ChatMessageFilter.init(self);

    self._chat_type  = chatType;
    self._msgs       = opvp.List();

    if msgs ~= nil and opvp.is_table(msgs) then
        for n=1, #msgs do
            self:addMessage(msgs[n], escape);
        end
    end
end

function opvp.ChatTypeMessageFilter:addMessage(msg, escape)
    if opvp.is_str(msg) == false then
        return;
    end

    if escape == true then
        msg = self:escape(msg);
    end

    if self._msgs:contains(msg) == false then
        self._msgs:append(msg);
    end
end

function opvp.ChatTypeMessageFilter:eval(chatFrame, event, msg, msgLower, ...)
    local str;

    for n=1, self._msgs:size() do
        str = self._msgs:item(n);

        if (
            msg == str or
            string.find(msg, str) ~= nil
        ) then
            --~ opvp.printDebug(
                --~ "opvp.ChatTypeMessageFilter:eval, pattern=\"%s\"",
                --~ str
            --~ );

            --~ opvp.printDebug(
                --~ "opvp.ChatTypeMessageFilter:eval, msg=\"%s\"",
                --~ msg
            --~ );

            return true;
        end
    end

    return false;
end

function opvp.ChatTypeMessageFilter:removeMessage(msg, escape)
    if opvp.is_str(msg) == false then
        return;
    end

    if escape == true then
        msg = self:escape(msg);
        msg = opvp.ChatMessageFilter:escapeDigits(msg);
        msg = opvp.ChatMessageFilter:escapeStringsWildcard(msg);
    end

    self._msgs:removeItem(msg);
end

function opvp.ChatTypeMessageFilter:_connect()
    opvp.ChatMessageFilterManager:instance():register(
        self._chat_type,
        self
    );

    return true;
end

function opvp.ChatTypeMessageFilter:_disconnect()
    opvp.ChatMessageFilterManager:instance():unregister(
        self._chat_type,
        self
    );
end
