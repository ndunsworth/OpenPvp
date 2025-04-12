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

opvp.BattlegroundPartyMemberProvider = opvp.CreateClass(opvp.PvpPartyMemberProvider);

function opvp.BattlegroundPartyMemberProvider:init(factory)
    opvp.PvpPartyMemberProvider.init(self, factory);

    self._data    = opvp.List();
    self._faction = opvp.ALLIANCE;
    self._timer   = opvp.Timer(5);

    self._timer.timeout:connect(RequestBattlefieldScoreData);

    self:_setHostile(true);
end

function opvp.BattlegroundPartyMemberProvider:hasPlayer()
    return false;
end

function opvp.BattlegroundPartyMemberProvider:isCrossFaction()
    return false;
end

function opvp.BattlegroundPartyMemberProvider:tokenExprGroup()
    return "enemy(%d+)";
end

function opvp.BattlegroundPartyMemberProvider:tokenExprParty()
    return self:tokenExprGroup();
end

function opvp.BattlegroundPartyMemberProvider:tokenGroup()
    return "enemy";
end

function opvp.BattlegroundPartyMemberProvider:tokenParty()
    return self:tokenGroup();
end

function opvp.BattlegroundPartyMemberProvider:_categorySize()
    return self:size();
end

function opvp.BattlegroundPartyMemberProvider:_connectSignals()

end

function opvp.BattlegroundPartyMemberProvider:_disconnectSignals()

end

function opvp.BattlegroundPartyMemberProvider:_findMemberByUnitId(unitId, create)
    return opvp.PvpPartyMemberProvider._findMemberByUnitId(self, unitId, false);
end

function opvp.BattlegroundPartyMemberProvider:_findMemberByGuid(unitId, create)
    return opvp.PvpPartyMemberProvider._findMemberByGuid(self, unitId, false);
end

function opvp.BattlegroundPartyMemberProvider:_memberInspect(member)

end

function opvp.BattlegroundPartyMemberProvider:_onConnected()
    opvp.PvpPartyMemberProvider._onConnected(self);

    self._faction = (opvp.match.faction() + 1) % 2;

    RequestBattlefieldScoreData();

    --~ self._timer:start();
end

function opvp.BattlegroundPartyMemberProvider:_onDisconnected()
    opvp.PvpPartyMemberProvider._onConnected(self);

    --~ self._timer:stop();

    self._data:clear();
end

function opvp.BattlegroundPartyMemberProvider:_onGroupRosterUpdate()
    local score_size = GetNumBattlefieldScores();

    self._data:clear();

    local score_info;

    for n=1, score_size do
        score_info = C_PvP.GetScoreInfo(n);

        if score_info ~= nil and score_info.faction == self._faction then
            self._data:append(score_info);
        end
    end

    self:_scanMembers();
end

function opvp.BattlegroundPartyMemberProvider:_onInstanceGroupJoined(category, guid)

end

function opvp.BattlegroundPartyMemberProvider:_onInstanceGroupLeft(party)

end

function opvp.BattlegroundPartyMemberProvider:_onMemberEnable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil and member:isEnabled() == false then
        member:_setEnabled(true);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.ENABLED_FLAG);
    end
end

function opvp.BattlegroundPartyMemberProvider:_onMemberDisable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil and member:isEnabled() == true then
        member:_setEnabled(false);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.ENABLED_FLAG);
    end
end

function opvp.BattlegroundPartyMemberProvider:_onMemberInspect(member, mask)

end

function opvp.BattlegroundPartyMemberProvider:_onScoreUpdate()
    self:_onGroupRosterUpdate();

    opvp.PvpPartyMemberProvider._onScoreUpdate(self);
end

function opvp.BattlegroundPartyMemberProvider:_onUnitConnection(unitId, isConnected)

end

function opvp.BattlegroundPartyMemberProvider:_onUnitFlags(unitId)

end

function opvp.BattlegroundPartyMemberProvider:_onUnitHealth(unitId)

end

function opvp.BattlegroundPartyMemberProvider:_onUnitFactionUpdate(unitId)

end

function opvp.BattlegroundPartyMemberProvider:_onUnitNameUpdate(unitId)

end

function opvp.BattlegroundPartyMemberProvider:_onUnitRangeUpdate(unitId, state)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        member:_setFlags(opvp.PartyMember.RANGE_FLAG, state);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.NAME_FLAG);
    end
end

function opvp.BattlegroundPartyMemberProvider:_onUnitSpecUpdate(unitId)

end

function opvp.BattlegroundPartyMemberProvider:_scanMembers()
    if self._data:isEmpty() == true then
        return;
    end

    self:_onRosterBeginUpdate();

    local party_count     = self._data:size();
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
    local score_info;

    for n=1, party_count do
        score_info = self._data:popFront();

        unitid = token .. n;

        member, index, created = self:_findMemberByGuid2(
            unitid,
            score_info.guid,
            true
        );

        assert(member ~= nil);

        if created == true then
            new_members:append(member);

            member:_setName(score_info.name);
            member:_setRace(opvp.Race:fromRaceName(score_info.raceName));
            member:_setSpec(opvp.ClassSpec:fromSpecName(score_info.talentSpec));

            self:_updateMember(unitid, member, created);

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

    self:_onRosterEndUpdate(
        new_members:items(),
        update_members:items(),
        members:items()
    );
end

function opvp.BattlegroundPartyMemberProvider:_updateMember(unitId, member, created)
    local mask = member:mask();

    if unitId ~= member:id() then
        member:_setId(unitid);

        mask = opvp.PartyMember.ID_FLAG;
    end

    if member:isInfoComplete() == true or member:isGuidKnown() == false then
        return mask;
    end

    if member:isNameKnown() == false then
        local name, server = opvp.unit.nameAndServerFromGuid(member:guid());

        if name ~= "" then
            if server ~= GetRealmName() then
                name = name .. "-" .. server;
            end

            member:_setName(name);

            mask = bit.bor(mask, opvp.PartyMember.NAME_FLAG);
        end
    end

    local loc = PlayerLocation:CreateFromGUID(member:guid());

    if loc:IsValid() == false then
        return mask;
    end

    if member:isFactionKnown() == false then
        local faction = opvp.Faction:fromPlayerLocation(loc);

        if faction ~= opvp.Faction.NEUTRAL then
            member:_setFaction(faction);

            mask = bit.bor(mask, opvp.PartyMember.FACTION_FLAG);
        end
    end

    if member:isRaceKnown() == false then
        local race = opvp.Race:fromPlayerLocation(loc);

        if race:isValid() == true then
            member:_setRace(race);

            mask = bit.bor(mask, opvp.PartyMember.RACE_FLAG);
        end
    end

    if member:isSexKnown() == false then
        local sex = C_PlayerInfo.GetSex(loc);

        if sex ~= nil and opvp.Sex.NONE then
            member:_setSex(sex);

            mask = bit.bor(mask, opvp.PartyMember.SEX_FLAG);
        end
    end

    return mask;
end
