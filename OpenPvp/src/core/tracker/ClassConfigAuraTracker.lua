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

local opvp_class_spell_mask = bit.bor(
    opvp.SpellTrait.CROWD_CONTROL,
    opvp.SpellTrait.DEFENSIVE,
    opvp.SpellTrait.OFFENSIVE
);

opvp.ClassConfigAuraTracker = opvp.CreateClass();

function opvp.ClassConfigAuraTracker:init()
    self._spec_counter = opvp.ClassSpecCounter();
    self._tracker      = nil;
end

function opvp.ClassConfigAuraTracker:initialize(auraTracker)
    if auraTracker == self._tracker then
        return;
    end

    if self._tracker ~= nil then
        self:shutdown();
    end

    self._tracker = auraTracker;

    self._tracker.partyAdded:connect(self, self._addParty);

    local parties = self._tracker:parties();

    for n=1, #parties do
        if self:isPartySupported(parties[n]) == true then
            self:_addParty(parties[n]);
        end
    end
end

function opvp.ClassConfigAuraTracker:isPartySupported(party)
    return true;
end

function opvp.ClassConfigAuraTracker:shutdown()
    if self._tracker == nil then
        return;
    end

    self._tracker.partyAdded:disconnect(self, self._addParty);

    local parties = self._tracker:parties();

    for n=1, #parties do
        if self:isPartySupported(parties[n]) == true then
            self:_removeParty(parties[n]);
        end
    end

    assert(self._spec_counter:isEmpty() == true);

    self._tracker = nil;
end

function opvp.ClassConfigAuraTracker:_addParty(party)
    if party:isInitialized() == true then
        self:_addPartyMembers(party:members());
    end

    party.closing:connect(self, self._onPartyClosing);
    party.initialized:disconnect(self, self._onPartyInitialized);
    party.memberSpecUpdate:connect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.ClassConfigAuraTracker:_addPartyMembers(members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_refSpec(member:specInfo());
        end
    end
end

function opvp.ClassConfigAuraTracker:_addSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:traits(), opvp_class_spell_mask) ~= 0 then
            self._tracker:addSpell(spell);
        end
    end
end

function opvp.ClassConfigAuraTracker:_derefSpec(spec)
    local spec_count, class_count = self._spec_counter:deref(spec);

    if class_count == 0 then
        self:_removeSpells(spec:classInfo():auras());
    end

    if spec_count == 0 then
        self:_removeSpells(spec:auras());
    end
end

function opvp.ClassConfigAuraTracker:_onMemberSpecUpdate(member, newSpec, oldSpec)
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

function opvp.ClassConfigAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    self:_addPartyMembers(newMembers);
    self:_removePartyMembers(removedMembers);
end

function opvp.ClassConfigAuraTracker:_onPartyClosing(party)
    self:_removePartyMembers(party:members());
end

function opvp.ClassConfigAuraTracker:_onPartyInitialized(category, guid, party)
    self:_addPartyMembers(party:members());
end

function opvp.ClassConfigAuraTracker:_refSpec(spec)
    local spec_count, class_count = self._spec_counter:ref(spec);

    if class_count == 1 then
        self:_addSpells(spec:classInfo():auras());
    end

    if spec_count == 1 then
        self:_addSpells(spec:auras());
    end
end

function opvp.ClassConfigAuraTracker:_removeParty(party)
    if party:isInitialized() == true then
        self:_removePartyMembers(party:members());
    end

    party.closing:disconnect(self, self._onPartyClosing);
    party.initialized:disconnect(self, self._onPartyInitialized);
    party.memberSpecUpdate:disconnect(self, self._onMemberSpecUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.ClassConfigAuraTracker:_removePartyMembers(members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_derefSpec(member:specInfo());
        end
    end
end

function opvp.ClassConfigAuraTracker:_removeSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:traits(), opvp_class_spell_mask) ~= 0 then
            self._tracker:removeSpell(spell);
        end
    end
end
