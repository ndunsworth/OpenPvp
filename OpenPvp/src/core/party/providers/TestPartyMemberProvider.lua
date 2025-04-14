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

local opvp_test_player_index = 1;

opvp.TestPartyMemberProvider = opvp.CreateClass(opvp.GenericPartyMemberProvider);

function opvp.TestPartyMemberProvider:init(hasPlayer)
    opvp.GenericPartyMemberProvider.init(self);

    self._has_player = hasPlayer == true;

    self._fake_chars  = opvp.List();
    self._healers     = 0;
    self._healers_max = 1;
end

function opvp.TestPartyMemberProvider:addMember()
    self:addMembers(1);
end

function opvp.TestPartyMemberProvider:addMembers(count)
    if self:isConnected() == false then
        return;
    end

    local members = opvp.List();
    local token   = self:tokenGroup();
    local id      = self:size() + 1;
    local server  = GetRealmID();
    local member;
    local name;
    local cls;
    local race;
    local sex;
    local spec;

    if self._has_player == true and self:isRaid() == false then
        id = id - 1;
    end

    for n=1, count do
        name, spec = self:_createFakeChar(id);

        cls = spec:classInfo();

        race = cls:races()[math.random(1, cls:racesSize())];
        sex = math.random(0, 1);

        member = self:_createMember(
            token .. id,
            string.format(
                "TestPlayer-%s-0-%08x",
                server,
                opvp_test_player_index
            )
        );

        if member ~= nil then
            member:_setName(name);
            member:_setRace(race);
            member:_setSex(sex);
            member:_setSpec(spec);

            if race:isNeutralSupported() == true then
                member:_setFaction(race:factions()[2]);
            else
                member:_setFaction(race:factions()[1]);
            end

            members:append(member);

            id = id + 1;
            opvp_test_player_index = opvp_test_player_index + 1;
        end
    end

    if members:isEmpty() == true then
        return;
    end

    self:_onRosterBeginUpdate();

    for n=1, members:size() do
        member = members:item(n);

        self:_updateMember(member:id(), member, true);
    end

    self._members:merge(members);

    self:_onRosterEndUpdate(
        members:items(),
        {},
        {}
    );
end

function opvp.TestPartyMemberProvider:hasPlayer()
    return self._has_player;
end

function opvp.TestPartyMemberProvider:isCrossFaction()
    return true;
end

function opvp.TestPartyMemberProvider:isTest()
    return true;
end

function opvp.TestPartyMemberProvider:_categorySize()
    return self:size();
end

function opvp.TestPartyMemberProvider:_connectSignals()

end

function opvp.TestPartyMemberProvider:_createFakeChar(index)
    if self._healers < self._healers_max then
        return self:_createFakeCharHealer(index);
    else
        return self:_createFakeCharDps(index);
    end
end

