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

local opvp_unit_power_type_name_lookup = {
    ALTERNATE          = opvp.PowerType.ALTERNATE,
    ALTERNATEENCOUNTER = opvp.PowerType.ALTERNATE_ENCOUNTER,
    ALTERNATEMOUNT     = opvp.PowerType.ALTERNATE_MOUNT,
    ALTERNATEQUEST     = opvp.PowerType.ALTERNATE_QUEST,
    ARCANECHARGES      = opvp.PowerType.ARCANE_CHARGES,
    BALANCE            = opvp.PowerType.BALANCE,
    BURNINGEMBERS      = opvp.PowerType.BURNINGEMBERS,
    CHI                = opvp.PowerType.CHI,
    COMBOPOINTS        = opvp.PowerType.COMBO_POINTS,
    DEMONICFURY        = opvp.PowerType.DEMONIC_FURY,
    ENERGY             = opvp.PowerType.ENERGY,
    FOCUS              = opvp.PowerType.FOCUS,
    FURY               = opvp.PowerType.FURY,
    HAPPINESS          = opvp.PowerType.HAPPINESS,
    HOLYPOWER          = opvp.PowerType.HOLY_POWER,
    INSANITY           = opvp.PowerType.INSANITY,
    LUNARPOWER         = opvp.PowerType.LUNAR_POWER,
    MAELSTROM          = opvp.PowerType.MAELSTROM,
    MANA               = opvp.PowerType.MANA,
    PAIN               = opvp.PowerType.PAIN,
    RAGE               = opvp.PowerType.RAGE,
    RUNEBLOOD          = opvp.PowerType.RUNE_BLOOD,
    RUNEFROST          = opvp.PowerType.RUNE_FROST,
    RUNEUNHOLY         = opvp.PowerType.RUNE_UNHOLY,
    RUNES              = opvp.PowerType.RUNES,
    RUNICPOWER         = opvp.PowerType.RUNIC_POWER,
    SHADOWORBS         = opvp.PowerType.SHADOW_ORBS,
    SOULSHARDS         = opvp.PowerType.SOUL_SHARDS
};

opvp.Unit = opvp.CreateClass();

function opvp.Unit:createFromUnitGuid(guid)
    local unit = opvp.Unit();

    if guid == nil or guid == "" then
        return unit;
    end

    local loc = PlayerLocation:CreateFromGUID(guid);

    if loc:IsValid() == false then
        return unit;
    end

    unit._guid = guid;
    unit._name = C_PlayerInfo.GetName(loc);

    if unit._name == nil or unit._name == "" then
        --~ C_PlayerInfo.GetName can fail to return a name at times when
        --~ Other methods would succeed. Try a fallback.
        unit._name = GetNameAndServerNameFromGUID(unit._guid);

        if unit._name == nil or unit._name == "" then
            unit:_initNull();

            return unit;
        end
    end

    unit._faction = opvp.Faction:fromPlayerLocation(loc);
    unit._race = opvp.Race:fromPlayerLocation(loc);
    unit._class = opvp.Class:fromPlayerLocation(loc);
    unit._sex = C_PlayerInfo.GetSex(loc);

    if (
        unit._race:isValid() == false or
        unit._race:isFactionSupported(unit._faction:id()) == false or
        unit._class:isValid() == false or
        unit._sex == nil
    ) then
        --~ print(
            --~ unit._race:isValid() == false,
            --~ unit._race:isFactionSupported(unit._faction:id()) == false,
            --~ unit._class:isValid() == false,
            --~ unit._sex == nil,
            --~ unit._race:name(),
            --~ unit._faction:name(),
            --~ unit._faction:id(),
            --~ unit._class:name()
        --~ );

        unit:_initNull();
    end

    return unit;
end

function opvp.Unit:createFromUnitId(unitId)
    local unit = opvp.Unit();

    if unitId == nil then
        return unit;
    end

    unit._name = opvp.unit.name(unitId);

    if UnitExists(unitId) == false then
        unit:_initNull();

        return unit;
    end

    unit._faction = opvp.unit.faction(unitId);
    unit._race    = opvp.unit.race(unitId);

    if unit._race:isValid() == false then
        unit:_initNull();

        return unit;
    end

    unit._class = opvp.unit.class(unitId);

    if unit._class:isValid() == false then
        unit:_initNull();

        return unit;
    end

    local sex = opvp.unit.sex(unitId);

    return unit;
