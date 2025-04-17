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

opvp.PartyAuraTracker = opvp.CreateClass();

function opvp.PartyAuraTracker:init()
    self._initialized = false;
    self._parties     = opvp.List();
    self._auras       = opvp.SpellRefMap();

    self.auraAdded    = opvp.Signal("opvp.PartyAuraTracker.auraAdded");
    self.auraRemoved  = opvp.Signal("opvp.PartyAuraTracker.auraRemoved");
    self.auraUpdated  = opvp.Signal("opvp.PartyAuraTracker.auraUpdated");
    self.partyAdded   = opvp.Signal("opvp.PartyAuraTracker.partyAdded");
    self.partyRemoved = opvp.Signal("opvp.PartyAuraTracker.partyRemoved");
end

function opvp.PartyAuraTracker:addSpell(spell)
    self._auras:add(spell);

    opvp.printDebug(
        "opvp.PartyAuraTracker.addSpell(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );
end

function opvp.PartyAuraTracker:initialize()
    if self._initialized == true then
        return;
    end

    self:_initialize();

    self._initialized = true;

    self:_onInitialized();
end

function opvp.PartyAuraTracker:isTracked(aura)
    return self._auras:contains(aura:spellId());
end

function opvp.PartyAuraTracker:isInitialized()
    return self._initialized;
end

function opvp.PartyAuraTracker:isPartySupported(party)
    return true;
end

function opvp.PartyAuraTracker:removeSpell(spell)
    self._auras:remove(spell);

    opvp.printDebug(
        "opvp.PartyAuraTracker.removeSpell(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );
end

function opvp.PartyAuraTracker:shutdown()
    if self._initialized == false then
        return;
    end

    self:_onShutdown();

    self:_shutdown();

    self._initialized = false;
end

function opvp.PartyAuraTracker:_addParty(party)
    if (
        self:isPartySupported(party) == false or
        self._parties:contains(party) == true
    ) then
        return;
    end

    self._parties:append(party);

    self:_onPartyAdded(party);

    self.partyAdded:emit(party);
end

function opvp.PartyAuraTracker:_initialize()

end

function opvp.PartyAuraTracker:_onAuraAdded(member, aura, spell)
    self.auraAdded:emit(member, aura, spell);
end

function opvp.PartyAuraTracker:_onAuraRemoved(member, aura, spell)
    self.auraRemoved:emit(member, aura, spell);
end

function opvp.PartyAuraTracker:_onAuraUpdated(member, aura, spell)
    self.auraUpdated:emit(member, aura, spell);
end

function opvp.PartyAuraTracker:_onInitialized()

end

function opvp.PartyAuraTracker:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    local spell;

    for id, aura in opvp.iter(aurasAdded) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraAdded(member, aura, spell);
        --~ else
            --~ opvp.printDebug("opvp.PartyAuraTracker:_onMemberAuraUpdate, aurasAdded (ignored): %d, %s", aura:spellId(), aura:name());
        end
    end

    for id, aura in opvp.iter(aurasUpdated) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraUpdated(member, aura, spell);
        --~ else
            --~ opvp.printDebug("opvp.PartyAuraTracker:_onMemberAuraUpdate, aurasUpdated (ignored): %d, %s", aura:spellId(), aura:name());
        end
    end

    for id, aura in opvp.iter(aurasRemoved) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraRemoved(member, aura, spell);
        --~ else
            --~ opvp.printDebug("opvp.PartyAuraTracker:_onMemberAuraUpdate, aurasRemoved (ignored): %d, %s", aura:spellId(), aura:name());
        end
    end
end

function opvp.PartyAuraTracker:_onPartyAdded(party)
    party.memberAuraUpdate:connect(self, self._onMemberAuraUpdate);
end

function opvp.PartyAuraTracker:_onPartyRemoved(party)
    party.memberAuraUpdate:disconnect(self, self._onMemberAuraUpdate);
end

function opvp.PartyAuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    if #newMembers == 0 and #removedMembers == 0 then
        return;
    end

    local trackers = {};
    local member;
    local tracker;

    for n=1, #removedMembers do
        member = removedMembers[n];

        tracker = member:_crowdControlTracker();

        if tracker ~= nil then
            member:_setCrowdControlTracker(nil);

            table.insert(trackers, tracker);
        end
    end

    for n=1, #newMembers do
        if #trackers == 0 then
            tracker = self:_createTracker();
        else
            tracker = trackers[#trackers];

            table.remove(trackers, #trackers)
        end

        assert(tracker ~= nil);

        newMembers[n]:_setCrowdControlTracker(tracker);
    end

    for n=1, #trackers do
        self:_releaseTracker(trackers[n]);
    end
end

function opvp.PartyAuraTracker:_onShutdown()
    local party;

    while self._parties:isEmpty() == false do
        self:_removeParty(self._parties:last());
    end
end

function opvp.PartyAuraTracker:_removeParty(party)
    if self._parties:removeItem(party) == false then
        return;
    end

    self:_onPartyRemoved(party);

    self.partyRemoved:emit(party);
end

function opvp.PartyAuraTracker:_shutdown()

end
