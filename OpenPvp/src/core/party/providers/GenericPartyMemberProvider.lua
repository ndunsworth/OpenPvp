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

opvp.GenericPartyMemberProvider = opvp.CreateClass(opvp.PartyMemberProvider);

function opvp.GenericPartyMemberProvider:init()
    opvp.PartyMemberProvider.init(self);

    self._members   = opvp.List();
    self._cache     = opvp.List();
    self._player    = nil;
    self._leader    = nil;
end

function opvp.GenericPartyMemberProvider:findMemberByGuid(guid)
    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:guid() == guid then
            return member;
        end
    end

    return nil;
end

function opvp.GenericPartyMemberProvider:findMemberByUnitId(unitId)
    if unitId == "player" then
        return self._player;
    end

    if self:isUnitIdSupported(unitId) == false then
        return nil;
    end

    local index = self:unitIdGroupIndex(unitId);

    local member;

    if index > 0 and index <= self._members:size() then
        member = self._members:item(index);

        if member:id() == unitId then
            return member;
        end
    end

    return nil;
end

function opvp.GenericPartyMemberProvider:findMemberByName(name)
    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:name() == name then
            return member;
        end
    end

    return nil;
end

function opvp.GenericPartyMemberProvider:isEmpty()
    return self._members:isEmpty();
end

function opvp.GenericPartyMemberProvider:leader()
    return self._leader;
end

function opvp.GenericPartyMemberProvider:member(index)
    return self._members:item(index);
end

function opvp.GenericPartyMemberProvider:members()
    return self._members:items();
end

function opvp.GenericPartyMemberProvider:size()
    return self._members:size();
end

function opvp.GenericPartyMemberProvider:_categorySize()
    return opvp.party.utils.size(self._category);
end

function opvp.GenericPartyMemberProvider:_connect(category, guid)
    opvp.PartyMemberProvider._connect(self, category, guid);

    if self._name == "" then
        self:setName(opvp.PartyMemberProvider.name(self));
    end

    self:_connectSignals();
end

function opvp.GenericPartyMemberProvider:_connectSignals()
    if (
        self:isInstance() == true or
        opvp.party.hasInstanceParty() == false
    ) then
        opvp.event.GROUP_ROSTER_UPDATE:connect(self, self._onGroupRosterUpdate);
        opvp.event.PARTY_LEADER_CHANGED:connect(self, self._onGroupLeaderChanged);
        opvp.event.PARTY_MEMBER_ENABLE:connect(self, self._onMemberEnable);
        opvp.event.PARTY_MEMBER_DISABLE:connect(self, self._onMemberDisable);
        opvp.event.PLAYER_SPECIALIZATION_CHANGED:connect(self, self._onUnitSpecUpdate);
        opvp.event.UNIT_CONNECTION:connect(self, self._onUnitConnection);
        opvp.event.UNIT_FACTION:connect(self, self._onUnitFactionUpdate);
        opvp.event.UNIT_HEALTH:connect(self, self._onUnitHealth);
        opvp.event.UNIT_NAME_UPDATE:connect(self, self._onUnitNameUpdate);
        opvp.event.UNIT_IN_RANGE_UPDATE:connect(self, self._onUnitRangeUpdate);
    end

    if self:isHome() == true then
        opvp.party.aboutToJoin:connect(self._onInstanceGroupJoined);
        opvp.party.left:connect(self._onInstanceGroupLeft);
    end
end

function opvp.GenericPartyMemberProvider:_disconnect()
    opvp.PartyMemberProvider._disconnect(self);

    self:_disconnectSignals();

    for n=1, self._members:size() do
        self:_releaseMember(self._members:item(n));
    end

    self._members:clear();

    self._player    = nil;
    self._leader    = nil;
end

