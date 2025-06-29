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

    self._members           = opvp.List();
    self._cache             = opvp.List();
    self._auras_new         = opvp.AuraMap();
    self._auras_mod         = opvp.AuraMap();
    self._auras_rem         = opvp.AuraMap();
    self._player            = nil;
    self._leader            = nil;
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
    if unitId == opvp.unitid.PLAYER then
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
    local n, s = opvp.unit.splitNameAndServer(name);

    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:name() == n and member:server() == s then
            return member;
        end
    end

    return nil;
end

function opvp.GenericPartyMemberProvider:findMembersWithAura(spell)
    local members = {};

    local member;

    for n=1, self._members:size() do
        member = self._members:item(n);

        if member:hasAuraForSpell(spell) == true then
            table.insert(result, member);
        end
    end

    return members;
end

function opvp.GenericPartyMemberProvider:ignoreRosterUpdates()
    return false;
end

function opvp.GenericPartyMemberProvider:isCombatLogEnabled()
    return true;
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

function opvp.GenericPartyMemberProvider:player()
    return self._player;
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
end

function opvp.GenericPartyMemberProvider:_connectSignals()
    if self:hasPlayer() == true then
        opvp.event.GROUP_ROSTER_UPDATE:connect(self, self._onGroupRosterUpdate);
        opvp.event.PARTY_LEADER_CHANGED:connect(self, self._onGroupLeaderChanged);
        opvp.event.PARTY_MEMBER_ENABLE:connect(self, self._onMemberEnable);
        opvp.event.PARTY_MEMBER_DISABLE:connect(self, self._onMemberDisable);
        opvp.event.PLAYER_SPECIALIZATION_CHANGED:connect(self, self._onUnitSpecUpdate);
    end

    if (
        self:isInstance() == true or
        opvp.party.hasInstanceParty() == false
    ) then
        opvp.event.UNIT_AURA:connect(self, self._onUnitAura);
        opvp.event.UNIT_CONNECTION:connect(self, self._onUnitConnection);
        opvp.event.UNIT_FACTION:connect(self, self._onUnitFactionUpdate);
        opvp.event.UNIT_HEALTH:connect(self, self._onUnitHealth);
        opvp.event.UNIT_NAME_UPDATE:connect(self, self._onUnitNameUpdate);
        opvp.event.UNIT_IN_RANGE_UPDATE:connect(self, self._onUnitRangeUpdate);

        opvp.event.UNIT_SPELLCAST_CHANNEL_START:connect(self, self._onUnitSpellCastChannelStart);
        opvp.event.UNIT_SPELLCAST_CHANNEL_STOP:connect(self, self._onUnitSpellCastChannelStop);
        opvp.event.UNIT_SPELLCAST_CHANNEL_UPDATE:connect(self, self._onUnitSpellCastChannelUpdate);
        opvp.event.UNIT_SPELLCAST_EMPOWER_START:connect(self, self._onUnitSpellCastEmpowerStart);
        opvp.event.UNIT_SPELLCAST_EMPOWER_STOP:connect(self, self._onUnitSpellCastEmpowerStop);
        opvp.event.UNIT_SPELLCAST_EMPOWER_UPDATE:connect(self, self._onUnitSpellCastEmpowerUpdate);
        opvp.event.UNIT_SPELLCAST_FAILED:connect(self, self._onUnitSpellCastFailed);
        opvp.event.UNIT_SPELLCAST_FAILED_QUIET:connect(self, self._onUnitSpellCastFailedQuiet);
        opvp.event.UNIT_SPELLCAST_INTERRUPTED:connect(self, self._onUnitSpellCastInterrupted);
        opvp.event.UNIT_SPELLCAST_START:connect(self, self._onUnitSpellCastStart);
        opvp.event.UNIT_SPELLCAST_STOP:connect(self, self._onUnitSpellCastStop);
        opvp.event.UNIT_SPELLCAST_SUCCEEDED:connect(self, self._onUnitSpellCastSucceeded);
    end

    if self:isHome() == true then
        opvp.party.aboutToJoin:connect(self, self._onInstanceGroupJoined);
        opvp.party.left:connect(self, self._onInstanceGroupLeft);
    end

    local monitor = opvp.PvpTrinketMonitor:instance();

    monitor.trinketUsed:connect(
        self,
        self._onPvpTrinketUsed
    );
