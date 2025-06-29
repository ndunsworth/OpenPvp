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

opvp.PartyMember = opvp.CreateClass();

opvp.PartyMember.AFFILIATION_FLAG    = bit.lshift(1,  0);
opvp.PartyMember.AURAS_FLAG          = bit.lshift(1,  1);
opvp.PartyMember.CAST_FLAG           = bit.lshift(1,  2);
opvp.PartyMember.COMBAT_FLAG         = bit.lshift(1,  3);
opvp.PartyMember.CONNECTED_FLAG      = bit.lshift(1,  4);
opvp.PartyMember.DEAD_FLAG           = bit.lshift(1,  5);
opvp.PartyMember.ENABLED_FLAG        = bit.lshift(1,  6);
opvp.PartyMember.HEALTH_FLAG         = bit.lshift(1,  7);
opvp.PartyMember.FACTION_FLAG        = bit.lshift(1,  8);
opvp.PartyMember.GUID_FLAG           = bit.lshift(1,  9);
opvp.PartyMember.ID_FLAG             = bit.lshift(1, 10);
opvp.PartyMember.NAME_FLAG           = bit.lshift(1, 11);
opvp.PartyMember.PLAYER_FLAG         = bit.lshift(1, 12);
opvp.PartyMember.PVP_TRINKET_FLAG    = bit.lshift(1, 13);
opvp.PartyMember.RACE_FLAG           = bit.lshift(1, 14);
opvp.PartyMember.RANGE_FLAG          = bit.lshift(1, 15);
opvp.PartyMember.RATING_CURRENT_FLAG = bit.lshift(1, 16);
opvp.PartyMember.RATING_GAIN_FLAG    = bit.lshift(1, 17);
opvp.PartyMember.SCORE_FLAG          = bit.lshift(1, 18);
opvp.PartyMember.SEX_FLAG            = bit.lshift(1, 19);
opvp.PartyMember.SPEC_FLAG           = bit.lshift(1, 20);
opvp.PartyMember.TEAM_FLAG           = bit.lshift(1, 21);

opvp.PartyMember.CHARACTER_FLAGS = bit.bor(
    opvp.PartyMember.FACTION_FLAG,
    opvp.PartyMember.ID_FLAG,
    opvp.PartyMember.GUID_FLAG,
    opvp.PartyMember.NAME_FLAG,
    opvp.PartyMember.RACE_FLAG,
    opvp.PartyMember.SEX_FLAG,
    opvp.PartyMember.SPEC_FLAG
);

opvp.PartyMember.CHARACTER_RACE_SEX_MASK = bit.bor(
    opvp.PartyMember.RACE_FLAG,
    opvp.PartyMember.SEX_FLAG
);

opvp.PartyMember.STATE_FLAGS = bit.bor(
    opvp.PartyMember.AURAS_FLAG,
    opvp.PartyMember.CAST_FLAG,
    opvp.PartyMember.COMBAT_FLAG,
    opvp.PartyMember.CONNECTED_FLAG,
    opvp.PartyMember.DEAD_FLAG,
    opvp.PartyMember.ENABLED_FLAG,
    opvp.PartyMember.AFFILIATION_FLAG,
    opvp.PartyMember.RANGE_FLAG,
    opvp.PartyMember.PLAYER_FLAG,
    opvp.PartyMember.PVP_TRINKET_FLAG,
    opvp.PartyMember.RATING_CURRENT_FLAG,
    opvp.PartyMember.RATING_GAIN_FLAG,
    opvp.PartyMember.SCORE_FLAG,
    opvp.PartyMember.TEAM_FLAG
);

opvp.PartyMember.DESTROY_FLAGS = opvp.PartyMember.AURAS_FLAG;

opvp.PartyMember.ALL_FLAGS = bit.bor(
    opvp.PartyMember.CHARACTER_FLAGS,
    opvp.PartyMember.HEALTH_FLAG,
    opvp.PartyMember.STATE_FLAGS
);