function opvp.GenericPartyMemberProvider:_disconnectSignals()
    if (
        self:isInstance() == true or
        opvp.party.hasInstanceParty() == false
    ) then
        opvp.event.PARTY_LEADER_CHANGED:disconnect(self, self._onGroupLeaderChanged);
        opvp.event.GROUP_ROSTER_UPDATE:disconnect(self, self._onGroupRosterUpdate);
        opvp.event.PARTY_MEMBER_ENABLE:disconnect(self, self._onMemberEnable);
        opvp.event.PARTY_MEMBER_DISABLE:disconnect(self, self._onMemberDisable);
        opvp.event.PLAYER_SPECIALIZATION_CHANGED:disconnect(self, self._onUnitSpecUpdate);
        opvp.event.UNIT_CONNECTION:disconnect(self, self._onUnitConnection);
        opvp.event.UNIT_FACTION:disconnect(self, self._onUnitFactionUpdate);
        opvp.event.UNIT_HEALTH:disconnect(self, self._onUnitHealth);
        opvp.event.UNIT_NAME_UPDATE:disconnect(self, self._onUnitNameUpdate);
        opvp.event.UNIT_IN_RANGE_UPDATE:disconnect(self, self._onUnitRangeUpdate);
    end

    if self:isHome() == true then
        opvp.party.aboutToJoin:disconnect(self._onInstanceGroupJoined);
        opvp.party.left:disconnect(self._onInstanceGroupLeft);
    end
end

function opvp.GenericPartyMemberProvider:_findMemberByUnitId(unitId, create)
    if self:isUnitIdSupported(unitId) == false then
        return nil, 0, false;
    end

    local member;

    local index = self:unitIdGroupIndex(unitId);

    if index > 0 and index <= self._members:size() then
        member = self._members:item(index);

        if member:id() == unitId then
            return member, index, false;
        end
    end

    if create == false then
        return nil, 0, false;
    end

    member = self:_createMember(unitId);

    if member ~= nil then
        return member, 0, true;
    else
        return nil, 0, false;
    end
end

function opvp.GenericPartyMemberProvider:_findMemberByGuid(unitId, create)
    if self:isUnitIdSupported(unitId) == false then
        return nil, 0, false;
    end

    local guid = opvp.unit.guid(unitId);

    if guid == "" then
        return nil, 0, false;
    end

    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:guid() == guid then
            return member, n, false;
        end
    end

    if create == false then
        return nil, 0, false;
    end

    member = self:_createMember(unitId, guid);

    if member ~= nil then
        return member, 0, true;
    else
        return nil, 0, false;
    end
end

function opvp.GenericPartyMemberProvider:_findMemberByGuid2(unitId, guid, create)
    if self:isUnitIdSupported(unitId) == false then
        return nil, 0, false;
    end

    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:guid() == guid then
            return member, n, false;
        end
    end

    if create == false then
        return nil, 0, false;
    end

    member = self:_createMember(unitId, guid);

    if member ~= nil then
        return member, 0, true;
    else
        return nil, 0, false;
    end
end

function opvp.GenericPartyMemberProvider:_memberInspect(member)
    if member:isGuidKnown() == true then
        return opvp.inspect:register(
            member:guid(),
            self,
            self._onMemberInspectInt
        );
    else
        return false;
    end
end

function opvp.GenericPartyMemberProvider:_onConnected()
    opvp.PartyMemberProvider._onConnected(self);

    if (
        self:hasPlayer() == true and
        opvp.party.isReloading(self._category) == true and
        self:_categorySize() > 1
    ) then
        self:_onGroupRosterUpdate();

        self._leader = self:findMemberByUnitId(
            opvp.party.utils.leader(self._category)
        );
    end
end

function opvp.GenericPartyMemberProvider:_onGroupLeaderChanged()
    local prev_leader = self._leader;

    local token = self:tokenGroup();

    local unitid = opvp.party.utils.leader(self._category);

    if unitid ~= "" then
        if unitid == "player" then
            self._leader = self._player;
        else
            self._leader = self:findMemberByUnitId(unitid);
        end
    else
        self._leader = nil;
    end

    self:_onPartyLeaderChanged(self._leader, prev_leader);
end

function opvp.GenericPartyMemberProvider:_onGroupRosterUpdate()
    local old_type = self._type;
    local party_type = opvp.party.utils.type(self._category);

    if party_type ~= self._type then
        self._type = party_type;

        self:_onPartyTypeChanged(self._type, old_type);
    end

    self:_scanMembers();
end