end

function opvp.GenericPartyMemberProvider:_disconnect()
    opvp.PartyMemberProvider._disconnect(self);
end

function opvp.GenericPartyMemberProvider:_disconnectSignals()
    if self:hasPlayer() == true then
        opvp.event.GROUP_ROSTER_UPDATE:disconnect(self, self._onGroupRosterUpdate);
        opvp.event.PARTY_LEADER_CHANGED:disconnect(self, self._onGroupLeaderChanged);
        opvp.event.PARTY_MEMBER_ENABLE:disconnect(self, self._onMemberEnable);
        opvp.event.PARTY_MEMBER_DISABLE:disconnect(self, self._onMemberDisable);
        opvp.event.PLAYER_SPECIALIZATION_CHANGED:disconnect(self, self._onUnitSpecUpdate);
    end

    if (
        self:isInstance() == true or
        opvp.party.hasInstanceParty() == false
    ) then
        opvp.event.UNIT_AURA:disconnect(self, self._onUnitAura);
        opvp.event.UNIT_CONNECTION:disconnect(self, self._onUnitConnection);
        opvp.event.UNIT_FACTION:disconnect(self, self._onUnitFactionUpdate);
        opvp.event.UNIT_HEALTH:disconnect(self, self._onUnitHealth);
        opvp.event.UNIT_NAME_UPDATE:disconnect(self, self._onUnitNameUpdate);
        opvp.event.UNIT_IN_RANGE_UPDATE:disconnect(self, self._onUnitRangeUpdate);

        opvp.event.UNIT_SPELLCAST_CHANNEL_START:disconnect(self, self._onUnitSpellCastChannelStart);
        opvp.event.UNIT_SPELLCAST_CHANNEL_STOP:disconnect(self, self._onUnitSpellCastChannelStop);
        opvp.event.UNIT_SPELLCAST_CHANNEL_UPDATE:disconnect(self, self._onUnitSpellCastChannelUpdate);
        opvp.event.UNIT_SPELLCAST_EMPOWER_START:disconnect(self, self._onUnitSpellCastEmpowerStart);
        opvp.event.UNIT_SPELLCAST_EMPOWER_STOP:disconnect(self, self._onUnitSpellCastEmpowerStop);
        opvp.event.UNIT_SPELLCAST_EMPOWER_UPDATE:disconnect(self, self._onUnitSpellCastEmpowerUpdate);
        opvp.event.UNIT_SPELLCAST_FAILED:disconnect(self, self._onUnitSpellCastFailed);
        opvp.event.UNIT_SPELLCAST_FAILED_QUIET:disconnect(self, self._onUnitSpellCastFailedQuiet);
        opvp.event.UNIT_SPELLCAST_INTERRUPTED:disconnect(self, self._onUnitSpellCastInterrupted);
        opvp.event.UNIT_SPELLCAST_START:disconnect(self, self._onUnitSpellCastStart);
        opvp.event.UNIT_SPELLCAST_STOP:disconnect(self, self._onUnitSpellCastStop);
        opvp.event.UNIT_SPELLCAST_SUCCEEDED:disconnect(self, self._onUnitSpellCastSucceeded);
    end

    if self:isHome() == true then
        opvp.party.aboutToJoin:disconnect(self, self._onInstanceGroupJoined);
        opvp.party.left:disconnect(self, self._onInstanceGroupLeft);
    end

    local monitor = opvp.PvpTrinketMonitor:instance();

    monitor.trinketUsed:disconnect(
        self,
        self._onPvpTrinketUsed
    );
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
    if self:isUnitIdSupported(unitId) == false or guid == nil or guid == "" then
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
        --~ opvp.printDebug(
            --~ "opvp.GenericPartyMemberProvider:_memberInspect, %s=%s",
            --~ member:nameOrId(),
            --~ member:guid()
        --~ );

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
    self:_connectSignals();

    if self:hasPlayer() == true then
        if self._player == nil then
            self._player = self:_createMember(opvp.unitid.PLAYER, opvp.player.guid());

            self._player:_setFlags(opvp.PartyMember.PLAYER_FLAG, true);
            self._player:_setFaction(opvp.player.factionInfo());
            self._player:_setRace(opvp.player.raceInfo());
            self._player:_setSex(opvp.player.sex());
            self._player:_setSpec(opvp.player.specInfo());
            self._player:_setName(opvp.player.name());

            self:_onRosterBeginUpdate();

            self._members:append(self._player);

            self:_updateMember(self._player:id(), self._player, true);

            self:_onRosterEndUpdate({self._player}, {}, {});
        end

        if (
            opvp.party.isReloading(self._category) == true and
            self:_categorySize() > 1
        ) then
            self:_onGroupRosterUpdate();
        end
    end

    opvp.PartyMemberProvider._onConnected(self);
