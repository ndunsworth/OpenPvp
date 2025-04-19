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

opvp.CrowdControlTracker = opvp.CreateClass(opvp.PartyAuraTrackerConnection);

function opvp.CrowdControlTracker:init()
    opvp.PartyAuraTrackerConnection.init(self);

    self.memberCrowdControlAdded   = opvp.Signal("opvp.CrowdControlTracker.playerCrowdControlAdded");
    self.memberCrowdControlRemoved = opvp.Signal("opvp.CrowdControlTracker.playerCrowdControlRemoved");
end

function opvp.CrowdControlTracker:_clearParties()
    local parties = self._tracker:parties();
    local members;

    for n=1, #parties do
        members = parties[n]:members();

        for x=1, #members do
            members[x]:ccState():_clear();
        end
    end
end

function opvp.CrowdControlTracker:_clearMember(member)
    member:ccState():_clear();
end

function opvp.CrowdControlTracker:_initialize()
    opvp.PartyAuraTrackerConnection._initialize(self);

    self._tracker.rosterUpdate:connect(self, self._onRosterUpdate);
end

function opvp.CrowdControlTracker:_onAuraAdded(member, aura, spell)
    if spell:isCrowdControl() == false then
        return;
    end

    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old = cc_state:_onAuraAdded(aura, spell);

    if result == true then
        self.memberCrowdControlAdded:emit(
            member,
            aura,
            spell,
            cc_cat_state,
            cc_mask_new,
            cc_mask_old
        );

        opvp.printDebug(
            "opvp.CrowdControlTracker:_onAuraAdded(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            cc_cat_state:category():name(),
            cc_cat_state:dr(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end
function opvp.CrowdControlTracker:_onAuraRemoved(member, aura, spell)
    if spell:isCrowdControl() == false then
        return;
    end

    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old = cc_state:_onAuraRemoved(aura, spell);

    if result == true then
        self.memberCrowdControlRemoved:emit(
            member,
            aura,
            spell,
            cc_cat_state,
            cc_mask_new,
            cc_mask_old
        );

        opvp.printDebug(
            "opvp.CrowdControlTracker:_onAuraRemoved(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            cc_cat_state:category():name(),
            cc_cat_state:dr(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end

function opvp.CrowdControlTracker:_onAuraUpdated(member, aura, spell)
    if spell:isCrowdControl() == false then
        return;
    end

    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old = cc_state:_onAuraUpdated(aura, spell);

    if result == true then
        self.memberCrowdControlAdded:emit(
            member,
            aura,
            spell,
            cc_cat_state,
            cc_mask_new,
            cc_mask_old
        );

        opvp.printDebug(
            "opvp.CrowdControlTracker:_onAuraUpdated(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, duration=%s,",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            cc_cat_state:category():name(),
            cc_cat_state:dr(),
            opvp.time.formatSeconds(aura:duration())
        );
    end
end

function opvp.CrowdControlTracker:_onRosterUpdate(newMembers, removedMembers)

end
