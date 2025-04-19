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

opvp.PartyAuraTracker = opvp.CreateClass(opvp.AuraTracker);

function opvp.PartyAuraTracker:init()
    opvp.AuraTracker.init(self);

    self._parties     = opvp.List();

    self.rosterUpdate   = opvp.Signal("opvp.PartyAuraTracker.rosterUpdate");
    self.partyAdded     = opvp.Signal("opvp.PartyAuraTracker.partyAdded");
    self.partyRemoved   = opvp.Signal("opvp.PartyAuraTracker.partyRemoved");
end

function opvp.PartyAuraTracker:addParty(party)
    if (
        self:isInitialized() == false or
        self:isPartySupported(party) == false or
        self._parties:contains(party) == true
    ) then
        return;
    end

    self._parties:append(party);

    self:_onPartyAdded(party);

    self.partyAdded:emit(party);
end

function opvp.PartyAuraTracker:isPartySupported(party)
    return true;
end

function opvp.PartyAuraTracker:parties()
    return self._parties:items();
end

function opvp.PartyAuraTracker:removeParty(party)
    if self._parties:removeItem(party) == false then
        return;
    end

    self:_onPartyRemoved(party);

    self.partyRemoved:emit(party);
end

function opvp.PartyAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    opvp.AuraTracker._onRosterEndUpdate(self, party, newMembers, updatedMembers, removedMembers);

    if #newMembers > 0 or #removedMembers > 0 then
        self.rosterUpdate:emit(newMembers, removedMembers);
    end
end

function opvp.PartyAuraTracker:_onShutdown()
    local party;

    while self._parties:isEmpty() == false do
        self:_removeParty(self._parties:last());
    end
end

function opvp.PartyAuraTracker:_onSpellAdded(spell)
    opvp.AuraTracker._onSpellAdded(self, spell);

    local members;
    local member;
    local auras;

    for n=1, self._parties:size() do
        members = self._parties:item(n):members();

        for x=1, #members do
            member = members[x];

            auras = member:findAurasForSpell(spell);

            if auras:isEmpty() == false then
                self:_onMemberAurasAdded(member, auras, false);
            end
        end
    end
end

function opvp.PartyAuraTracker:_onSpellRemoved(spell)
    opvp.AuraTracker._onSpellRemoved(self, spell);

    local members;
    local member;
    local auras;

    for n=1, self._parties:size() do
        members = self._parties:item(n):members();

        for x=1, #members do
            member = members[x];

            auras = member:findAurasForSpell(spell);

            if auras:isEmpty() == false then
                self:_onMemberAurasRemoved(member, auras, false);
            end
        end
    end
end

function opvp.PartyAuraTracker:_removeParty(party)
    if self._parties:removeItem(party) == false then
        return;
    end
end

function opvp.PartyAuraTracker:_removePartyAuras(party)
    local members = party:members();
    local member;

    for n=1, #members do
        member = members[n];

        self:_onMemberAurasRemoved(member, member:auras(), false);
    end
end
