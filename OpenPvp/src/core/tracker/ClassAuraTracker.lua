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
    opvp.SpellProperty.CROWD_CONTROL,
    opvp.SpellProperty.DEFENSIVE,
    opvp.SpellProperty.OFFENSIVE
);

opvp.ClassAuraTracker = opvp.CreateClass(opvp.AuraServerConnection);

function opvp.ClassAuraTracker:init()
    opvp.AuraServerConnection.init(self);

    self._spec_counter = opvp.ClassSpecCounter();
end

function opvp.ClassAuraTracker:aurasForClass(class)
    return class:auras();
end

function opvp.ClassAuraTracker:aurasForSpec(spec)
    return spec:auras();
end

function opvp.ClassAuraTracker:_initializeParty(party)
    opvp.AuraServerConnection._initializeParty(self, party);

    party.closing:connect(self, self._uninitializeParty);
    party.memberSpecUpdate:connect(self, self._onMemberSpecUpdate);
end

function opvp.ClassAuraTracker:_initializePartyMembers(party, members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_refSpec(member:specInfo());
        end
    end
end

function opvp.ClassAuraTracker:_addSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:traits(), opvp_class_spell_mask) ~= 0 then
            self:addAura(spell);
        end
    end
end

function opvp.ClassAuraTracker:_derefSpec(spec)
    local spec_count, class_count = self._spec_counter:deref(spec);

    if class_count == 0 then
        self:_removeSpells(self:aurasForClass(spec:classInfo()));
    end

    if spec_count == 0 then
        self:_removeSpells(self:aurasForSpec(spec));
    end
end

function opvp.ClassAuraTracker:_onMemberSpecUpdate(member, newSpec, oldSpec)
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

function opvp.ClassAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    self:_initializePartyMembers(party, newMembers);

    self:_uninitializePartyMembers(party, removedMembers);
end

function opvp.ClassAuraTracker:_refSpec(spec)
    local spec_count, class_count = self._spec_counter:ref(spec);

    if class_count == 1 then
        self:_addSpells(self:aurasForClass(spec:classInfo()));
    end

    if spec_count == 1 then
        self:_addSpells(self:aurasForSpec(spec));
    end
end

function opvp.ClassAuraTracker:_removeSpells(spells)
    for id, spell in opvp.iter(spells) do
        if bit.band(spell:traits(), opvp_class_spell_mask) ~= 0 then
            self:removeAura(spell);
        end
    end
end

function opvp.ClassAuraTracker:_uninitializeParty(party)
    opvp.AuraServerConnection._uninitializeParty(self, party);

    party.closing:disconnect(self, self._uninitializeParty);
    party.memberSpecUpdate:disconnect(self, self._onMemberSpecUpdate);
end

function opvp.ClassAuraTracker:_uninitializePartyMembers(party, members)
    local member;

    for n=1, #members do
        member = members[n];

        if member:isSpecKnown() == true then
            self:_derefSpec(member:specInfo());
        end
    end
end
