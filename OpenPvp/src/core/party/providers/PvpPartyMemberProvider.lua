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

opvp.PvpPartyMemberProvider = opvp.CreateClass(opvp.GenericPartyMemberProvider);

function opvp.PvpPartyMemberProvider:init(factory)
    if factory == nil then
        factory = opvp.PvpPartyMemberFactory();
    end

    self._match      = nil;
    self._arena_cd_updates = false;

    self.scoreUpdate = opvp.Signal("opvp.PvpPartyMemberProvider.scoreUpdate");

    opvp.GenericPartyMemberProvider.init(self);

    assert(
        factory ~= nil and
        opvp.IsInstance(factory, opvp.PvpPartyMemberFactory)
    );

    self:_setFactory(factory);
end

function opvp.PvpPartyMemberProvider:isArena()
    return (
        self._match ~= nil and
        self._match:isArena()
    );
end

function opvp.PvpPartyMemberProvider:isRated()
    return (
        self._match ~= nil and
        self._match:isRated()
    );
end

function opvp.PvpPartyMemberProvider:isFull()
    if self._match ~= nil then
        return self._match:description():teamSize() == self:size()
    else
        return false;
    end
end

function opvp.PvpPartyMemberProvider:_connectSignals()
    opvp.GenericPartyMemberProvider._connectSignals(self);

    if self._arena_cd_updates == true then
        opvp.event.ARENA_COOLDOWNS_UPDATE:connect(
            self,
            self._onArenaCooldownsUpdate
        );

        opvp.event.ARENA_CROWD_CONTROL_SPELL_UPDATE:connect(
            self,
            self._onArenaCrowdControlSpellUpdate
        );
    end

    opvp.event.UPDATE_BATTLEFIELD_SCORE:connect(self, self._onScoreUpdate);
end

function opvp.PvpPartyMemberProvider:_disconnectSignals()
    opvp.GenericPartyMemberProvider._disconnectSignals(self);

    if self._arena_cd_updates == true then
        opvp.event.ARENA_COOLDOWNS_UPDATE:disconnect(
            self,
            self._onArenaCooldownsUpdate
        );

        opvp.event.ARENA_CROWD_CONTROL_SPELL_UPDATE:disconnect(
            self,
            self._onArenaCrowdControlSpellUpdate
        );
    end

    opvp.event.UPDATE_BATTLEFIELD_SCORE:disconnect(self, self._onScoreUpdate);
end

function opvp.PvpPartyMemberProvider:_onArenaCooldownsUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local trinket_state = member:pvpTrinketState();

    local spell_id, start_time, duration = C_PvP.GetArenaCrowdControlInfo(unitId);

    if spell_id == nil then
        return;
    end

    if start_time == nil then
        start_time = 0;
    end

    if duration == nil then
        duration = 0;
    end

    local mask = trinket_state:_onUpdate(
        spell_id,
        start_time / 1000,
        duration / 1000
    );

    if mask ~= 0 then
        self:_onMemberPvpTrinketUpdate(member, mask);
    end
end

function opvp.PvpPartyMemberProvider:_onArenaCrowdControlSpellUpdate(unitId, spellId)
    local member = self:findMemberByUnitId(unitId);

    if member == nil then
        return;
    end

    local trinket_state = member:pvpTrinketState();

    if opvp.spell.isPvpTrinket(spellId) == true then
        if trinket_state:_setTrinket(spellId) == true then
            self:_onMemberPvpTrinketUpdate(member, opvp.PvpTrinketUpdate.TRINKET_CHANGED);
        end
    elseif opvp.spell.isPvpRacialTrinket(spellId) == true then
        if trinket_state:_setRacial(spellId) == true then
            self:_onMemberPvpTrinketUpdate(member, opvp.PvpTrinketUpdate.RACIAL_CHANGED);
        end
    end
end

function opvp.PvpPartyMemberProvider:_onConnected()
    self._match = opvp.match.current();
    self._arena_cd_updates = (
        self:isArena() == true or
        self:isRated() == true or
        self:isHostile() == false
    );

    opvp.GenericPartyMemberProvider._onConnected(self);
end

function opvp.PvpPartyMemberProvider:_onDisconnected()
    opvp.GenericPartyMemberProvider._onDisconnected(self);

    self._match = nil;
end

function opvp.PvpPartyMemberProvider:_onMemberInspect(member, mask)
    opvp.GenericPartyMemberProvider._onMemberInspect(self, member, mask);

    if member:isFriendly() == true then
        local trinket_state = member:pvpTrinketState();
        local result = trinket_state:_setTrinketFromInspect(member:id());

        if result == 1 then
            self:_onMemberPvpTrinketUpdate(member, opvp.PvpTrinketUpdate.TRINKET_CHANGED);
        elseif result < 0 and self._match:isRoundWarmup() == true then
            self:_memberInspect(member);
        end
    end
end

function opvp.PvpPartyMemberProvider:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    local member, mask, valid;

    for n=1, #newMembers do
        member = newMembers[n];

        if member:race() == opvp.HUMAN then
            valid = member:pvpTrinketState():_setRacial(59752);
        elseif member:race() == opvp.UNDEAD then
            valid = member:pvpTrinketState():_setRacial(7744);
        else
            valid = false;
        end

        if valid == true then
            self:_onMemberPvpTrinketUpdate(member, opvp.PvpTrinketUpdate.RACIAL_CHANGED);
        end
    end

    for n=1, #updatedMembers do
        member, mask = unpack(updatedMembers[n]);

        if bit.band(mask, opvp.PartyMember.RACE_FLAG) ~= 0 then
            if member:race() == opvp.HUMAN then
                valid = member:pvpTrinketState():_setRacial(59752);
            elseif member:race() == opvp.UNDEAD then
                valid = member:pvpTrinketState():_setRacial(7744);
            else
                valid = false;
            end

            if valid == true then
                self:_onMemberPvpTrinketUpdate(member, opvp.PvpTrinketUpdate.RACIAL_CHANGED);
            end
        end
    end

    opvp.GenericPartyMemberProvider._onRosterEndUpdate(self, newMembers, updatedMembers, removedMembers);
end

function opvp.PvpPartyMemberProvider:_onScoreUpdate()
    local rated = self:isRated();

    local member;

    for n=1, self:size() do
        self:_updateMemberScore(self:member(n), rated);
    end

    self.scoreUpdate:emit();
end

function opvp.PvpPartyMemberProvider:_updateMember(unitId, member, created)
    if created == true then
        member:_setStats(self._match:map():stats());

        if self._arena_cd_updates == true then
            C_PvP.RequestCrowdControlSpell(member:id());
        end
    end

    return bit.bor(
        opvp.GenericPartyMemberProvider._updateMember(self, unitId, member, created),
        self:_updateMemberSpec(member)
    );
end

function opvp.PvpPartyMemberProvider:_updateMemberScore(member, rated)
    return member:_updateScore(rated);
end

function opvp.PvpPartyMemberProvider:_updateMemberSpec(member)
    return 0;
end