end

function opvp.Unit:init()
    self:_initNull();
end

function opvp.Unit:_initNull()
    self._guid    = "";
    self._name    = "";
    self._faction = opvp.Faction.NEUTRAL;
    self._race    = opvp.Race.UNKNOWN;
    self._class   = opvp.Class.UNKNOWN;
    self._sex     = opvp.Sex.NONE;
end

function opvp.Unit:class()
    return self._class:id();
end

function opvp.Unit:classInfo()
    return self._class;
end

function opvp.Unit:faction()
    return self._faction:id();
end

function opvp.Unit:factionInfo()
    return self._faction;
end

function opvp.Unit:factionOpposite()
    return self._faction:oppositeFaction():id();
end

function opvp.Unit:factionOppositeInfo()
    return self._faction:oppositeFaction();
end

function opvp.Unit:findBuff(spellId)
    local result = nil;

    AuraUtil.ForEachAura(
        self._name,
        "HELPFUL",
        nil,
        function(info)
            if info.spellId == spellId then
                result = info;

                return true;
            end
        end
    );

    return result;
end

function opvp.Unit:findDebuff(spellId)
    local result = nil;

    AuraUtil.ForEachAura(
        self._name,
        "HARMFUL",
        nil,
        function(info)
            if info.spellId == spellId then
                result = info;

                return true;
            end
        end
    );

    return result;
end

function opvp.Unit:guid()
    return self._guid;
end

function opvp.Unit:hasBuff(spellId)
    return self:findBuff(spellId) ~= nil;
end

function opvp.Unit:hasDebuff(spellId)
    return self:findDebuff(spellId) ~= nil;
end

function opvp.Unit:health(spellId)
    return opvp.unit.health(self:id());
end

function opvp.Unit:id()
    return opvp.unit.tokenForGuid(self._guid);
end

function opvp.Unit:isAFK()
    return opvp.unit.isAFK(self:id());
end

function opvp.Unit:isAlliance()
    return self._faction:isAlliance();
end

function opvp.Unit:isDead(unitId)
    return opvp.unit.isDead(self:id());
end

function opvp.Unit:isDeadOrGhost(unitId)
    return opvp.unit.isDeadOrGhost(self:id());
end

function opvp.Unit:isDND()
    return opvp.unit.isDND(self:id());
end

function opvp.Unit:isFeignDeath(unitId)
    return opvp.unit.isFeignDeath(self:id());
end

function opvp.Unit:isGhost(unitId)
    return opvp.unit.isGhost(self:id());
end

function opvp.Unit:isHorde()
    return self._faction:isHorde();
end

function opvp.Unit:isMaxLevel()
    return opvp.unit.isMaxLevel(self:id());
end

function opvp.Unit:isNeutral()
    return self._faction:isNeutral();
end

function opvp.Unit:isNull()
    return self._race:isValid() == false;
end

function opvp.Unit:isPlayer()
    return opvp.unit.isPlayer(self:id());
end

function opvp.Unit:isRace(race)
    if opvp.is_number(race) == true then
        return self._race:id() == race;
    elseif opvp.IsInstance(race, opvp.Race) then
        return self._race == race;
    else
        return false;
    end
end

function opvp.Unit:isSex(sex)
    return self._sex == sex;
end

function opvp.Unit:level()
    return opvp.unit.level(self:id());
end

function opvp.Unit:mapId()
    return opvp.unit.mapId(self:id());
end

function opvp.Unit:mapPosition()
    return opvp.unit.mapPosition(self:id());
end

function opvp.Unit:name()
    return self._name;
end

function opvp.Unit:race()
    return self._race:id();
end

function opvp.Unit:raceInfo()
    return self._race;
end

function opvp.Unit:sendMessage(msg)
    SendChatMessage(
        msg,
        opvp.ChatType.WHISPER,
        nil,
        self._name
    );