function opvp.TestPartyMemberProvider:_createFakeCharDps(index)
    local player_name = opvp.player.name();

    local name, spec;

    while self._fake_chars_dps:isEmpty() == false do
        name, spec = unpack(self._fake_chars_dps:popFront());

        if name ~= player_name then
            return name, spec;
        end
    end

    spec = opvp.ClassSpec.DPS_SPECS[math.random(1, #opvp.ClassSpec.DPS_SPECS)];

    return "Player" .. index, spec;
end

function opvp.TestPartyMemberProvider:_createFakeCharHealer(index)
    local player_name = opvp.player.name();

    local name, spec;

    while self._fake_chars_healer:isEmpty() == false do
        name, spec = unpack(self._fake_chars_healer:popFront());

        if name ~= player_name then
            self._healers = self._healers + 1;

            return name, spec;
        end
    end

    spec = opvp.ClassSpec.HEALER_SPECS[math.random(1, #opvp.ClassSpec.HEALER_SPECS)];

    self._healers = self._healers + 1;

    return "Player" .. index, spec;
end

function opvp.TestPartyMemberProvider:_disconnectSignals()

end

function opvp.TestPartyMemberProvider:_findMemberByUnitId(unitId, create)
    return opvp.GenericPartyMemberProvider._findMemberByUnitId(self, unitId, false);
end

function opvp.TestPartyMemberProvider:_findMemberByGuid(unitId, create)
    return opvp.GenericPartyMemberProvider._findMemberByUnitId(self, unitId, false);
end

function opvp.TestPartyMemberProvider:_memberInspect(member)

end

function opvp.TestPartyMemberProvider:_onConnected()
    opvp.GenericPartyMemberProvider._onConnected(self);

    self._fake_chars_healer = opvp.List:createFromArray(
        {
            {"Absurd",       opvp.ClassSpec.HOLY_PRIEST},
            {"Beep",         opvp.ClassSpec.MISTWEAVER_MONK},
            {"Bopz",         opvp.ClassSpec.RESTORATION_DRUID},
            {"Cheesebaker",  opvp.ClassSpec.DISCIPLINE_PRIEST},
            {"Likewoah",     opvp.ClassSpec.MISTWEAVER_MONK},
            {"Literal",      opvp.ClassSpec.RESTORATION_SHAMAN},
            {"Lonstar",      opvp.ClassSpec.RESTORATION_SHAMAN},
            {"Mythical",     opvp.ClassSpec.MISTWEAVER_MONK},
            {"Nrgy",         opvp.ClassSpec.DISCIPLINE_PRIEST},
            {"Salmon",       opvp.ClassSpec.RESTORATION_DRUID},
            {"Spaceship",    opvp.ClassSpec.RESTORATION_DRUID},
            {"Thedew",       opvp.ClassSpec.RESTORATION_SHAMAN}
        }
    );

    self._fake_chars_dps = opvp.List:createFromArray(
        {
            {"Bellyjeans",   opvp.ClassSpec.MASTER_MARKSMAN_HUNTER},
            {"Chunchi",      opvp.ClassSpec.WINDWALKER_MONK},
            {"DamBig",       opvp.ClassSpec.ENHANCEMENT_SHAMAN},
            {"Ehben",        opvp.ClassSpec.ARCANE_MAGE},
            {"Hansolo",      opvp.ClassSpec.FIRE_MAGE},
            {"Jahmilycyrus", opvp.ClassSpec.FROST_MAGE},
            {"Mvp",          opvp.ClassSpec.HAVOC_DEMON_HUNTER},
            {"Pezz",         opvp.ClassSpec.UNHOLY_DEATH_KNIGHT},
            {"Pikadude",     opvp.ClassSpec.SUBTLETY_ROGUE},
            {"Ratlord",      opvp.ClassSpec.DESTRUCTION_WARLOCK},
            {"Saulgudman",   opvp.ClassSpec.ELEMENTAL_SHAMAN},
            {"Supabreeze",   opvp.ClassSpec.BALANCE_DRUID},
            {"Venrookie",    opvp.ClassSpec.FIRE_MAGE},
            {"Vikiminahj",   opvp.ClassSpec.ASSASSINATION_ROGUE},
            {"Wizman",       opvp.ClassSpec.SHADOW_PRIEST},
            {"Xenu",         opvp.ClassSpec.FROST_MAGE}
        }
    );

    if (
        self:hasPlayer() == true and
        self._player ~= nil and
        self._player:specInfo():isHealer() == true
    ) then
        self._healers = self._healers + 1;
    end

    self._fake_chars_healer:shuffle();
    self._fake_chars_healer:shuffle();
    self._fake_chars_healer:shuffle();

    self._fake_chars_dps:shuffle();
    self._fake_chars_dps:shuffle();
    self._fake_chars_dps:shuffle();
end

function opvp.TestPartyMemberProvider:_onDisconnected()
    opvp.GenericPartyMemberProvider._onDisconnected(self);

    self._fake_chars:clear();

    self._healers     = 0;
    self._healers_max = 1;
end

function opvp.TestPartyMemberProvider:_onGroupRosterUpdate()

end

function opvp.TestPartyMemberProvider:_onInstanceGroupJoined(category, guid)

end

function opvp.TestPartyMemberProvider:_onInstanceGroupLeft(party)

end

function opvp.TestPartyMemberProvider:_onMemberEnable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil and member:isEnabled() == false then
        member:_setEnabled(true);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.ENABLED_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onMemberDisable(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil and member:isEnabled() == true then
        member:_setEnabled(false);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.ENABLED_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onMemberInspect(member, mask)

end

function opvp.TestPartyMemberProvider:_onUnitConnection(unitId, isConnected)

end

function opvp.TestPartyMemberProvider:_onUnitFlags(unitId)

end

function opvp.TestPartyMemberProvider:_onUnitHealth(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        self:_onMemberInfoUpdate(member, opvp.PartyMember.HEALTH_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onUnitFactionUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        self:_onMemberInfoUpdate(member, opvp.PartyMember.FACTION_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onUnitNameUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        self:_onMemberInfoUpdate(member, opvp.PartyMember.NAME_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onUnitRangeUpdate(unitId, state)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        member:_setFlags(opvp.PartyMember.RANGE_FLAG, state);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.NAME_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_onUnitSpecUpdate(unitId)
    local member = self:findMemberByUnitId(unitId);

    if member ~= nil then
        member:_setFlags(opvp.PartyMember.RANGE_FLAG, state);

        self:_onMemberInfoUpdate(member, opvp.PartyMember.SPEC_FLAG);
    end
end

function opvp.TestPartyMemberProvider:_updateMember(unitId, member, created)

end
