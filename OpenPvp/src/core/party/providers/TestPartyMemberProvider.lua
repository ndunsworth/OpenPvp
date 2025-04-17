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
        name, spec, race, sex = self:_createFakeChar(id);

        cls = spec:classInfo();

        if race == opvp.Race.UNKNOWN then
            race = cls:races()[math.random(1, cls:racesSize())];
        end

        if sex == opvp.Sex.NONE then
            sex = math.random(0, 1);
        end

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

    local name, spec, race, sex;

    while self._fake_chars_dps:isEmpty() == false do
        name, spec, race, sex = unpack(self._fake_chars_dps:popFront());

        if name ~= player_name then
            return name, spec, race, sex;
        end
    end

    spec = opvp.ClassSpec.DPS_SPECS[math.random(1, #opvp.ClassSpec.DPS_SPECS)];

    return "Player" .. index, spec, opvp.Race.UNKNOWN, opvp.Sex.NONE;
end

function opvp.TestPartyMemberProvider:_createFakeCharHealer(index)
    local player_name = opvp.player.name();

    local name, spec, race, sex;

    while self._fake_chars_healer:isEmpty() == false do
        name, spec, race, sex = unpack(self._fake_chars_healer:popFront());

        if name ~= player_name then
            self._healers = self._healers + 1;

            return name, spec, race, sex;
        end
    end

    spec = opvp.ClassSpec.HEALER_SPECS[math.random(1, #opvp.ClassSpec.HEALER_SPECS)];

    self._healers = self._healers + 1;

    return "Player" .. index, spec, opvp.Race.UNKNOWN, opvp.Sex.NONE;
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
            {"Absurd",       opvp.ClassSpec.HOLY_PRIEST,        opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Beep",         opvp.ClassSpec.MISTWEAVER_MONK,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Bopz",         opvp.ClassSpec.RESTORATION_DRUID,  opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Cheesebaker",  opvp.ClassSpec.DISCIPLINE_PRIEST,  opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Likewoah",     opvp.ClassSpec.MISTWEAVER_MONK,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Literal",      opvp.ClassSpec.RESTORATION_SHAMAN, opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Lonstar",      opvp.ClassSpec.RESTORATION_SHAMAN, opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Mythical",     opvp.ClassSpec.MISTWEAVER_MONK,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Nrgy",         opvp.ClassSpec.DISCIPLINE_PRIEST,  opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Salmon",       opvp.ClassSpec.RESTORATION_DRUID,  opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Spaceship",    opvp.ClassSpec.RESTORATION_DRUID,  opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Thedew",       opvp.ClassSpec.RESTORATION_SHAMAN, opvp.Race.UNKNOWN, opvp.Sex.NONE}
        }
    );

    self._fake_chars_dps = opvp.List:createFromArray(
        {
            {"Bellyjeans",   opvp.ClassSpec.MASTER_MARKSMAN_HUNTER, opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Chunchi",      opvp.ClassSpec.WINDWALKER_MONK,        opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"DamBig",       opvp.ClassSpec.ENHANCEMENT_SHAMAN,     opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Ehben",        opvp.ClassSpec.ARCANE_MAGE,            opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Hansolo",      opvp.ClassSpec.FIRE_MAGE,              opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Jahmilycyrus", opvp.ClassSpec.FROST_MAGE,             opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Mvp",          opvp.ClassSpec.HAVOC_DEMON_HUNTER,     opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Pezz",         opvp.ClassSpec.UNHOLY_DEATH_KNIGHT,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Pikadude",     opvp.ClassSpec.SUBTLETY_ROGUE,         opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Ratlord",      opvp.ClassSpec.DESTRUCTION_WARLOCK,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Saulgudman",   opvp.ClassSpec.ELEMENTAL_SHAMAN,       opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Supabreeze",   opvp.ClassSpec.BALANCE_DRUID,          opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Venrookie",    opvp.ClassSpec.FIRE_MAGE,              opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Vikiminahj",   opvp.ClassSpec.ASSASSINATION_ROGUE,    opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Wizman",       opvp.ClassSpec.SHADOW_PRIEST,          opvp.Race.UNKNOWN, opvp.Sex.NONE},
            {"Xenu",         opvp.ClassSpec.FROST_MAGE,             opvp.Race.UNKNOWN, opvp.Sex.NONE}
        }
    );

    self._fake_chars_healer:shuffle();
    self._fake_chars_healer:shuffle();
    self._fake_chars_healer:shuffle();

    self._fake_chars_dps:shuffle();
    self._fake_chars_dps:shuffle();
    self._fake_chars_dps:shuffle();

    if self:hasPlayer() == false then
        return;
    end

    local spec = opvp.player.specInfo();

    if spec:isHealer() == true then
        self._healers = self._healers + 1;
    end

    local party = opvp.party.active();

    if party == nil then
        return;
    end

    local member;
    local spec;

    local members = party:members();
    local index = 1;

    for n=1, #members do
        member = members[n];

        if (
            member:isSpecKnown() == true and
            member:isNameKnown() == true
        ) then
            if member:isHealer() == true then
                self._fake_chars_dps:insert(
                    index,
                    {
                        member:name(),
                        member:specInfo(),
                        member:raceInfo(),
                        member:sex()
                    }
                );

                index = index + 1;
            elseif member:isDps() == true then
                self._fake_chars_dps:insert(
                    index,
                    {
                        member:name(),
                        member:specInfo(),
                        member:raceInfo(),
                        member:sex()
                    }
                );

                index = index + 1;
            end
        end
    end
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
