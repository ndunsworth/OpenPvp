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

opvp.MatchOptionChatTypesMessageFilter = opvp.CreateClass(opvp.ChatTypesMessageFilter);

function opvp.MatchOptionChatTypesMessageFilter:init(option, chatTypes, msgs, escape, lower)
    opvp.ChatTypesMessageFilter.init(self, chatTypes, msgs, escape, lower);

    assert(option ~= nil);

    self._opt = option;

    self._opt.changed:connect(self, self._onOptionChanged);

    if self._opt:value() == true then
        opvp.match.entered:connect(self, self.connect);
        opvp.match.exit:connect(self, self.disconnect);
    end
end

function opvp.MatchOptionChatTypesMessageFilter:_onOptionChanged()
    if self._opt:value() == true then
        opvp.match.entered:connect(self, self.connect);
        opvp.match.exit:connect(self, self.disconnect);

        if opvp.match.inMatch() == true then
            self:connect();
        end
    else
        opvp.match.entered:disconnect(self, self.connect);
        opvp.match.exit:disconnect(self, self.disconnect);

        if opvp.match.inMatch() == true then
            self:disconnect();
        end
    end
end