function opvp.PartyMember:init()
    self._guid                     = "";
    self._id                       = "";
    self._affiliation              = opvp.Affiliation.UNKNOWN;
    self._faction                  = opvp.Faction.NEUTRAL;
    self._race                     = opvp.Race.UNKNOWN;
    self._sex                      = opvp.Sex.NONE;
    self._spec                     = opvp.ClassSpec.UNKNOWN;
    self._name                     = "";
    self._server                   = "";
    self._mask                     = 0;
    self._auras                    = opvp.PartyMemberAuraMap();
    self._cc_state                 = opvp.CrowdControlState();
    self._def_state                = opvp.DefensiveCombatLevelState();
    self._off_state                = opvp.OffensiveCombatLevelState();
    self._pvp_trinket_state        = opvp.PvpTrinketState();
    self._casting_id               = "";
    self._casting_spell_id         = 0;
    self._casting_spell_start      = 0;
    self._casting_spell_end        = 0;
    self._last_casting_id          = "";
    self._last_casting_spell_id    = 0;
    self._last_casting_spell_start = 0;
    self._last_casting_spell_end   = 0;
    self._channeling               = false;
end

function opvp.PartyMember:affiliation()
    return self._affiliation;
end

function opvp.PartyMember:auras()
    return self._auras;
end

function opvp.PartyMember:castingEndTime()
    return self._casting_spell_end;
end

function opvp.PartyMember:castingEndTimePrev()
    return self._last_casting_spell_end;
end

function opvp.PartyMember:castingGuid()
    return self._casting_id;
end

function opvp.PartyMember:castingSpellId()
    return self._casting_spell_id;
end

function opvp.PartyMember:castingSpellIdPrev()
    return self._last_casting_spell_id;
end

function opvp.PartyMember:castingSpellDuration()
    if self._casting_spell_id ~= 0 then
        return self._casting_spell_end - self._casting_spell_start;
    else
        return 0;
    end
end

function opvp.PartyMember:castingSpellDurationPrev()
    if self._last_casting_spell_id ~= 0 then
        return self._last_casting_spell_end - self._last_casting_spell_start;
    else
        return 0;
    end
end

function opvp.PartyMember:castingStartTime()
    return self._casting_spell_start;
end

function opvp.PartyMember:castingStartTimePrev()
    return self._last_casting_spell_start;
end

function opvp.PartyMember:ccState()
    return self._cc_state;
end

function opvp.PartyMember:class()
    return self._spec:class();
end

function opvp.PartyMember:classInfo()
    return self._spec:classInfo();
end

function opvp.PartyMember:defensiveLevel()
    return self._def_state:level();
end

function opvp.PartyMember:defensiveState()
    return self._def_state;
end

function opvp.PartyMember:faction()
    return self._faction:id();
end

function opvp.PartyMember:factionInfo()
    return self._faction;
end

function opvp.PartyMember:findAurasForSpell(spell)
    return self._auras:findBySpell(spell);
end

function opvp.PartyMember:findAurasForSpellId(spellId)
    return self._auras:findBySpellId(spellId);
end

function opvp.PartyMember:guid()
    return self._guid;
end

function opvp.PartyMember:hasDr(category)
    return self.self._cc_state:hasDr(category);
end

function opvp.PartyMember:hasAura(aura)
    return self._auras:contains(aura);
end

function opvp.PartyMember:hasAuraForSpell(spell)
    return self._auras:containsSpell(spell);
end

function opvp.PartyMember:hasAuraForSpellId(spellId)
    return self._auras:containsSpellId(spell);
end

function opvp.PartyMember:hasTeam()
    return self._team ~= nil;
end

function opvp.PartyMember:health()
    return opvp.unit.health(self._id);
end

function opvp.PartyMember:id()
    return self._id;
end

function opvp.PartyMember:inRange()
    return bit.band(self._mask, opvp.PartyMember.RANGE_FLAG) ~= 0;
end

