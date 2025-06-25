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

opvp.AuraServer = opvp.CreateClass(opvp.Object);

function opvp.AuraServer:__del__()
    self:shutdown();
end


function opvp.AuraServer:init()
    opvp.Object.init(self);

    self._initialized = -1;
    self._parties     = opvp.List();
    self._connections = opvp.List();
    self._auras_null  = opvp.AuraMap();
    self._name        = "";

    self.partyAdded        = opvp.Signal("opvp.AuraServer.partyAdded");
    self.partyRemoved      = opvp.Signal("opvp.AuraServer.partyRemoved");
    self.rosterBeginUpdate = opvp.Signal("opvp.AuraServer.rosterBeginUpdate");
    self.rosterEndUpdate   = opvp.Signal("opvp.AuraServer.rosterEndUpdate");
end

function opvp.AuraServer:addParty(party)
    if (
        self:isInitialized() == false or
        self:isPartySupported(party) == false or
        self._parties:contains(party) == true
    ) then
        return;
    end

    self._parties:append(party);

    self.partyAdded:emit(party);

    self:_onPartyAdded(party);
end

function opvp.AuraServer:connections()
    return self._connections:items();
end

function opvp.AuraServer:connectionsSize()
    return self._connections:size();
end

function opvp.AuraServer:initialize()
    if self._initialized ~= -1 then
        return;
    end

    self:_initialize();

    self._initialized = 1;

    self:_onInitialized();
end

function opvp.AuraServer:isConnectionSupported(connection)
    return true;
end

function opvp.AuraServer:isInitialized()
    return self._initialized == 1;
end

function opvp.AuraServer:isInitializing()
    return self._initialized == 0;
end

function opvp.AuraServer:isShutdown()
    return self._initialized == -1;
end

function opvp.AuraServer:isPartySupported(party)
    return true;
end

function opvp.AuraServer:parties()
    return self._parties:items();
end

function opvp.AuraServer:partiesSize()
    return self._parties:size();
end

function opvp.AuraServer:removeParty(party)
    local index = self._parties:index(party);

    if index < 1 then
        return;
    end

    self._parties:removeIndex(index);

    self:_onPartyRemoved(party);

    self.partyRemoved:emit(party);
end

function opvp.AuraServer:shutdown()
    if self._initialized == false then
        return;
    end

    self:_onShutdown();

    self:_shutdown();

    self._initialized = -1;
end

function opvp.AuraServer:_addConnection(connection)
    assert(connection:isConnected() == false);

    if self:isInitialized() == false then
        return false;
    end

    self._connections:append(connection);

    self:_onConnectionAdded(connection);

    return true;
end

function opvp.AuraServer:_addPartyAuras(party)
    local members = party:members();

    for n=1, #members do
        self:_addPartyMemberAuras(members[n]);
    end
end

function opvp.AuraServer:_addPartyMemberAuras(member)
    self:_onMemberAuraUpdate(
        member,
        member:auras(),
        self._auras_null,
        self._auras_null,
        false
    );
end

function opvp.AuraServer:_initialize()

end

function opvp.AuraServer:_onConnectionAdded(connection)
    opvp.printDebug(
        "opvp.AuraServer:_onConnectionAdded, connection=%s",
        tostring(connection)
    );
end

function opvp.AuraServer:_onConnectionRemoved(connection)
    opvp.printDebug(
        "opvp.AuraServer:_onConnectionRemoved, connection=%s",
        tostring(connection)
    );
end

function opvp.AuraServer:_onInitialized()
    opvp.printDebug(
        "opvp.AuraServerConnection:_onInitialized, server=%s",
        tostring(self)
    );
end

function opvp.AuraServer:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    local connection;

    for n=1, self._connections:size() do
        connection = self._connections:item(n);

        connection:_onMemberAuraUpdate(
            member,
            aurasAdded,
            aurasUpdated,
            aurasRemoved,
            fullUpdate
        );
    end
end

function opvp.AuraServer:_onPartyAdded(party)
    opvp.printDebug(
        "opvp.AuraServer:_onPartyAdded, guid=%s, initialized=%s",
        party:guid(),
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_addPartyAuras(party);
    end

    party.closing:connect(self, self._onPartyClosing);
    party.memberAuraUpdate:connect(self, self._onMemberAuraUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
end

function opvp.AuraServer:_onPartyClosing(party)
    opvp.printDebug(
        "opvp.AuraServer:_onPartyClosing, category=%d, guid=%s",
        party:category(),
        party:guid()
    );

    self:_removePartyAuras(party);
end

function opvp.AuraServer:_onPartyRemoved(party)
    opvp.printDebug(
        "opvp.AuraServer:_onPartyRemoved, guid=%s, initialized=%s",
        party:guid(),
        tostring(party:isInitialized())
    );

    if party:isInitialized() == true then
        self:_removePartyAuras(party);
    end

    party.closing:disconnect(self, self._onPartyClosing);
    party.memberAuraUpdate:disconnect(self, self._onMemberAuraUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end

function opvp.AuraServer:_onRosterBeginUpdate(party)
    self.rosterBeginUpdate:emit(party);
end

function opvp.AuraServer:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    self.rosterEndUpdate:emit(party, newMembers, updatedMembers, removedMembers);

    for n=1, #removedMembers do
        self:_removePartyMemberAuras(removedMembers[n]);
    end

    for n=1, #newMembers do
        self:_addPartyMemberAuras(newMembers[n]);
    end
end

function opvp.AuraServer:_onShutdown()
    opvp.printDebug(
        "opvp.AuraServerConnection:_onShutdown, server=%s",
        tostring(self)
    );

    local party;

    while self._parties:isEmpty() == false do
        self:_removeParty(self._parties:last());
    end

    while self._connections:isEmpty() == false do
        self._connections:last():disconnect();
    end
end

function opvp.AuraServer:_removeConnection(connection)
    assert(connection:server() == self);

    local index = self._connections:index(connection);

    assert(index > 0);

    self._connections:removeIndex(index);

    self:_onConnectionRemoved(connection);
end

function opvp.AuraServer:_removePartyAuras(party)
    local members = party:members();

    for n=1, #members do
        self:_removePartyMemberAuras(members[n]);
    end
end

function opvp.AuraServer:_removePartyMemberAuras(member)
    self:_onMemberAuraUpdate(
        member,
        self._auras_null,
        self._auras_null,
        member:auras(),
        false
    );
end
