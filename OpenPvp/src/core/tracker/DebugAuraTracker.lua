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

opvp.DebugAuraTracker = opvp.CreateClass(opvp.AuraServerConnection);

function opvp.DebugAuraTracker:init()
    opvp.AuraServerConnection.init(self);
end

function opvp.DebugAuraTracker:_onMemberAurasAdded(member, auras, fullUpdate)
    for id, aura in opvp.iter(auras) do
        opvp.printMessageOrDebug(
            not opvp.DEBUG,
            "opvp.DebugAuraTracker:_onMemberAurasAdded(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end

function opvp.DebugAuraTracker:_onMemberAurasRemoved(member, auras, fullUpdate)
    for id, aura in opvp.iter(auras) do
        opvp.printDebug(
            not opvp.DEBUG,
            "opvp.DebugAuraTracker:_onMemberAurasRemoved(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end

function opvp.DebugAuraTracker:_onMemberAurasUpdated(member, auras, fullUpdate)
    for id, aura in opvp.iter(auras) do
        opvp.printDebug(
            not opvp.DEBUG,
            "opvp.DebugAuraTracker:_onMemberAurasUpdated(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end