function opvp.PartyMember:isAlive()
    return bit.band(self._mask, opvp.PartyMember.DEAD_FLAG) == 0;
end

function opvp.PartyMember:isCasting()
    return self._casting_spell_id ~= 0;
end

function opvp.PartyMember:isChanneling()
    return self._channeling == true;
end

function opvp.PartyMember:isConnected()
    return bit.band(self._mask, opvp.PartyMember.CONNECTED_FLAG) ~= 0;
end

function opvp.PartyMember:isCrowdControlled()
    return self._cc_state:isCrowdControlled()
end

function opvp.PartyMember:isDead()
    return bit.band(self._mask, opvp.PartyMember.DEAD_FLAG) ~= 0;
end

function opvp.PartyMember:isDisarmed()
    return self._cc_state:isDisarmed();
end

function opvp.PartyMember:isDisoriented()
    return self._cc_state:isDisoriented();
end

function opvp.PartyMember:isDps()
    return self._spec:isDps();
end

function opvp.PartyMember:isEnabled()
    return bit.band(self._mask, opvp.PartyMember.ENABLED_FLAG) ~= 0;
end

function opvp.PartyMember:isFriendly()
    return self._affiliation == opvp.Affiliation.FRIENDLY;
end

function opvp.PartyMember:isHealer()
    return self._spec:isHealer();
end

function opvp.PartyMember:isHostile()
    return self._affiliation == opvp.Affiliation.HOSTILE;
end

function opvp.PartyMember:isIncapacitated()
    return self._cc_state:isIncapacitated();
end

function opvp.PartyMember:isKnockedBack()
    return self._cc_state:isKnockedBack();
end

function opvp.PartyMember:isInfoComplete()
    return self._mask == opvp.PartyMember.CHARACTER_FLAGS;
end

function opvp.PartyMember:isFactionKnown()
    return bit.band(self._mask, opvp.PartyMember.FACTION_FLAG) ~= 0;
end

function opvp.PartyMember:isGuidKnown()
    return bit.band(self._mask, opvp.PartyMember.GUID_FLAG) ~= 0;
end

function opvp.PartyMember:isIdKnown()
    return bit.band(self._mask, opvp.PartyMember.ID_FLAG) ~= 0;
end

function opvp.PartyMember:isKnownAll(mask)
    return bit.band(self._mask, mask) ~= mask;
end

function opvp.PartyMember:isKnownAny(mask)
    return bit.band(self._mask, mask) ~= 0;
end

function opvp.PartyMember:isNameKnown()
    return bit.band(self._mask, opvp.PartyMember.NAME_FLAG) ~= 0;
end

function opvp.PartyMember:isNull()
    return self._guid == "";
end

function opvp.PartyMember:isPlayer()
    return bit.band(self._mask, opvp.PartyMember.PLAYER_FLAG) ~= 0;
end

function opvp.PartyMember:isPvp()
    return false;
end

function opvp.PartyMember:isRaceKnown()
    return bit.band(self._mask, opvp.PartyMember.RACE_FLAG) ~= 0;
end

function opvp.PartyMember:isRooted()
    return self._cc_state:isRooted();
end

function opvp.PartyMember:isSilenced()
    return self._cc_state:isSilenced();
end

function opvp.PartyMember:isSexKnown()
    return bit.band(self._mask, opvp.PartyMember.SEX_FLAG) ~= 0;
end

function opvp.PartyMember:isSpecKnown()
    return bit.band(self._mask, opvp.PartyMember.SPEC_FLAG) ~= 0;
end

function opvp.PartyMember:isStunned()
    return self._cc_state:isStunned();
end

function opvp.PartyMember:isTank()
    return self._spec:isTank();
end

function opvp.PartyMember:isTaunted()
    return self._cc_state:isTaunted();
end

function opvp.PartyMember:mask()
    return self._mask;
end

