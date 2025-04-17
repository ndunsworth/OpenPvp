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

local opvp_match_spell_mask = bit.bor(
    opvp.SpellTrait.CROWD_CONTROL,
    opvp.SpellTrait.DEFENSIVE,
    opvp.SpellTrait.OFFENSIVE
);

opvp.MatchAuraTracker = opvp.CreateClass(opvp.PartyAuraTracker);

function opvp.MatchAuraTracker:init()
    opvp.PartyAuraTracker.init(self);

    self._match        = nil;
    self._affiliation  = opvp.Affiliation.FRIENDLY;
    self._spec_counter = opvp.ClassSpecCounter();
end

function opvp.MatchAuraTracker:initialize(match)
    --~ assert(self._match == nil);

    self._match = match;

    opvp.PartyAuraTracker.initialize(self);
end

function opvp.MatchAuraTracker:isPartySupported(party)
    return bit.band(self._affiliation, party:affiliation()) ~= 0;
end

function opvp.MatchAuraTracker:setAffiliation(mask)
    self._affiliation = mask;
end

function opvp.MatchAuraTracker:_addSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:mask(), opvp_match_spell_mask) ~= 0 then
            self:addSpell(spell);
        end
    end
end

function opvp.MatchAuraTracker:_derefSpec(spec)
    local spec_count, class_count = self._spec_counter:deref(spec);

    if class_count == 0 then
        self:_removeSpells(spec:classInfo():auras());
    end

    if spec_count == 1 then
        self:_removeSpells(spec:auras());
    end
end

function opvp.MatchAuraTracker:_onAuraAdded(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraAddedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraAddedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraAddedDefensive(member, aura, spell);
    end
end

function opvp.MatchAuraTracker:_onAuraAddedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraAddedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onAuraAddedCC(member, aura, spell)
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
            "opvp.MatchAuraTracker:_onAuraAddedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.MatchAuraTracker:_onAuraAddedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraAddedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onAuraRemoved(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraRemovedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraRemovedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraRemovedDefensive(member, aura, spell);
    end
end

function opvp.MatchAuraTracker:_onAuraRemovedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraRemovedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onAuraRemovedCC(member, aura, spell)
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
            "opvp.MatchAuraTracker:_onAuraRemovedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.MatchAuraTracker:_onAuraRemovedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraRemovedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onAuraUpdated(member, aura, spell)
    if spell:isCrowdControl() == true then
        self:_onAuraUpdatedCC(member, aura, spell);
    elseif spell:isOffensive() == true then
        self:_onAuraUpdatedBurst(member, aura, spell);
    elseif spell:isDefensive() == true then
        self:_onAuraUpdatedDefensive(member, aura, spell);
    end
end

function opvp.MatchAuraTracker:_onAuraUpdatedBurst(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraUpdatedBurst: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onAuraUpdatedCC(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_status, cc_mask_new, cc_mask_old = cc_state:_onAuraUpdated(aura, spell);

    if result == true then
        opvp.match.playerCrowdControlAdded:emit(member, aura, spell, cc_mask_new, cc_mask_old);

        opvp.printDebug(
            "opvp.MatchAuraTracker:_onAuraUpdatedCC: %s = %d, %s, %s, %d",
            member:nameOrId(),
            aura:spellId(),
            aura:name(),
            opvp.time.formatSeconds(aura:duration()),
            cc_status
        );
    end
end

function opvp.MatchAuraTracker:_onAuraUpdatedDefensive(member, aura, spell)
    opvp.printDebug(
        "opvp.MatchAuraTracker:_onAuraUpdatedDefensive: %s = %d, %s, %s",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );
end

function opvp.MatchAuraTracker:_onInitialized()
    opvp.PartyAuraTracker._onInitialized(self);

    if self._match == nil then
        return;
    end

    local teams = self._match:teams();

    for n=1, #teams do
        self:_addParty(teams[n]);
    end
end

function opvp.MatchAuraTracker:_onMemberSpecUpdate(member, newSpec, oldSpec)
    if newSpec == oldSpec then
        return;
    end

    if oldSpec:isValid() == true then
        self:_derefSpec(oldSpec);
    end

    if newSpec:isValid() == true then
        self:_refSpec(newSpec);
    end
end

function opvp.MatchAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    local member;
    local spells;

    for n=1, #newMembers do
        member = newMembers[n];

        if member:isSpecKnown() == true then
            self:_refSpec(member:specInfo());
        end
    end

    for n=1, #removedMembers do
        member = removedMembers[n];

        if member:isSpecKnown() == true then
            self:_derefSpec(member:specInfo());
        end
    end
end

function opvp.MatchAuraTracker:_onPartyAdded(party)
    opvp.PartyAuraTracker._onPartyAdded(self, party);

    party.memberSpecUpdate:connect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.MatchAuraTracker:_onPartyRemoved(party)
    opvp.PartyAuraTracker._onPartyRemoved(self, party);

    party.memberSpecUpdate:disconnect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.MatchAuraTracker:_onShutdown()
    opvp.PartyAuraTracker._onShutdown(self);

    self._match = nil;

    self._spec_counter:clear();
end

function opvp.MatchAuraTracker:_refSpec(spec)
    local spec_count, class_count = self._spec_counter:ref(spec);

    if class_count == 1 then
        self:_addSpells(spec:classInfo():auras());
    end

    if spec_count == 1 then
        self:_addSpells(spec:auras());
    end
end

function opvp.MatchAuraTracker:_removeSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:mask(), opvp_match_spell_mask) ~= 0 then
            self:removeSpell(spell);
        end
    end
end
