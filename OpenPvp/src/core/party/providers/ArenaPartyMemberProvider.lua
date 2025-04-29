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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.ArenaPartyMemberProvider = opvp.CreateClass(opvp.PvpPartyMemberProvider);

function opvp.ArenaPartyMemberProvider:init(factory, isShuffle)
    opvp.PvpPartyMemberProvider.init(self, factory);

    self._match_size       = 3;
    self._match_size_fixed = true;
    self._match_unknown    = 0;
    self._is_shuffle       = isShuffle == true;

    self:_setHostile(true);
end

function opvp.ArenaPartyMemberProvider:hasPlayer()
    return false;
end

function opvp.ArenaPartyMemberProvider:isUnitIdSupported(unitId)
    local _, _, id = string.find(unitId, "arena(%d+)");

    return id ~= nil;
end

function opvp.ArenaPartyMemberProvider:tokenExprGroup()
    return "arena(%d+)";
end

function opvp.ArenaPartyMemberProvider:tokenExprParty()
    return "arena(%d+)";
end

function opvp.ArenaPartyMemberProvider:tokenGroup()
    return "arena";
end

function opvp.ArenaPartyMemberProvider:tokenParty()
    return "arena";
end

function opvp.ArenaPartyMemberProvider:_categorySize()
    return GetNumArenaOpponentSpecs();
end

function opvp.ArenaPartyMemberProvider:_connect(category, guid)
    if self._match_size_fixed == true then
        self._match_unknown = self._match_size;
    end

    opvp.PvpPartyMemberProvider._connect(self, category, guid);
end

function opvp.ArenaPartyMemberProvider:_connectSignals()
    opvp.event.ARENA_OPPONENT_UPDATE:connect(self, self._onOpponentUpdate);
    opvp.event.PLAYER_SPECIALIZATION_CHANGED:connect(self, self._onUnitSpecUpdate);
    opvp.event.UNIT_AURA:connect(self, self._onUnitAura);
    opvp.event.UNIT_CONNECTION:connect(self, self._onUnitConnection);
    opvp.event.UNIT_FACTION:connect(self, self._onUnitFactionUpdate);
    opvp.event.UNIT_HEALTH:connect(self, self._onUnitHealth);
    opvp.event.UNIT_NAME_UPDATE:connect(self, self._onUnitNameUpdate);
    opvp.event.UNIT_IN_RANGE_UPDATE:connect(self, self._onUnitRangeUpdate);

    if self._is_shuffle == true then
        opvp.event.GROUP_ROSTER_UPDATE:connect(
            self,
            self._onGroupRosterUpdate
        );
    else
        opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS:connect(
            self,
            self._onOpponentSpecUpdate
        );
    end

    opvp.PvpPartyMemberProvider._connectSignals(self);
end

function opvp.ArenaPartyMemberProvider:_disconnectSignals()
    opvp.event.ARENA_OPPONENT_UPDATE:disconnect(self, self._onOpponentUpdate);
    opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS:disconnect(self, self._onOpponentSpecUpdate);
    opvp.event.GROUP_ROSTER_UPDATE:disconnect(self, self._onGroupRosterUpdate);
    opvp.event.PLAYER_SPECIALIZATION_CHANGED:disconnect(self, self._onUnitSpecUpdate);
    opvp.event.UNIT_AURA:disconnect(self, self._onUnitAura);
    opvp.event.UNIT_CONNECTION:disconnect(self, self._onUnitConnection);
    opvp.event.UNIT_FACTION:disconnect(self, self._onUnitFactionUpdate);
    opvp.event.UNIT_HEALTH:disconnect(self, self._onUnitHealth);
    opvp.event.UNIT_NAME_UPDATE:disconnect(self, self._onUnitNameUpdate);
    opvp.event.UNIT_IN_RANGE_UPDATE:disconnect(self, self._onUnitRangeUpdate);

    opvp.PvpPartyMemberProvider._disconnectSignals(self);
end

function opvp.ArenaPartyMemberProvider:_findMemberByGuid(unitId, create)
    return self:_findMemberByUnitId(unitId, create);
end

function opvp.ArenaPartyMemberProvider:_memberInspect(member)
    local mask = self:_updateMemberSpec(member);

    if self._is_shuffle == true then
        mask = bit.bor(mask, self:_updateMemberScore(member));
    end

    if mask ~= 0 and self:isUpdatingRoster() == false then
        self:_onMemberInfoUpdate(member, mask);
    end

    if self:isUpdatingRoster() == false then
        C_PvP.RequestCrowdControlSpell(member:id());
    end
end