end

function opvp.GenericPartyMemberProvider:_onDisconnected()
    opvp.PartyMemberProvider._onDisconnected(self);

    self:_disconnectSignals();

    self._player = nil;
    self._leader = nil;

    for n=1, self._members:size() do
        self:_releaseMember(self._members:item(n));
    end

    self._members:clear();
end

function opvp.GenericPartyMemberProvider:_onGroupLeaderChanged()
    local prev_leader = self._leader;

    local token = self:tokenGroup();

    local unitid = opvp.party.utils.leader(self._category);

    if unitid ~= "" then
        if unitid == opvp.unitid.PLAYER then
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

    if self:hasPlayer() == true and self._leader == nil then
        self:_onGroupLeaderChanged();
    end
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

    local old_spec;

    if spec:isValid() == true then
        if spec:id() ~= member:spec() then
            mask = bit.bor(mask, opvp.PartyMember.SPEC_FLAG);

            old_spec = member:specInfo();

            member:_setSpec(spec);
        end
    else
        self:_memberInspect(member)
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

    if old_spec ~= nil then
        self:_onMemberSpecUpdate(member, spec, old_spec);
    end
end

function opvp.GenericPartyMemberProvider:_onMemberInspectInt(guid, valid)
    local member = self:findMemberByGuid(guid);

    if member == nil then
        return;
    end

    if valid == true then
        self:_onMemberInspect(member, 0);
    elseif (
        self:isHome() == false or
        opvp.unit.isSameFaction(member:id()) == true
    ) then
        opvp.printDebug(
            "opvp.GenericPartyMemberProvider:_onMemberInspectInt, failed [%s] %s=%s",
            tostring(opvp.unit.isInspectable(member:guid())),
            member:nameOrId(),
            guid
        );

        if opvp.instance.isFollowerDungeon() == false then
            self:_memberInspect(member);
        end
    else
        opvp.printDebug(
            "opvp.GenericPartyMemberProvider:_onMemberInspectInt, failed because unit is opposite faction [%s] %s=%s",
            tostring(opvp.unit.isInspectable(member:guid())),
            member:nameOrId(),
            guid
        );

        if member:isSpecKnown() == true then
            return;
        end

        local spec = opvp.ClassSpec:fromTooltip(member:id());

        if spec:isValid() == true then
            member:_setSpec(spec);

            self:_onMemberInfoUpdate(member, opvp.PartyMember.SPEC_FLAG);

            self:_onMemberSpecUpdate(member, spec, opvp.ClassSpec.UNKNOWN);
        end
    end
end

function opvp.GenericPartyMemberProvider:_onMemberPvpTrinketUsed(member, spellId, timestamp)
    local duration;

    if opvp.spell.isPvpRacialTrinket(spellId) == true then
        if spellId == 7744 then
            duration = 120;
        else
            duration = 180;
        end
    else
        local role = member:role();

        if role:isValid() == false then
            role = opvp.unit.role(member:id());
        end

        if role:isHealer() == true then
            duration = 90;
        else
            duration = 120;
        end
    end

    local mask = member:pvpTrinketState():_onUpdate(
        spellId,
        timestamp,
        duration
    );

    if mask ~= 0 then
        self:_onMemberPvpTrinketUpdate(member, mask);
    end

    opvp.PartyMemberProvider._onMemberPvpTrinketUsed(self, member, spellId, timestamp);
