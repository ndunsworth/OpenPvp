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

opvp.PartyMemberProvider = opvp.CreateClass();

function opvp.PartyMemberProvider:init()
    self._category      = opvp.PartyCategory.HOME;
    self._guid          = "";
    self._type          = opvp.PartyType.PARTY;
    self._connected     = false;
    self._roster_update = false;
    self._hostile       = false;
    self._factory       = opvp.PartyMemberFactory(opvp.PartyMemberFactoryCache(40));
    self._owns_factory  = true;
    self._members       = opvp.List();

    self.connected         = opvp.Signal("opvp.PartyMemberProvider.connected");
    self.disconnecting     = opvp.Signal("opvp.PartyMemberProvider.disconnecting");
    self.disconnected      = opvp.Signal("opvp.PartyMemberProvider.disconnected");
    self.leaderChanged     = opvp.Signal("opvp.PartyMemberProvider.leaderChanged");
    self.memberInfoUpdate  = opvp.Signal("opvp.PartyMemberProvider.memberInfoUpdate");
    self.memberInspect     = opvp.Signal("opvp.PartyMemberProvider.memberInspect");
    self.rosterBeginUpdate = opvp.Signal("opvp.PartyMemberProvider.rosterBeginUpdate");
    self.rosterEndUpdate   = opvp.Signal("opvp.PartyMemberProvider.rosterEndUpdate");
    self.typeChanged       = opvp.Signal("opvp.PartyMemberProvider.typeChanged");
end

function opvp.PartyMemberProvider:connect(category, guid)
    if self._connected == true then
        return;
    end

    self:_connect(category, guid);

    self._connected = true;

    self:_onConnected();
end

function opvp.PartyMemberProvider:category()
    return self._category;
end

function opvp.PartyMemberProvider:disconnect()
    if self._connected == false then
        return;
    end

    self.disconnecting:emit();

    self:_disconnect();

    self._connected = false;

    self:_onDisconnected();
end

function opvp.PartyMemberProvider:findMemberByGuid(guid)
    return nil;
end

function opvp.PartyMemberProvider:findMemberByUnitId(guid)
    return nil;
end

function opvp.PartyMemberProvider:findMemberByName(name)
    return nil;
end

function opvp.PartyMemberProvider:hasPlayer()
    return true;
end

function opvp.PartyMemberProvider:guid()
    return self._guid;
end

function opvp.PartyMemberProvider:isConnected()
    return self._connected;
end

function opvp.PartyMemberProvider:isCrossFaction()
    return opvp.party.utils.isCrossFaction(self._category);
end

function opvp.PartyMemberProvider:isEmpty()
    return true;
end

function opvp.PartyMemberProvider:isGuidInGroup(guid)
    return opvp.party.utils.isGuidInGroup(guid, self._category);
end

function opvp.PartyMemberProvider:isFull()
    return opvp.party.utils.isFull(self._category);
end

function opvp.PartyMemberProvider:isHome()
    return self._category == opvp.PartyCategory.HOME;
end

function opvp.PartyMemberProvider:isFriendly()
    return self._hostile == false;
end

function opvp.PartyMemberProvider:isHostile()
    return self._hostile == true;
end

function opvp.PartyMemberProvider:isInstance()
    return self._category == opvp.PartyCategory.INSTANCE;
end

function opvp.PartyMemberProvider:isReloading()
    if self:isConnected() == true then
        return opvp.party.isReloading(self._category);
    else
        return false;
    end
end

function opvp.PartyMemberProvider:isParty()
    return self._type == opvp.PartyType.PARTY;
end

function opvp.PartyMemberProvider:isRaid()
    return self._type == opvp.PartyType.RAID;
end

function opvp.PartyMemberProvider:isTest()
    return false;
end

function opvp.PartyMemberProvider:isUpdatingRoster()
    return self._roster_update;
end

function opvp.PartyMemberProvider:isUnitIdSupported(unitId)
    if unitId == "player" then
        return self:hasPlayer();
    end

    if self._type == opvp.PartyType.PARTY then
        local _, _, party   = string.find(unitId, self:tokenExprParty());

        return party ~= nil;
    else
        local _, _, party   = string.find(unitId, self:tokenExprParty());
        local _, _, grp = string.find(unitId, self:tokenExprGroup());

        return party ~= nil or grp ~= nil;
    end
