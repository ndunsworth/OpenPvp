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

opvp.AdvPartyAuraTracker = opvp.CreateClass(opvp.PartyAuraTracker);

function opvp.AdvPartyAuraTracker:init()
    opvp.PartyAuraTracker.init(self);
end

function opvp.AdvPartyAuraTracker:_onAuraAdded(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraAddedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraAddedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraAddedDefensive(member, aura, spell);
    end

    self.auraAdded:emit(member, aura, spell);
end

function opvp.AdvPartyAuraTracker:_onAuraAddedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraAddedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.AdvPartyAuraTracker:_onAuraAddedCC(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_status, cc_mask_new, cc_mask_old = cc_state:_onAuraAdded(aura, spell);

    if result == true then
        opvp.match.playerCrowdControlAdded:emit(
            member,
            aura,
            spell,
            cc_status,
            cc_mask_new,
            cc_mask_old
        );

        opvp.printDebug(
            "opvp.AdvPartyAuraTracker:_onAuraAddedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.AdvPartyAuraTracker:_onAuraAddedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraAddedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.AdvPartyAuraTracker:_onAuraRemoved(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraRemovedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraRemovedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraRemovedDefensive(member, aura, spell);
    end

    self.auraRemoved:emit(member, aura, spell);
end

function opvp.AdvPartyAuraTracker:_onAuraRemovedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraRemovedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.AdvPartyAuraTracker:_onAuraRemovedCC(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_status, cc_mask_new, cc_mask_old = cc_state:_onAuraRemoved(aura, spell);

    if result == true then
        opvp.match.playerCrowdControlRemoved:emit(
            member,
            aura,
            spell,
            cc_status,
            cc_mask_new,
            cc_mask_old
        );

        opvp.printDebug(
            "opvp.AdvPartyAuraTracker:_onAuraRemovedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.AdvPartyAuraTracker:_onAuraRemovedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraRemovedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.AdvPartyAuraTracker:_onAuraUpdated(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraUpdatedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraUpdatedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraUpdatedDefensive(member, aura, spell);
    end

    self.auraUpdated:emit(member, aura, spell);
end

function opvp.AdvPartyAuraTracker:_onAuraUpdatedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraUpdatedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.AdvPartyAuraTracker:_onAuraUpdatedCC(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_status, cc_mask_new, cc_mask_old = cc_state:_onAuraUpdated(aura, spell);

    if result == true then
        opvp.match.playerCrowdControlAdded:emit(member, aura, spell, cc_mask_new, cc_mask_old);

        opvp.printDebug(
            "opvp.AdvPartyAuraTracker:_onAuraUpdatedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.AdvPartyAuraTracker:_onAuraUpdatedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.AdvPartyAuraTracker:_onAuraUpdatedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end