function opvp.PartyMember:name(includeSpec, excludeServer)
    local name = self._name;

    if name == "" then
        return name;
    end

    if excludeServer ~= true then
        name = name .. "-" .. self._server;
    end

    if includeSpec == true then
        local cls = self._spec:classInfo();

        if self:isSpecKnown() == true then
            name = string.format(
                "%s (|c%s%s %s|r)",
                name,
                cls:color():GenerateHexColor(),
                self._spec:name(),
                self._spec:classInfo():name()
            );
        else
            name = string.format(
                "%s (|c%s%s|r)",
                name,
                cls:color():GenerateHexColor(),
                opvp.strs.UNKNOWN
            );
        end
    end

    return name;
end

function opvp.PartyMember:nameOrId(includeSpec, excludeServer)
    if self:isNameKnown() == true then
        return self:name(includeSpec, excludeServer);
    end

    local name = self._id;

    if includeSpec == true then
        local cls = self._spec:classInfo();

        if self:isSpecKnown() == true then
            name = string.format(
                "%s (|c%s%s %s|r)",
                name,
                cls:color():GenerateHexColor(),
                self._spec:name(),
                self._spec:classInfo():name()
            );
        else
            name = string.format(
                "%s (|c%s%s|r)",
                name,
                cls:color():GenerateHexColor(),
                opvp.strs.UNKNOWN
            );
        end
    end

    return name;
end

function opvp.PartyMember:offensiveLevel()
    return self._off_state:level();
end

function opvp.PartyMember:offensiveState()
    return self._off_state;
end

function opvp.PartyMember:pvpTrinketState()
    return self._pvp_trinket_state;
end

function opvp.PartyMember:race()
    return self._race:id();
end

function opvp.PartyMember:raceInfo()
    return self._race;
end

function opvp.PartyMember:role()
    return self._spec:role();
end

function opvp.PartyMember:race()
    return self._race:id();
end

function opvp.PartyMember:raceInfo()
    return self._race;
end

function opvp.PartyMember:server()
    return self._server;
end

function opvp.PartyMember:sex()
    return self._sex;
end

function opvp.PartyMember:spec()
    return self._spec:id();
end

function opvp.PartyMember:specInfo()
    return self._spec;
end

function opvp.PartyMember:_reset(mask)
    if bit.band(mask, opvp.PartyMember.CHARACTER_FLAGS) == opvp.PartyMember.CHARACTER_FLAGS then
        self._guid    = "";
        self._id      = "";
        self._faction = opvp.Faction.NEUTRAL;
        self._race    = opvp.Race.UNKNOWN;
        self._sex     = opvp.Sex.NONE;
        self._spec    = opvp.ClassSpec.UNKNOWN;
        self._name    = "";
        self._server  = "";
    else
        if bit.band(mask, opvp.PartyMember.GUID_FLAG) ~= 0 then
            self._guid = "";
        end

        if bit.band(mask, opvp.PartyMember.ID_FLAG) ~= 0 then
            self._id = "";
        end

        if bit.band(mask, opvp.PartyMember.NAME_FLAG) ~= 0 then
            self._name = "";
            self._server  = "";
        end

        if bit.band(mask, opvp.PartyMember.FACTION_FLAG) ~= 0 then
            self._faction = opvp.Faction.NEUTRAL;
        end

        if bit.band(mask, opvp.PartyMember.RACE_FLAG) ~= 0 then
            self._race = opvp.Race.UNKNOWN;
        end

        if bit.band(mask, opvp.PartyMember.SEX_FLAG) ~= 0 then
            self._sex = opvp.Sex.NONE;
        end

        if bit.band(mask, opvp.PartyMember.SPEC_FLAG) ~= 0 then
            self._spec = opvp.ClassSpec.UNKNOWN;
        end
    end

    if bit.band(mask, opvp.PartyMember.AFFILIATION_FLAG) ~= 0 then
        self:_setAffiliation(opvp.Affiliation.UNKNOWN)
    end

    if bit.band(mask, opvp.PartyMember.AURAS_FLAG) ~= 0 then
        self._auras:_clear();

        self._cc_state:_clear();
        self._def_state:_clear();
        self._off_state:_clear();
    end

    if bit.band(mask, opvp.PartyMember.CAST_FLAG) then
        self._casting_id          = "";
        self._casting_spell_id    = 0;
        self._casting_spell_start = 0;
        self._casting_spell_end   = 0;
    end

    if bit.band(mask, opvp.PartyMember.PVP_TRINKET_FLAG) then
        self._pvp_trinket_state:_reset();
    end

    self._mask = bit.band(self._mask, bit.bnot(mask));