end

function opvp.Unit:sex()
    return self._sex;
end

opvp.unit = {};

function opvp.unit.channelInfo(unitId)
    local
    name,
    displayName,
    textureID,
    startTimeMs,
    endTimeMs,
    isTradeskill,
    notInterruptible,
    spellID,
    isEmpowered,
    numEmpowerStages = UnitChannelInfo(unitId);

    if spellID ~= nil then
        return {
            empowered_stages = numEmpowerStages,
            end_time         = endTimeMs / 1000,
            is_empowered     = isEmpowered,
            is_interruptible = notInterruptible,
            is_tradeskill    = isTradeskill,
            label            = displayName,
            name             = name,
            spell_id         = spellID,
            start_time       = startTimeMs / 1000,
            texture          = textureID
        };
    else
        return {
            empowered_stages = 0,
            end_time         = 0,
            is_empowered     = false,
            is_interruptible = false,
            is_tradeskill    = false,
            label            = "",
            name             = "",
            spell_id         = 0,
            start_time       = 0,
            texture          = 0
        };
    end
end

function opvp.unit.castInfo(unitId)
    local
    name,
    text,
    texture,
    startTimeMS,
    endTimeMS,
    isTradeskill,
    castID,
    notInterruptible,
    spellID = UnitCastingInfo(unitId);

    if spellID ~= nil then
        return {
            cast_id          = castID,
            end_time         = endTimeMS / 1000,
            is_interruptible = notInterruptible,
            is_tradeskill    = isTradeSkill,
            label            = text,
            name             = name,
            spell_id         = spellID,
            start_time       = startTimeMS / 1000,
            texture          = texture
        };
    else
        return {
            cast_id          = "",
            end_time         = 0,
            is_interruptible = false,
            is_tradeskill    = false,
            label            = "",
            name             = "",
            spell_id         = 0,
            start_time       = 0,
            texture          = 0
        };
    end
end

function opvp.unit.class(unitId)
    local class_filename, class_id = UnitClassBase(unitId);

    return opvp.Class:fromClassId(class_id);
end

function opvp.unit.exists(unitId)
    return UnitExists(unitId);
end

function opvp.unit.faction(unitId)
    local english_name, localized_name = UnitFactionGroup(unitId);

    if english_name == "Alliance" then
        return opvp.Faction.ALLIANCE;
    elseif english_name == "Horde" then
        return opvp.Faction.HORDE;
    else
        return opvp.Faction.NEUTRAL;
    end
end

function opvp.unit.guid(unitId)
    local guid = UnitGUID(unitId);

    if guid ~= nil then
        return guid;
    else
        return "";
    end
end

function opvp.unit.hasGuild(unitId)
    return opvp.guid.hasGuild(opvp.unit.guid(unitId));
end

function opvp.unit.health(unitId)
    return UnitHealth(unitId);
end

function opvp.unit.isAFK(unitId)
    return UnitIsAFK(unitId);
end

function opvp.unit.isDead(unitId)
    return UnitIsDead(unitId);
end

function opvp.unit.isDeadOrGhost(unitId)
    return UnitIsDeadOrGhost(unitId);
end

function opvp.unit.isDND(unitId)
    return UnitIsDND(unitId);
end

function opvp.unit.isFeignDeath(unitId)
    return UnitIsFeignDeath(unitId);
end

function opvp.unit.isGhost(unitId)
    return UnitIsGhost(unitId);
end

function opvp.unit.isInspectable(unitId)
    return CanInspect(unitId);
end

function opvp.unit.isMaxLevel(unitId)
    return (
        opvp.unit.isPlayer(unitId) == true and
        opvp.unit.level(unitId) == GetMaxLevelForLatestExpansion()
    );
end

function opvp.unit.isPlayer(unitId)
    return UnitIsPlayer(unitId);
end

function opvp.unit.isSameFaction(unitId)
    local a1, a2 = UnitFactionGroup(unitId)
    local b1, b2 = UnitFactionGroup(opvp.unitid.PLAYER);

    return a1 == b1;