function opvp.GenericPartyMemberProvider:_onInstanceGroupJoined(category, guid)
    if category == self:category() then
        return;
    end

    self:_disconnectSignals();
end

function opvp.GenericPartyMemberProvider:_onInstanceGroupLeft(party)
    if party == self then
        return;
    end

    self:_connectSignals();
end

function opvp.GenericPartyMemberProvider:_onMemberEnable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local mask = 0;

    if member:isEnabled() == false then
        member:_setEnabled(true);

        mask = opvp.PartyMember.ENABLED_FLAG;
    end

    if opvp.unit.isDeadOrGhost(unitId) ~= member:isDead() then
        member:_setDead(not member:isDead());

        mask = bit.bor(
            mask,
            opvp.PartyMember.DEAD_FLAG
        );
    end

    if mask ~= 0 then
        self:_onMemberInfoUpdate(member, mask);
    end
end

function opvp.GenericPartyMemberProvider:_onMemberDisable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local mask = 0;

    if member:isEnabled() == true then
        member:_setEnabled(false);

        mask = opvp.PartyMember.ENABLED_FLAG;
    end

    if opvp.unit.isDeadOrGhost(unitId) == true then
        if (
            opvp.unit.isFeignDeath(unitId) == false and
            member:isAlive() == true
        ) then
            member:_setDead(true);

            mask = bit.bor(
                mask,
                opvp.PartyMember.DEAD_FLAG
            );
        end
    elseif member:isDead() == true then
        member:_setDead(false);

        mask = bit.bor(
            mask,
            opvp.PartyMember.DEAD_FLAG
        );
    end

    if mask ~= 0 then
        self:_onMemberInfoUpdate(member, mask);
    end
end

function opvp.GenericPartyMemberProvider:_onMemberInspect(member, mask)
    mask = bit.bor(mask, member:_updateCharacterInfo());

    local spec = opvp.ClassSpec:fromSpecId(
        GetInspectSpecialization(member:id())
    );

    if spec:isValid() == true and spec:id() ~= member:spec() then
        mask = bit.bor(mask, opvp.PartyMember.SPEC_FLAG);

        member:_setSpec(spec);
    end

    --~ opvp.printDebug(
        --~ "    Spec: %s, %s, %s, %s, %s, %s",
        --~ member:guid(),
        --~ member:name(),
        --~ member:factionInfo():name(),
        --~ member:raceInfo():name(),
        --~ member:classInfo():name(),
        --~ member:specInfo():name()
    --~ );

    opvp.PartyMemberProvider._onMemberInspect(self, member, mask);
end

function opvp.GenericPartyMemberProvider:_onMemberInspectInt(guid, valid)
    local member = self:findMemberByGuid(guid);

    if member == nil then
        return;
    end

    if valid == true then
        self:_onMemberInspect(member, 0);
    else
        opvp.printDebug(
            "opvp.GenericPartyMemberProvider:_onMemberInspectInt, failed %s=%d",
            member:nameOrId(),
            guid
        );

        self:_memberInspect(member);
    end
end

function opvp.GenericPartyMemberProvider:_onUnitConnection(unitId, isConnected)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    if member:isConnected() ~= isConnected then
        member:_setConnected(isConnected);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.CONNECTED_FLAG);
    end
end

function opvp.GenericPartyMemberProvider:_onUnitFlags(unitId)
end