end

function opvp.PartyMember:_setAffiliation(id)
    self:_setFlags(
        opvp.PartyMember.AFFILIATION_FLAG,
        id ~= opvp.Affiliation.UNKNOWN
    );

    self._affiliation = id;
end

function opvp.PartyMember:_setAlive(state)
    self:_setFlags(
        opvp.PartyMember.DEAD_FLAG,
        not state
    );
end

function opvp.PartyMember:_setConnected(state)
    self:_setFlags(
        opvp.PartyMember.CONNECTED_FLAG,
        state
    );
end

function opvp.PartyMember:_setDead(state)
    self:_setFlags(
        opvp.PartyMember.DEAD_FLAG,
        state
    );
end

function opvp.PartyMember:_setEnabled(state)
    self:_setFlags(
        opvp.PartyMember.ENABLED_FLAG,
        state
    );
end

function opvp.PartyMember:_setFaction(faction)
    if opvp.is_number(faction) then
        self._faction = opvp.Faction:fromId(faction);
    else
        self._faction = faction;
    end

    self:_setFlags(
        opvp.PartyMember.FACTION_FLAG,
        self._faction:isNeutral() == false
    );
end

function opvp.PartyMember:_setFlags(flags, state)
    if state == true then
        self._mask = bit.bor(self._mask, flags);
    else
        self._mask = bit.band(self._mask, bit.bnot(flags));
    end
end

function opvp.PartyMember:_setFriendly(state)
    assert(opvp.is_bool(state));

    if state == true then
        self:_setAffiliation(opvp.Affiliation.FRIENDLY);
    else
        self:_setAffiliation(opvp.Affiliation.HOSTILE);
    end
end

function opvp.PartyMember:_setGUID(guid)
    if guid == nil or guid == "" then
        self._guid = "";

        self:_setFlags(
            opvp.PartyMember.GUID_FLAG,
            false
        );
    else
        self._guid = guid;

        self:_setFlags(
            opvp.PartyMember.GUID_FLAG,
            true
        );
    end
end

function opvp.PartyMember:_setHostile(state)
    if state == true then
        self:_setAffiliation(opvp.Affiliation.HOSTILE);
    else
        self:_setAffiliation(opvp.Affiliation.FRIENDLY);
    end
end

function opvp.PartyMember:_setId(id)
    self._id = id;

    local valid = self._id ~= "";

    self:_setFlags(
        opvp.PartyMember.ID_FLAG,
        valid
    );

    if self:isGuidKnown() == false and valid == true then
        self._auras:update(self._id);
    end
end

function opvp.PartyMember:_setInRange(state)
    self:_setFlags(
        opvp.PartyMember.RANGE_FLAG,
        state
    );
end

function opvp.PartyMember:_setName(name)
    if name ~= "" then
        self._name, self._server = opvp.unit.splitNameAndServer(name);

        if self._server == "" then
            self._server = opvp.unit.server("player");
        end

        assert(self._name ~= nil and self._server ~= nil);

        self:_setFlags(
            opvp.PartyMember.NAME_FLAG,
            true
        );
    else
        self._name   = "";
        self._server = "";

        self:_setFlags(
            opvp.PartyMember.NAME_FLAG,
            false
        );
    end
end

function opvp.PartyMember:_setRace(race)
    self._race = race;

    self:_setFlags(
        opvp.PartyMember.RACE_FLAG,
        self._race:isValid()
    );