end

function opvp.unit.isSameGuild(unitId)
    return UnitIsInMyGuild(unitId);
end

function opvp.unit.isSameUnit(unitId1, unitId2)
    return UnitIsUnit(unitId1, unitId2);
end

function opvp.unit.level(unitId)
    return UnitLevel(unitId);
end

function opvp.unit.mapId(unitId)
    return opvp.number_else(C_Map.GetBestMapForUnit(unitId));
end

function opvp.unit.mapPosition(unitId)
    local map = opvp.unit.mapId(unitId);

    if map ~= 0 then
        return C_Map.GetPlayerMapPosition(map, unitId);
    else
        return CreateVector2D(0, 0);
    end
end

function opvp.unit.name(unitId)
    local name = GetUnitName(unitId, true);

    if name ~= nil and name ~= "" and name ~= "Unknown" then
        return name;
    else
        return "";
    end
end

function opvp.unit.nameAndServer(unitId)
    local name, server = UnitName(unitId);

    if name == nil or name == "" or name == "Unknown" then
        name   = "";
        server = "";
    elseif server == nil or server == "" then
        server = GetRealmName();
    end

    return name, server;
end

function opvp.unit.nameAndServerFromGuid(guid)
    local name, server = GetNameAndServerNameFromGUID(guid);

    if name == nil or name == "" or name == "Unknown" then
        name   = "";
        server = "";
    elseif server == nil or server == "" then
        server = GetRealmName();
    end

    return name, server;
end

function opvp.unit.power(unitId, powerType)
    return UnitPower(unitId, powerType);
end

function opvp.unit.powerMax(unitId, powerType)
    return UnitPowerMax(unitId, powerType);
end

function opvp.unit.powerType(unitId, index)
    return UnitPowerType(unitId, index);
end

function opvp.unit.powerTypeFromToken(powerToken)
    local result = opvp_unit_power_type_name_lookup[powerToken];

    if result ~= nil then
        return result;
    else
        return opvp.PowerType.NONE;
    end
end

function opvp.unit.race(unitId)
    local race_name, race_file, race_id = UnitRace(unitId);

    return opvp.Race:fromRaceId(race_id);
end

function opvp.unit.role(unitId)
    return opvp.Role:fromRoleToken(UnitGroupRolesAssigned(unitId));
end

function opvp.unit.server(unitId)
    local name, server = opvp.unit.nameAndServer(unitId);

    return server;
end

function opvp.unit.serverRelationship(unitId)
    return opvp.number_else(
        UnitRealmRelationship(unitId),
        opvp.ServerRelationship.NONE
    );
end

function opvp.unit.sex(unitId)
    local sex = UnitSex(unitId);

    if sex == 2 then
        return opvp.Sex.MALE;
    elseif sex == 3 then
        return opvp.Sex.FEMALE;
    else
        return opvp.Sex.NEUTRAL;
    end
end

function opvp.unit.splitNameAndServer(characterName)
    local name, server = strsplit("-", characterName, 2);

    if server ~= nil then
        return name, server;
    else
        return characterName, ""
    end
end

function opvp.unit.tokenForGuid(guid)
    local token = UnitTokenFromGUID(guid);

    if token ~= nil then
        return token;
    else
        return "";
    end
end

opvp.guid = {};

function opvp.guid.hasGuild(guid)
    return IsPlayerInGuildFromGUID(guid);
end

function opvp.guid.isSameGuild(guid)
    return IsGuildMember(guid);
end

function opvp.guid.playerInfo(guid)
    local
    cls_loc,
    cls_name,
    race_loc,
    race_name,
    sex,
    name,
    realm = GetPlayerInfoByGUID(guid);

    if sex == 2 then
        sex = opvp.Sex.MALE;
    elseif sex == 3 then
        sex = opvp.Sex.FEMALE;
    else
        sex = opvp.Sex.NEUTRAL;
    end

    return {
        guid  = guid,
        name  = name,
        realm = realm,
        class = opvp.Class:fromFileId(cls_name),
        race  = opvp.Race:fromRaceName(race_loc),
        sex   = sex,
    };
end