end

function opvp.PartyMemberProvider:leader()
    return nil;
end

function opvp.PartyMemberProvider:member(index)
    return nil;
end

function opvp.PartyMemberProvider:members()
    return {};
end

function opvp.PartyMemberProvider:size()
    return 0;
end

function opvp.PartyMemberProvider:tokenExprGroup()
    if self._type == opvp.PartyType.PARTY then
        return "party(%d+)";
    else
        return "raid(%d+)";
    end
end

function opvp.PartyMemberProvider:tokenExprParty()
    return "party(%d+)";
end

function opvp.PartyMemberProvider:tokenGroup()
    if self._type == opvp.PartyType.PARTY then
        return "party";
    else
        return "raid";
    end
end

function opvp.PartyMemberProvider:tokenParty()
    return "party";
end

function opvp.PartyMemberProvider:type()
    return self._type;
end

function opvp.PartyMemberProvider:unitIdGroupIndex(unitId)
    local _, _, grp = string.find(unitId, self:tokenExprGroup());

    if grp ~= nil then
        return tonumber(grp);
    else
        return 0;
    end
end

function opvp.PartyMemberProvider:unitIdPartyIndex(unitId)
    local _, _, party = string.find(unitId, self:tokenExprParty());

    if party ~= nil then
        return tonumber(party);
    else
        return 0;
    end
end

function opvp.PartyMemberProvider:_connect(category, guid)
    self._category  = category;
    self._guid      = guid;

    if self:isTest() == false then
        self._type = opvp.party.utils.type(self._category);
    end
end

function opvp.PartyMemberProvider:_createMember(unitId, guid)
    local member = self._factory:create(unitId, guid);

    if member ~= nil then
        member:_setHostile(self._hostile);
    end

    return member;
end

function opvp.PartyMemberProvider:_disconnect()

end

function opvp.PartyMemberProvider:_memberFactory()
    return self._factory;
end

function opvp.PartyMemberProvider:_memberInspect(member)
end

function opvp.PartyMemberProvider:_onConnected()
    self.connected:emit();
end

function opvp.PartyMemberProvider:_onDisconnected()
    self.disconnected:emit();
end

function opvp.PartyMemberProvider:_onMemberInfoUpdate(member, mask)
    self.memberInfoUpdate:emit(member, mask);
end

function opvp.PartyMemberProvider:_onMemberInspect(member, mask)
    self.memberInspect:emit(member, mask);

    if mask ~= 0 then
        self:_onMemberInfoUpdate(member, mask);
    end
end

function opvp.PartyMemberProvider:_onPartyLeaderChanged(newLeader, oldLeader)
    self.leaderChanged:emit(newLeader, oldLeader);
end

function opvp.PartyMemberProvider:_onPartyTypeChanged(newPartyType, oldPartyType)
    self.typeChanged:emit(newPartyType, oldPartyType);
end

function opvp.PartyMemberProvider:_onRosterBeginUpdate()
    self._roster_update = true;

    self.rosterBeginUpdate:emit();
end

function opvp.PartyMemberProvider:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    self._roster_update = false;

    self.rosterEndUpdate:emit(newMembers, updatedMembers, removedMembers);

    for n=1, #removedMembers do
        self:_releaseMember(removedMembers[n]);
    end
end

function opvp.PartyMemberProvider:_releaseMember(member)
    self._factory:release(member);
end

function opvp.PartyMemberProvider:_setFriendly(state)
    assert(opvp.is_bool(state));

    self._hostile = not state;
end

function opvp.PartyMemberProvider:_setFactory(factory)
    if (
        self._connected == true or
        (
            factory == nil and
            self._owns_factory == true
        )
    ) then
        return;
    end

    if factory == nil then
        factory = opvp.PartyMemberFactoryCache(
            opvp.PartyMemberFactory()
        );

        self._owns_factory = true
    else
        self._owns_factory = false;
    end

    self._factory = factory;
end

function opvp.PartyMemberProvider:_setHostile(state)
    assert(opvp.is_bool(state));

    self._hostile = state;
end
