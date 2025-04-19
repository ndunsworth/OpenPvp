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

opvp.PartyAuraTrackerConnection = opvp.CreateClass(opvp.AuraTrackerConnection);

function opvp.PartyAuraTrackerConnection:init()
    opvp.AuraTrackerConnection.init(self);
end

function opvp.PartyAuraTrackerConnection:isTrackerSupported(tracker)
    return opvp.IsInstance(tracker, opvp.PartyAuraTracker);
end

function opvp.PartyAuraTrackerConnection:_clear()
    local parties = self._tracker:parties();
    local members;

    for n=1, #parties do
        members = parties[n]:members();

        for x=1, #members do
            self:_clearMember(members[x]);
        end
    end
end

function opvp.PartyAuraTrackerConnection:_clearMember(member)

end

function opvp.PartyAuraTrackerConnection:_initializeMember(member)
    local auras = member:auras();
    local spell;

    for k, aura in opvp.iter(auras) do
        spell = self._tracker:findSpellForAura(aura);

        if spell ~= nil then
            self:_onAuraAdded(member, aura, spell);
        end
    end
end

function opvp.PartyAuraTrackerConnection:_initialize()
    if self._tracker:isInitialized() == false then
        return;
    end

    local parties = self._tracker:parties();
    local members;

    for n=1, #parties do
        members = parties[n]:members();

        for x=1, #members do
            self:_initializeMember(members[x]);
        end
    end
end

function opvp.PartyAuraTrackerConnection:_onAuraAdded(member, aura, spell)

end

function opvp.PartyAuraTrackerConnection:_onAuraRemoved(member, aura, spell)

end

function opvp.PartyAuraTrackerConnection:_onAuraUpdated(member, aura, spell)

end
