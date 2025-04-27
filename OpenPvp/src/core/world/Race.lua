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

opvp.UNKNOWN_RACE        =  0;
opvp.BLOOD_ELF           =  1;
opvp.DARK_IRON_DWARF     =  2;
opvp.DRACTHYR            =  3;
opvp.DRAENEI             =  4;
opvp.DWARF               =  5;
opvp.EARTHEN             =  6;
opvp.GNOME               =  7;
opvp.GOBLIN              =  8;
opvp.HIGHMOUNTAIN_TAUREN =  9;
opvp.HUMAN               = 10;
opvp.KUL_TIRAN           = 11;
opvp.LIGHTFORGED_DRAENEI = 12;
opvp.MAGHAR_ORC          = 13;
opvp.MECHAGNOME          = 14;
opvp.NIGHT_ELF           = 15;
opvp.NIGHTBORNE          = 16;
opvp.ORC                 = 17;
opvp.PANDAREN            = 18;
opvp.TAUREN              = 19;
opvp.TROLL               = 20;
opvp.UNDEAD              = 21;
opvp.VOID_ELF            = 22;
opvp.VULPERA             = 23;
opvp.WORGEN              = 24;
opvp.ZANDALARI_TROLL     = 25;
opvp.MAX_RACE            = opvp.ZANDALARI_TROLL;

local opvp_race_map_from_id_lookup = {
    [ 1] = opvp.HUMAN,
    [ 2] = opvp.ORC,
    [ 3] = opvp.DWARF,
    [ 4] = opvp.NIGHT_ELF,
    [ 5] = opvp.UNDEAD,
    [ 6] = opvp.TAUREN,
    [ 7] = opvp.GNOME,
    [ 8] = opvp.TROLL,
    [ 9] = opvp.GOBLIN,
    [10] = opvp.BLOOD_ELF,
    [11] = opvp.DRAENEI,
    --~ [12] = opvp.FEL_ORC,
    [22] = opvp.WORGEN,
    [24] = opvp.PANDAREN,
    [25] = opvp.PANDAREN,
    [26] = opvp.PANDAREN,
    [27] = opvp.NIGHTBORNE,
    [28] = opvp.HIGHMOUNTAIN_TAUREN,
    [29] = opvp.VOID_ELF,
    [30] = opvp.LIGHTFORGED_DRAENEI,
    [31] = opvp.ZANDALARI_TROLL,
    [32] = opvp.KUL_TIRAN,
    [33] = opvp.HUMAN,
    [34] = opvp.DARK_IRON_DWARF,
    [35] = opvp.VULPERA,
    [36] = opvp.MAGHAR_ORC,
    [37] = opvp.MECHAGNOME,
    [52] = opvp.DRACTHYR,
    [70] = opvp.DRACTHYR,
    [84] = opvp.EARTHEN,
    [85] = opvp.EARTHEN
};

local opvp_race_map_to_id_lookup = {
    [opvp.HUMAN]               =  1,
    [opvp.ORC]                 =  2,
    [opvp.DWARF]               =  3,
    [opvp.NIGHT_ELF]           =  4,
    [opvp.UNDEAD]              =  5,
    [opvp.TAUREN]              =  6,
    [opvp.GNOME]               =  7,
    [opvp.TROLL]               =  8,
    [opvp.GOBLIN]              =  9,
    [opvp.BLOOD_ELF]           = 10,
    [opvp.DRAENEI]             = 11,
    --~ [opvp.FEL_ORC]             = 12,
    [opvp.WORGEN]              = 22,
    [opvp.PANDAREN]            = 24,
    [opvp.PANDAREN]            = 25,
    [opvp.PANDAREN]            = 26,
    [opvp.NIGHTBORNE]          = 27,
    [opvp.HIGHMOUNTAIN_TAUREN] = 28,
    [opvp.VOID_ELF]            = 29,
    [opvp.LIGHTFORGED_DRAENEI] = 30,
    [opvp.ZANDALARI_TROLL]     = 31,
    [opvp.KUL_TIRAN]           = 32,
    [opvp.HUMAN]               = 33,
    [opvp.DARK_IRON_DWARF]     = 34,
    [opvp.VULPERA]             = 35,
    [opvp.MAGHAR_ORC]          = 36,
    [opvp.MECHAGNOME]          = 37,
    [opvp.DRACTHYR]            = 52,
    [opvp.DRACTHYR]            = 70,
    [opvp.EARTHEN]             = 84,
    [opvp.EARTHEN]             = 85
};

opvp.Race = opvp.CreateClass();

function opvp.Race:fromGUID(guid)
    return opvp.Race:fromPlayerLocation(
        PlayerLocation:CreateFromGUID(guid)
    );
end

function opvp.Race:fromPlayerLocation(location)
    return opvp.Race:fromRaceId(C_PlayerInfo.GetRace(location));
end

function opvp.Race:fromRaceId(id)
    local result;

    if id ~= 0 then
        id = opvp_race_map_from_id_lookup[id];

        if id ~= nil then
            result = opvp.Race.RACES[id + 1];
        end
    end

    if result ~= nil then
        return result;
    else
        return opvp.Race.UNKNOWN;
    end
end

function opvp.Race:fromRaceName(name)
    local race;

    for n=1, #opvp.Race.RACES do
        race = opvp.Race.RACES[n];

        if race:name() == name then
            return race;
        end
    end

    return opvp.Race.UNKNOWN;
end

function opvp.Race:init(cfg)
    self._id            = cfg.id;
    self._factions      = cfg.factions;
    self._factions_mask = 0;
    self._name          = ""

    if self._id ~= opvp.UNKNOWN_RACE then
        self._name = C_CreatureInfo.GetRaceInfo(
            opvp_race_map_to_id_lookup[self._id]
        ).raceName;
    end

    for index, faction in ipairs(self._factions) do
        self._factions_mask = bit.bor(
            self._factions_mask,
            bit.lshift(1, faction:id())
        );
    end
end

function opvp.Race:factions()
    return {unpack(self._factions)};
end

function opvp.Race:factionsMask()
    return self._factions_mask;
end

function opvp.Race:id()
    return self._id;
end

function opvp.Race:isAllianceSupported()
    return self:isFactionSupported(opvp.ALLIANCE);
end

function opvp.Race:isFactionSupported(faction)
    return (
        bit.band(
            self._factions_mask,
            bit.lshift(1, faction)
        ) ~= 0
    );
end

function opvp.Race:isHordeSupported()
    return self:isFactionSupported(opvp.HORDE);
end

function opvp.Race:isNeutralSupported()
    return self:isFactionSupported(opvp.NEUTRAL);
end

function opvp.Race:isValid()
    return self._id ~= opvp.UNKNOWN_RACE;
end

function opvp.Race:name()
    return self._name;
end
