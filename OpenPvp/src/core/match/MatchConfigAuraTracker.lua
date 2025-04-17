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

opvp.MatchConfigAuraTracker = opvp.CreateClass(opvp.PartyAuraTracker);

function opvp.MatchConfigAuraTracker:init(match)
    self._match        = match;
    self._affiliation  = opvp.Affiliation.FRIENDLY;
    self._spec_counter = opvp.ClassSpecCounter();
end

function opvp.MatchConfigAuraTracker:initialize()
    if self._match == nil then
        return;
    end

    local teams = self._match:teams();

    for n=1, #teams do
        if self:isPartySupported(teams[n]) == true then
            self:_addParty(teams[n]);
        end
    end
end

function opvp.MatchConfigAuraTracker:shutdown()
    if self._match == nil then
        return;
    end

    local teams = self._match:teams();

    for n=1, #teams do
        if self:isPartySupported(teams[n]) == true then
            self:_removeParty(teams[n]);
        end
    end

    assert(self._spec_counter:isEmpty() == true);

    self._match = nil;
end

function opvp.MatchConfigAuraTracker:isPartySupported(party)
    return bit.band(self._affiliation, party:affiliation()) ~= 0;
end

function opvp.MatchConfigAuraTracker:setAffiliation(mask)
    self._affiliation = mask;
end

function opvp.MatchConfigAuraTracker:_addParty(party)
    opvp.printDebug(
        "opvp.MatchConfigAuraTracker:_addParty: %s",
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_addPartyMembers(party:members());
    end

    party.closing:connect(self, self._onPartyClosing);
    party.initialized:disconnect(self, self._onPartyInitialized);
    party.memberSpecUpdate:connect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.MatchConfigAuraTracker:_addPartyMembers(members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_refSpec(member:specInfo());
        end
    end
end

function opvp.MatchConfigAuraTracker:_addSpells(spells)
    local tracker = opvp.party.auraTracker();

    for id, spell in opvp.iter(spells) do
        if bit.band(spell:mask(), opvp_match_spell_mask) ~= 0 then
            tracker:addSpell(spell);
        end
    end
end

function opvp.MatchConfigAuraTracker:_derefSpec(spec)
    local spec_count, class_count = self._spec_counter:deref(spec);

    if class_count == 0 then
        self:_removeSpells(spec:classInfo():auras());
    end

    if spec_count == 0 then
        self:_removeSpells(spec:auras());
    end
end

function opvp.MatchConfigAuraTracker:_onMemberSpecUpdate(member, newSpec, oldSpec)
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

function opvp.MatchConfigAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    self:_addPartyMembers(newMembers);
    self:_removePartyMembers(removedMembers);
end

function opvp.MatchConfigAuraTracker:_onPartyClosing(party)
    self:_removePartyMembers(party:members());
end

function opvp.MatchConfigAuraTracker:_onPartyInitialized(category, guid, party)
    self:_addPartyMembers(party:members());
end

function opvp.MatchConfigAuraTracker:_refSpec(spec)
    local spec_count, class_count = self._spec_counter:ref(spec);

    if class_count == 1 then
        self:_addSpells(spec:classInfo():auras());
    end

    if spec_count == 1 then
        self:_addSpells(spec:auras());
    end
end

function opvp.MatchConfigAuraTracker:_removeParty(party)
    opvp.printDebug(
        "opvp.MatchConfigAuraTracker:_removeParty: %s",
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_removePartyMembers(party:members());
    end

    party.closing:disconnect(self, self._onPartyClosing);
    party.initialized:disconnect(self, self._onPartyInitialized);
    party.memberSpecUpdate:disconnect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.MatchConfigAuraTracker:_removePartyMembers(members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_derefSpec(member:specInfo());
        end
    end
end

function opvp.MatchConfigAuraTracker:_removeSpells(spells)
    local tracker = opvp.party.auraTracker();

    for id, spell in opvp.iter(spells) do
        if bit.band(spell:mask(), opvp_match_spell_mask) ~= 0 then
            tracker:removeSpell(spell);
        end
    end
end