function opvp.GenericPartyMemberProvider:_onUnitHealth(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local health = UnitHealth(unitId);

    local mask = opvp.PartyMember.HEALTH_FLAG;

    if health <= 0 then
        if (
            member:isAlive() == true and
            opvp.unit.isDeadOrGhost(unitId) == true and
            opvp.unit.isFeignDeath(unitId) == false
        ) then
            member:_setDead(true);

            mask = bit.bor(mask, opvp.PartyMember.DEAD_FLAG);
        end
    elseif member:isDead() == true then
        if (
            opvp.unit.isDeadOrGhost(unitId) == false or
            opvp.unit.isFeignDeath(unitId) == true
        ) then
            member:_setAlive(true);

            mask = bit.bor(mask, opvp.PartyMember.DEAD_FLAG);
        end
    end

    self:_onMemberInfoUpdate(member, mask);
end

function opvp.GenericPartyMemberProvider:_onUnitFactionUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local mask = 0;

    if member:isFactionKnown() == false then
        local faction = opvp.unit.faction(unitId);

        if faction ~= opvp.Faction.NEUTRAL then
            member:_setFaction(faction);

            mask = opvp.PartyMember.FACTION_FLAG;
        end
    end

    if member:isRaceKnown() == false then
        mask = bit.bor(mask, member:_updateCharacterRaceSex());
    end

    if mask ~= 0 then
        self:_onMemberInfoUpdate(member, mask);
    end
end

function opvp.GenericPartyMemberProvider:_onUnitNameUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local mask = 0;
    local name = opvp.unit.name(unitId);

    if name ~= "" and name ~= member:name() then
        member:_setName(name);

        mask = opvp.PartyMember.NAME_FLAG;
    end

    if member:isRaceKnown() == false then
        mask = bit.bor(mask, member:_updateCharacterRaceSex());
    end

    if mask ~= 0 then
        self:_onMemberInfoUpdate(member, mask);
    end
end

function opvp.GenericPartyMemberProvider:_onUnitRangeUpdate(unitId, state)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or state == member:inRange() then
        return;
    end

    member:_setFlags(opvp.PartyMember.RANGE_FLAG, state);

    self:_onMemberInfoUpdate(member, opvp.PartyMember.RANGE_FLAG);
end

function opvp.GenericPartyMemberProvider:_onUnitSpecUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        self:_memberInspect(member);
    end
end

function opvp.GenericPartyMemberProvider:_scanMembers()
    self:_onRosterBeginUpdate();

    local party_count     = self:_categorySize();
    local members         = opvp.List();
    local new_members     = opvp.List();
    local removed_members = opvp.List();
    local update_members  = opvp.List();
    local token           = self:tokenGroup();
    local unitid;
    local member;
    local index;
    local created;
    local mask;

    if self:isParty() == true then
        party_count = party_count - 1;
    end

    if self:hasPlayer() == true and self:isParty() == true then
        if self._player == nil then
            self._player = self:_createMember("player");

            self._player:_setFlags(opvp.PartyMember.PLAYER_FLAG, true);
            self._player:_setFaction(opvp.player.factionInfo());
            self._player:_setRace(opvp.player.raceInfo());
            self._player:_setSex(opvp.player.sex());
            self._player:_setSpec(opvp.player.specInfo());
            self._player:_setName(opvp.player.name());
        else
            self._members:removeItem(self._player);
        end

        assert(self._player ~= nil);
    end

    for n=1, party_count do
        unitid = token .. n;

        member, index, created = self:_findMemberByGuid(unitid, true);

        assert(member ~= nil);

        if created == true then
            self:_updateMember(unitid, member, created);

            if member:isSpecKnown() == false then
                self:_memberInspect(member);
            end

            new_members:append(member);

            members:append(member);
        else
            self._members:removeIndex(index);

            mask = self:_updateMember(unitid, member, created);

            if mask ~= 0 then
                update_members:append({member, mask});
            end

            members:append(member);
        end
    end

    self._members:swap(members);

    if self:hasPlayer() == true then
        if self:isParty() == true then
            assert(self._player ~= nil);

            self._members:append(self._player);
        elseif self._player == nil then
            self._player = self:findMemberByGuid(opvp.player.guid());

            assert(self._player ~= nil);

            self._player:_setFlags(opvp.PartyMember.PLAYER_FLAG, true);
            self._player:_setFaction(opvp.player.factionInfo());
            self._player:_setRace(opvp.player.raceInfo());
            self._player:_setSex(opvp.player.sex());
            self._player:_setSpec(opvp.player.specInfo());
            self._player:_setName(opvp.player.name());
        end
    end

    self:_onRosterEndUpdate(
        new_members:items(),
        update_members:items(),
        members:items()
    );
end

function opvp.GenericPartyMemberProvider:_updateMember(unitId, member, created)
    local mask = 0;

    if unitId ~= member:id() then
        member:_setId(unitid);

        mask = opvp.PartyMember.ID_FLAG;
    end

    mask = bit.bor(mask, member:_updateCharacterInfo());

    return mask;
end