end

function opvp.GenericPartyMemberProvider:_onPvpTrinketUsed(
    timestamp,
    guid,
    name,
    spellId,
    hostile
)
    if hostile ~= self:isHostile() then
        return;
    end

    local member = self:findMemberByGuid(guid);

    if member ~= nil then
        self:_onMemberPvpTrinketUsed(
            member,
            spellId,
            timestamp - opvp.system.bootTime()
        );
    end
end

function opvp.GenericPartyMemberProvider:_onUnitAura(unitId, info)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or info == nil then
        return;
    end

    self._auras_new:clear();
    self._auras_mod:clear();
    self._auras_rem:clear();

    local isfull = member:_updateAuras(
        info,
        self._auras_new,
        self._auras_mod,
        self._auras_rem
    );

    if (
        self._auras_new:isEmpty() == false or
        self._auras_mod:isEmpty() == false or
        self._auras_rem:isEmpty() == false
    ) then
        self:_onMemberAuraUpdate(
            member,
            self._auras_new,
            self._auras_mod,
            self._auras_rem,
            isfull
        );
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

    local health = member:health();

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

    member:_setInRange(state);

    self:_onMemberInfoUpdate(member, opvp.PartyMember.RANGE_FLAG);
end

function opvp.GenericPartyMemberProvider:_onUnitSpecUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        self:_memberInspect(member);
    end
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastChannelStart(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local info = opvp.unit.channelInfo(unitId);

    member:_setSpellChanneling(castId, spellId, info.start_time, info.end_time);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastChannelStop(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    member:_setSpellChanneling("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastChannelUpdate(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    local info = opvp.unit.channelInfo(unitId);

    member:_setSpellChanneling(castId, spellId, info.start_time, info.end_time);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastEmpowerStart(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local info = opvp.unit.channelInfo(unitId);

    member:_setSpellChanneling(castId, spellId, info.start_time, info.end_time);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastEmpowerStop(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    member:_setSpellChanneling("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastEmpowerUpdate(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    local info = opvp.unit.channelInfo(unitId);

    member:_setSpellChanneling(castId, spellId, info.start_time, info.end_time);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastFailed(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    member:_setSpellCasting("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastFailedQuiet(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    member:_setSpellCasting("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastInterrupted(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    member:_setSpellCasting("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastStart(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local info = opvp.unit.castInfo(unitId);

    member:_setSpellCasting(castId, spellId, info.start_time, info.end_time);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastStop(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or spellId ~= member:castingSpellId() then
        return;
    end

    member:_setSpellCasting("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_onUnitSpellCastSucceeded(unitId, castId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil or castId ~= member:castingGuid() then
        return;
    end

    member:_setSpellCasting("", 0, 0, 0);
end

function opvp.GenericPartyMemberProvider:_scanMembers()
    if self:ignoreRosterUpdates() == true then
        return;
    end

    self:_onRosterBeginUpdate();

    local party_count     = self:_categorySize();
    local members         = opvp.List();
    local new_members     = opvp.List();
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
        assert(self._player ~= nil);

        self._members:removeItem(self._player);
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
            assert(index > 0);

            self._members:removeIndex(index);

            mask = self:_updateMember(unitid, member, created);

            if mask ~= 0 then
                update_members:append({member, mask});
            end

            members:append(member);
        end
    end

    self._members:swap(members);

    if self:hasPlayer() == true and self:isParty() == true then
        assert(self._player ~= nil);

        self._members:append(self._player);
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
        member:_setId(unitId);

        mask = opvp.PartyMember.ID_FLAG;
    end

    mask = bit.bor(mask, member:_updateCharacterInfo());

    return mask;
end