function opvp.ArenaPartyMemberProvider:_onGroupRosterUpdate()
    if self._is_shuffle == true then
        opvp.event.GROUP_ROSTER_UPDATE:disconnect(
            self,
            self._onGroupRosterUpdate
        );

        opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS:connect(
            self,
            self._onOpponentSpecUpdate
        );
    end

    self:_scanMembers();
end

function opvp.ArenaPartyMemberProvider:_onMemberInfoUpdate(member, mask)
    if (
        self._match_size_fixed == true and
        self._match_unknown > 0 and
        member:isInfoComplete() == true and
        bit.band(mask, opvp.PartyMember.CHARACTER_FLAGS) ~= 0
    ) then
        self._match_unknown = self._match_unknown - 1;

        if self._match_unknown == 0 then
            opvp.event.ARENA_OPPONENT_UPDATE:disconnect(
                self,
                self._onOpponentUpdate
            );

            opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS:disconnect(
                self,
                self._onOpponentSpecUpdate
            );
        end
    end

    opvp.PvpPartyMemberProvider._onMemberInfoUpdate(self, member, mask);
end

function opvp.ArenaPartyMemberProvider:_onOpponentSpecUpdate()
    self:_scanMembers();
end

function opvp.ArenaPartyMemberProvider:_onOpponentUpdate(unitId, reason)
    if reason ~= "seen" then
        return;
    end

    local index = self:unitIdPartyIndex(unitId);

    if index < 1 then
        return;
    elseif index > self:size() then
        self:_scanMembers();

        return;
    end

    local member, index, created = self:_findMemberByUnitId(unitId, false);

    if member == nil then
        return;
    end

    local mask = self:_updateMember(unitId, member, created);

    if mask ~= 0 then
        self:_onRosterBeginUpdate();

        self:_onRosterEndUpdate(
            {},
            {{member, mask}},
            {}
        );
    end
end

function opvp.ArenaPartyMemberProvider:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    if self._match_size_fixed == true and self._match_unknown > 0 then
        local member;
        local mask;

        for n=1, #newMembers do
            member = newMembers[n];

            if member:isInfoComplete() == true then
                self._match_unknown = self._match_unknown - 1;
            end
        end

        for n=1, #updatedMembers do
            member, mask = unpack(updatedMembers[n]);

            if (
                member:isInfoComplete() == true and
                bit.band(mask, opvp.PartyMember.CHARACTER_FLAGS) ~= 0
            ) then
                self._match_unknown = self._match_unknown - 1;
            end
        end

        if self._match_unknown == 0 then
            opvp.event.ARENA_OPPONENT_UPDATE:disconnect(
                self,
                self._onOpponentUpdate
            );

            opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS:disconnect(
                self,
                self._onOpponentSpecUpdate
            );
        end
    end

    opvp.PvpPartyMemberProvider._onRosterEndUpdate(self, newMembers, updatedMembers, removedMembers)
end

function opvp.ArenaPartyMemberProvider:_onScoreUpdate()
    opvp.PvpPartyMemberProvider._onScoreUpdate(self);
end

function opvp.ArenaPartyMemberProvider:_setTeamSize(size)
    self._match_size = max(0, size);
end

function opvp.ArenaPartyMemberProvider:_updateMember(unitId, member, created)
    local mask = opvp.PvpPartyMemberProvider._updateMember(self, unitId, member, created);

    if member:trinketState():hasTrinket() == false then
        C_PvP.RequestCrowdControlSpell(member:id());
    end

    if self._is_shuffle == false then
        return mask;
    end

    local name_known = member:isNameKnown();
    local race_known = member:isRaceKnown();

    if name_known == true and race_known == true then
        return mask;
    end

    local info = C_PvP.GetScoreInfoByPlayerGuid(self:guid());

    if info == nil then
        return mask;
    end

    if name_known == false then
        member:_setName(info.name);
    end

    if race_known == false then
        member:_setRace(opvp.Race:fromRaceName(info.raceName));
    end

    return mask;
end

function opvp.ArenaPartyMemberProvider:_updateMemberSpec(member)
    if member:isSpecKnown() == true then
        return 0;
    end

    local index = self:unitIdGroupIndex(member:id());

    if index < 1 then
        return 0;
    end

    local spec, sex = opvp.match.utils.opponentSpec(index);

    if spec:isValid() == false then
        return 0;
    end

    member:_setSpec(spec);

    if member:isSexKnown() == false then
        member:_setSex(sex);

        return bit.bor(opvp.PartyMember.SPEC_FLAG, opvp.PartyMember.SEX_FLAG);
    else
        return opvp.PartyMember.SPEC_FLAG;
    end
end