end

function opvp.PartyMember:_setSex(sex)
    self._sex = sex;

    self:_setFlags(
        opvp.PartyMember.SEX_FLAG,
        self._sex ~= opvp.Sex.NONE
    );
end

function opvp.PartyMember:_setSpec(spec)
    self._spec = spec;

    self:_setFlags(
        opvp.PartyMember.SPEC_FLAG,
        self._spec:isValid()
    );
end

function opvp.PartyMember:_setSpellCasting(guid, spellId, startTime, endTime)
    if self._casting_spell_id ~= 0 then
        self._last_casting_id          = self._casting_id;
        self._last_casting_spell_id    = self._casting_spell_id;
        self._last_casting_spell_start = self._casting_spell_start;
        self._last_casting_spell_end   = self._casting_spell_end;
    end

    if guid == nil then
        guid = "";
    end

    self._casting_id          = guid;
    self._casting_spell_id    = spellId;
    self._casting_spell_start = startTime;
    self._casting_spell_end   = endTime;
    self._channeling          = false;
end

function opvp.PartyMember:_setSpellChanneling(guid, spellId, startTime, endTime)
    if self._casting_spell_id ~= 0 then
        self._last_casting_id          = self._casting_id;
        self._last_casting_spell_id    = self._casting_spell_id;
        self._last_casting_spell_start = self._casting_spell_start;
        self._last_casting_spell_end   = self._casting_spell_end;
    end

    if guid == nil then
        guid = "";
    end

    self._casting_id          = guid;
    self._casting_spell_id    = spellId;
    self._casting_spell_start = startTime;
    self._casting_spell_end   = endTime;
    self._channeling          = spellId ~= 0;
end

function opvp.PartyMember:_updateAuras(info, aurasNew, aurasModified, aurasRemoved)
    return self._auras:updateFromEvent(self._id, info, aurasNew, aurasModified, aurasRemoved);
end

function opvp.PartyMember:_updateCharacterInfo()
    if self:isInfoComplete() == false then
        if self:isGuidKnown() == true then
            return self:_updateCharacterInfoByGuid();
        elseif self:isIdKnown() then
            return self:_updateCharacterInfoById();
        end
    end

    return 0;
end

function opvp.PartyMember:_updateCharacterInfoById()
    local old_mask = self._mask;

    if self:isGuidKnown() == false then
        local guid = opvp.unit.guid(self._id);

        if guid ~= nil and guid ~= "" then
            self._guid = guid;

            self:_setFlags(
                opvp.PartyMember.GUID_FLAG,
                true
            );
        end
    end

    if self:isNameKnown() == false then
        local name, server;

        if self:isGuidKnown() == true then
            name, server = opvp.unit.nameAndServerFromGuid(self._guid);

            if name == "" then
                name, server = opvp.unit.nameAndServer(self._id);
            end
        else
            name, server = opvp.unit.nameAndServer(self._id);
        end

        if name ~= "" then
            self._name = name;
            self._server = server;

            assert(self._name ~= nil and self._server ~= nil);

            self._mask = bit.bor(self._mask, opvp.PartyMember.NAME_FLAG);
        end
    end

    if self:isFactionKnown() == false then
        local faction = opvp.unit.faction(self._id);

        if faction ~= opvp.Faction.NEUTRAL then
            self._faction = faction;

            self._mask = bit.bor(self._mask, opvp.PartyMember.FACTION_FLAG);
        end
    end

    if self:isRaceKnown() == false then
        local race = opvp.unit.race(self._id);

        if race:isValid() == true then
            self._race = race;

            self._mask = bit.bor(self._mask, opvp.PartyMember.RACE_FLAG);
        end
    end

    if self:isSexKnown() == false then
        local sex = opvp.unit.sex(self._id);

        if sex ~= opvp.Sex.NEUTRAL then
            self._sex = sex;

            self._mask = bit.bor(self._mask, opvp.PartyMember.SEX_FLAG);
        end
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end

