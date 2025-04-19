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

opvp.AuraTracker = opvp.CreateClass();

function opvp.AuraTracker:init()
    self._initialized = false;
    self._auras       = opvp.SpellRefMap();

    self.auraAdded    = opvp.Signal("opvp.AuraTracker.auraAdded");
    self.auraRemoved  = opvp.Signal("opvp.AuraTracker.auraRemoved");
    self.auraUpdated  = opvp.Signal("opvp.AuraTracker.auraUpdated");
end

function opvp.AuraTracker:addSpell(spell)
    assert(opvp.IsInstance(spell, opvp.SpellExt));

    if self._auras:add(spell) == true then
        self:_onSpellAdded(spell);
    end
end

function opvp.AuraTracker:initialize()
    if self._initialized == true then
        return;
    end

    self:_initialize();

    self._initialized = true;

    self:_onInitialized();
end

function opvp.AuraTracker:findSpellForAura(aura)
    return self._auras:findBySpellId(aura:spellId());
end

function opvp.AuraTracker:findBySpell(spell)
    return self._auras:findBySpell(spell);
end

function opvp.AuraTracker:findBySpellId(spellId)
    return self._auras:findBySpellId(spellId);
end

function opvp.AuraTracker:isAuraTracked(aura)
    return self:isSpellTracked(aura:spellId());
end

function opvp.AuraTracker:isInitialized()
    return self._initialized;
end

function opvp.AuraTracker:isSpellTracked(spell)
    return self._auras:contains(spell);
end

function opvp.AuraTracker:removeSpell(spell)
    local refs = self._auras:refs(spell);

    if refs == 0 then
        return;
    end

    if refs == 1 then
        self:_onSpellRemoved(spell);
    end

    self._auras:remove(spell);
end

function opvp.AuraTracker:shutdown()
    if self._initialized == false then
        return;
    end

    self:_onShutdown();

    self:_shutdown();

    self._initialized = false;
end

function opvp.AuraTracker:_addPartyAuras(party)
    local members = party:members();
    local member;

    for n=1, #members do
        member = members[n];

        self:_onMemberAurasAdded(member, member:auras(), false);
    end
end

function opvp.AuraTracker:_initialize()

end

function opvp.AuraTracker:_onAuraAdded(member, aura, spell)
    self.auraAdded:emit(member, aura, spell);
end

function opvp.AuraTracker:_onAuraRemoved(member, aura, spell)
    self.auraRemoved:emit(member, aura, spell);
end

function opvp.AuraTracker:_onAuraUpdated(member, aura, spell)
    self.auraUpdated:emit(member, aura, spell);
end

function opvp.AuraTracker:_onInitialized()

end

function opvp.AuraTracker:_onMemberAurasAdded(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraAdded(member, aura, spell);
        else
            opvp.printDebug(
                "opvp.AuraTracker:_onMemberAurasAdded(%s), ignored spell_id=%d, spell=%s",
                member:nameOrId(),
                aura:spellId(),
                aura:name()
            );
        end
    end
end

function opvp.AuraTracker:_onMemberAurasRemoved(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraRemoved(member, aura, spell);
        --~ else
            --~ opvp.printDebug(
                --~ "opvp.AuraTracker:_onMemberAurasRemoved(%s), ignored spell_id=%d, spell=%s",
                --~ member:nameOrId(),
                --~ aura:spellId(),
                --~ aura:name()
            --~ );
        end
    end
end

function opvp.AuraTracker:_onMemberAurasUpdated(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onAuraUpdated(member, aura, spell);
        --~ else
            --~ opvp.printDebug(
                --~ "opvp.AuraTracker:_onMemberAurasUpdated(%s), ignored spell_id=%d, spell=%s",
                --~ member:nameOrId(),
                --~ aura:spellId(),
                --~ aura:name()
            --~ );
        end
    end
end

function opvp.AuraTracker:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    if aurasAdded:isEmpty() == false then
        self:_onMemberAurasAdded(member, aurasAdded, fullUpdate);
    end

    if aurasUpdated:isEmpty() == false then
        self:_onMemberAurasUpdated(member, aurasUpdated, fullUpdate);
    end

    if aurasRemoved:isEmpty() == false then
        self:_onMemberAurasRemoved(member, aurasRemoved, fullUpdate);
    end
end

function opvp.AuraTracker:_onPartyAdded(party)
    opvp.printDebug(
        "opvp.AuraTracker:_onPartyAdded, guid=%s, initialized=%s",
        party:guid(),
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_addPartyAuras(party);
    end

    party.closing:connect(self, self._onPartyClosing);
    party.initialized:connect(self, self._onPartyInitialized);
    party.memberAuraUpdate:connect(self, self._onMemberAuraUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.AuraTracker:_onPartyClosing(party)
    opvp.printDebug(
        "opvp.AuraTracker:_onPartyClosing, category=%d, guid=%s",
        party:category(),
        party:guid()
    );

    self:_removePartyAuras(party);
end

function opvp.AuraTracker:_onPartyInitialized(category, guid, party)

end

function opvp.AuraTracker:_onPartyRemoved(party)
    opvp.printDebug(
        "opvp.AuraTracker:_onPartyRemoved, guid=%s, initialized=%s",
        party:guid(),
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_removePartyAuras(party);
    end

    party.closing:disconnect(self, self._onPartyClosing);
    party.initialized:disconnect(self, self._onPartyInitialized);
    party.memberAuraUpdate:disconnect(self, self._onMemberAuraUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.AuraTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    local member;

    if #newMembers > 0 then
        for n=1, #newMembers do
            member = newMembers[n];

            self:_onMemberAurasAdded(member, member:auras(), false);
        end
    end

    if #removedMembers > 0 then
        for n=1, #removedMembers do
            member = removedMembers[n];

            self:_onMemberAurasRemoved(member, member:auras(), false);
        end
    end
end

function opvp.AuraTracker:_onShutdown()

end

function opvp.AuraTracker:_onSpellAdded(spell)
    opvp.printDebug(
        "opvp.AuraTracker._onSpellAdded(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );
end

function opvp.AuraTracker:_onSpellRemoved(spell)
    opvp.printDebug(
        "opvp.AuraTracker._onSpellRemoved(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );
end

function opvp.AuraTracker:_removePartyAuras(party)
    local members = party:members();
    local member;

    for n=1, #members do
        member = members[n];

        self:_onMemberAurasRemoved(member, member:auras(), false);
    end
end

function opvp.AuraTracker:_shutdown()

end
