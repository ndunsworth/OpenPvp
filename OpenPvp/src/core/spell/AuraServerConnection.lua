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

opvp.AuraServerConnection = opvp.CreateClass();

function opvp.AuraServerConnection:init()
    self._server           = nil;
    self._auras            = opvp.SpellRefMap();

    self.auraAdded         = opvp.Signal("opvp.AuraTracker.auraAdded");
    self.auraRemoved       = opvp.Signal("opvp.AuraTracker.auraRemoved");
    self.auraUpdated       = opvp.Signal("opvp.AuraTracker.auraUpdated");

    self.connected         = opvp.Signal("opvp.AuraServerConnection.connected");
    self.connecting        = opvp.Signal("opvp.AuraServerConnection.connecting");
    self.disconnecting     = opvp.Signal("opvp.AuraServerConnection.disconnecting");
    self.disconnected      = opvp.Signal("opvp.AuraServerConnection.disconnected");
end

function opvp.AuraServerConnection:addAura(spell)
    assert(opvp.IsInstance(spell, opvp.SpellExt));

    if self._auras:add(spell) == true then
        self:_onAuraAdded(spell);
    end
end

function opvp.AuraServerConnection:connect(server)
    if (
        self._server ~= nil or
        server == self._server or
        self:isServerSupported(server) == false
    ) then
        return;
    end

    self.connecting:emit();

    if server:_addConnection(self) == false then
        self.disconnected:emit();

        return;
    end

    self._server = server;

    self:_onConnected();

    local parties = self._server:parties();

    for n=1, #parties do
        self:_initializeParty(parties[n]);
    end

    self.connected:emit();
end

function opvp.AuraServerConnection:disconnect()
    if self._server == nil then
        return;
    end

    self.disconnecting:emit();

    self:_onDisconnected();

    self._server:_removeConnection(self);

    self._server = nil;

    self.disconnected:emit();
end

function opvp.AuraServerConnection:findSpellForAura(aura)
    return self._auras:findBySpellId(aura:spellId());
end

function opvp.AuraServerConnection:findBySpell(spell)
    return self._auras:findBySpell(spell);
end

function opvp.AuraServerConnection:findBySpellId(spellId)
    return self._auras:findBySpellId(spellId);
end

function opvp.AuraServerConnection:isAuraTracked(aura)
    return self:isSpellTracked(aura:spellId());
end

function opvp.AuraServerConnection:isConnected()
    return self._server ~= nil;
end

function opvp.AuraServerConnection:isServerSupported(server)
    return true;
end

function opvp.AuraServerConnection:isSpellTracked(spell)
    return self._auras:contains(spell);
end

function opvp.AuraServerConnection:parties()
    if self._server ~= nil then
        return self._server:parties();
    else
        return {};
    end
end

function opvp.AuraServerConnection:partiesSize()
    if self._server ~= nil then
        return self._server:partiesSize();
    else
        return 0;
    end
end

function opvp.AuraServerConnection:removeAura(spell)
    local refs = self._auras:refs(spell);

    if refs == 0 then
        return;
    end

    if refs == 1 then
        self:_onAuraRemoved(spell);
    end

    self._auras:remove(spell);
end

function opvp.AuraServerConnection:server()
    return self._server;
end

function opvp.AuraServerConnection:_initializeParty(party)
    if party:isInitialized() == true then
        self:_initializePartyMembers(party, party:members());
    end

    party.closing:connect(self, self._uninitializeParty);
end

function opvp.AuraServerConnection:_initializePartyMembers(party, members)

end

function opvp.AuraServerConnection:_onAuraAdded(spell)
    opvp.printDebug(
        "opvp.AuraServerConnection._onAuraAdded(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );

    local parties = self:parties();
    local members;
    local member;
    local auras;

    for n=1, #parties do
        members = parties[n]:members();

        for x=1, #members do
            member = members[x];

            auras = member:findAurasForSpell(spell);

            if auras:isEmpty() == false then
                self:_onMemberAurasAdded(member, auras, false);
            end
        end
    end
end

function opvp.AuraServerConnection:_onAuraRemoved(spell)
    opvp.printDebug(
        "opvp.AuraServerConnection._onAuraRemoved(id=%d, name=\"%s\")",
        spell:id(),
        spell:name()
    );

    local parties = self:parties();
    local members;
    local member;
    local auras;

    for n=1, #parties do
        members = parties[n]:members();

        for x=1, #members do
            member = members[x];

            auras = member:findAurasForSpell(spell);

            if auras:isEmpty() == false then
                self:_onMemberAurasRemoved(member, auras, false);
            end
        end
    end
end

function opvp.AuraServerConnection:_onConnected()
    opvp.printDebug(
        "opvp.AuraServerConnection:_onConnected, connection=%s",
        tostring(self)
    );

    self._server.partyAdded:connect(self, self._initializeParty);
    self._server.partyRemoved:connect(self, self._uninitializeParty);
    self._server.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.AuraServerConnection:_onDisconnected()
    opvp.printDebug(
        "opvp.AuraServerConnection:_onDisconnected, connection=%s",
        tostring(self)
    );

    self._server.partyAdded:disconnect(self, self._initializeParty);
    self._server.partyRemoved:disconnect(self, self._uninitializeParty);
    self._server.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.AuraServerConnection:_onMemberAuraAdded(member, auras, fullUpdate)

end

function opvp.AuraServerConnection:_onMemberAuraRemoved(member, auras, fullUpdate)

end

function opvp.AuraServerConnection:_onMemberAuraUpdated(member, auras, fullUpdate)

end

function opvp.AuraServerConnection:_onMemberAuraUpdate(
    member,
    aurasAdded,
    aurasUpdated,
    aurasRemoved,
    fullUpdate
)
    if aurasRemoved:isEmpty() == false then
        self:_onMemberAurasRemoved(member, aurasRemoved, fullUpdate);
    end

    if aurasUpdated:isEmpty() == false then
        self:_onMemberAurasUpdated(member, aurasUpdated, fullUpdate);
    end

    if aurasAdded:isEmpty() == false then
        self:_onMemberAurasAdded(member, aurasAdded, fullUpdate);
    end
end

function opvp.AuraServerConnection:_onMemberAurasAdded(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onMemberAuraAdded(member, aura, spell);
        end
    end
end

function opvp.AuraServerConnection:_onMemberAurasRemoved(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onMemberAuraRemoved(member, aura, spell);
        end
    end
end

function opvp.AuraServerConnection:_onMemberAurasUpdated(member, auras, fullUpdate)
    local spell;

    for id, aura in opvp.iter(auras) do
        spell = self._auras:findBySpellId(aura:spellId());

        if spell ~= nil then
            self:_onMemberAuraUpdated(member, aura, spell);
        end
    end
end

function opvp.AuraServerConnection:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    self:_uninitializePartyMembers(party, removedMembers);

    self:_initializePartyMembers(party, newMembers);
end

function opvp.AuraServerConnection:_uninitializeParty(party)
    if party:isInitialized() == true then
        self:_uninitializePartyMembers(party, party:members());
    end

    party.closing:disconnect(self, self._uninitializeParty);
end

function opvp.AuraServerConnection:_uninitializePartyMembers(party, members)

end
