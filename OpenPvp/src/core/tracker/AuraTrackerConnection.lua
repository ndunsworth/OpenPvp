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

opvp.AuraTrackerConnection = opvp.CreateClass();

function opvp.AuraTrackerConnection:init()
    self._tracker = nil;
end

function opvp.AuraTrackerConnection:isTrackerSupported(tracker)
    return true;
end

function opvp.AuraTrackerConnection:setAuraTracker(tracker)
    if tracker == self._tracker then
        return;
    end

    if self._tracker ~= nil then
        self._tracker.auraAdded:disconnect(self, self._onAuraAdded);
        self._tracker.auraRemoved:disconnect(self, self._onAuraRemoved);
        self._tracker.auraUpdated:disconnect(self, self._onAuraUpdated);

        self:_clear();
    end

    self._tracker = tracker;

    if self._tracker ~= nil then
        self._tracker.auraAdded:connect(self, self._onAuraAdded);
        self._tracker.auraRemoved:connect(self, self._onAuraRemoved);
        self._tracker.auraUpdated:connect(self, self._onAuraUpdated);

        self:_initialize();
    end
end

function opvp.AuraTrackerConnection:_clear()

end

function opvp.AuraTrackerConnection:_initialize()

end

function opvp.AuraTrackerConnection:_onAuraAdded(member, aura, spell)

end

function opvp.AuraTrackerConnection:_onAuraRemoved(member, aura, spell)

end

function opvp.AuraTrackerConnection:_onAuraUpdated(member, aura, spell)

end