function opvp.PartyMember:_updateCharacterInfoByGuid()
    local loc = PlayerLocation:CreateFromGUID(self._guid);

    if loc:IsValid() == false then
        return self:_updateCharacterInfoById();
    end

    local old_mask = self._mask;

    if self:isNameKnown() == false then
        local name, server = opvp.unit.nameAndServerFromGuid(self._guid);

        if name == "" then
            name, server = opvp.unit.nameAndServer(self._id);
        end

        if name ~= "" then
            self._name = name;
            self._server = server;

            assert(self._name ~= nil and self._server ~= nil);

            self._mask = bit.bor(self._mask, opvp.PartyMember.NAME_FLAG);
        end
    end

    if self:isFactionKnown() == false then
        local faction = opvp.Faction:fromPlayerLocation(loc);

        if faction ~= opvp.Faction.NEUTRAL then
            self._faction = faction;

            self._mask = bit.bor(self._mask, opvp.PartyMember.FACTION_FLAG);
        end
    end

    if self:isRaceKnown() == false then
        local race = opvp.Race:fromPlayerLocation(loc);

        if race:isValid() == true then
            self._race = race;

            self._mask = bit.bor(self._mask, opvp.PartyMember.RACE_FLAG);
        else
            race = opvp.unit.race(self._id);

            if race:isValid() == true then
                self._race = race;

                self._mask = bit.bor(self._mask, opvp.PartyMember.RACE_FLAG);
            end
        end
    end

    if self:isSexKnown() == false then
        local sex = C_PlayerInfo.GetSex(loc);

        if sex ~= nil and opvp.Sex.NONE then
            self._sex = sex;

            self._mask = bit.bor(self._mask, opvp.PartyMember.SEX_FLAG);
        else
            sex = opvp.unit.sex(self._id);

            if sex ~= opvp.Sex.NEUTRAL then
                self._sex = sex;

                self._mask = bit.bor(self._mask, opvp.PartyMember.SEX_FLAG);
            end
        end
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end

function opvp.PartyMember:_updateCharacterRaceSex()
    if bit.band(self._mask, opvp.PartyMember.CHARACTER_RACE_SEX_MASK) ~= opvp.PartyMember.CHARACTER_RACE_SEX_MASK then
        if self:isGuidKnown() == true then
            return self:_updateCharacterRaceSexByGuid();
        elseif self:isIdKnown() then
            return self:_updateCharacterRaceSexById();
        end
    end

    return 0;
end

function opvp.PartyMember:_updateCharacterRaceSexById()
    local old_mask = self._mask;

    if self:isRaceKnown() == false then
        local race = opvp.unit.race(self._id);

        if race:isValid() == true then
            self._race = race;

            self._mask = bit.bor(self._mask, opvp.PartyMember.RACE_FLAG);
        end
    end

    if self:isSexKnown() == false then
        local sex = opvp.unit.sex(self._id);

        if sex ~= opvp.Sex.NEUTRAL then
            self._sex = sex;

            self._mask = bit.bor(self._mask, opvp.PartyMember.SEX_FLAG);
        end
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end

function opvp.PartyMember:_updateCharacterRaceSexByGuid()
    local loc = PlayerLocation:CreateFromGUID(self._guid);

    if loc:IsValid() == false then
        return self:_updateCharacterRaceSexById();
    end

    local old_mask = self._mask;

    if self:isRaceKnown() == false then
        local race = opvp.Race:fromPlayerLocation(loc);

        if race:isValid() == true then
            self._race = race;

            self._mask = bit.bor(self._mask, opvp.PartyMember.RACE_FLAG);
        end
    end

    if self:isSexKnown() == false then
        local sex = C_PlayerInfo.GetSex(loc);

        if sex ~= nil and opvp.Sex.NONE then
            self._sex = sex;

            self._mask = bit.bor(self._mask, opvp.PartyMember.SEX_FLAG);
        end
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end
