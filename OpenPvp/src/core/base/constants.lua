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

opvp.private = {
    state = {}
};

opvp.MAJOR_VERSION   = 1;
opvp.MINOR_VERSION   = 0;
opvp.RELEASE_VERSION = 7;

opvp.VERSION         = string.format(
    "%d.%dv%d",
    opvp.MAJOR_VERSION,
    opvp.MINOR_VERSION,
    opvp.RELEASE_VERSION
);

opvp.UNKNOWN_CLASS = 0;
opvp.DEATH_KNIGHT  = 6;
opvp.DEMON_HUNTER  = 12;
opvp.DRUID         = 11;
opvp.EVOKER        = 13;
opvp.HUNTER        = 3;
opvp.MAGE          = 8;
opvp.MONK          = 10;
opvp.PALADIN       = 2;
opvp.PRIEST        = 5;
opvp.ROGUE         = 4;
opvp.SHAMAN        = 7;
opvp.WARLOCK       = 9;
opvp.WARRIOR       = 1;
opvp.MAX_CLASS     = 13;

opvp.Affiliation = {
    UNKNOWN  = 0,
    NEUTRAL  = bit.lshift(1, 0),
    FRIENDLY = bit.lshift(1, 1),
    HOSTILE  = bit.lshift(1, 2)
};

opvp.CrowdControlStatus = {
    FULL    = 1,
    HALF    = 2,
    QUARTER = 3,
    TAUNT_2 = 4,
    TAUNT_3 = 5,
    TAUNT_4 = 6,
    IMMUNE  = 7
};

opvp.CrowdControlType = {
    NONE         = 0,
    DISARM       = bit.lshift(1, 0),
    DISORIENT    = bit.lshift(1, 1),
    INCAPACITATE = bit.lshift(1, 2),
    KNOCKBACK    = bit.lshift(1, 3),
    ROOT         = bit.lshift(1, 4),
    SILENCE      = bit.lshift(1, 5),
    STUN         = bit.lshift(1, 6),
    TAUNT        = bit.lshift(1, 7)
};

opvp.DispellType = {
    NONE         = 0,
    BLEED        = 1,
    CURSE        = 2,
    DISEASE      = 3,
    ENRAGE       = 4,
    MAGIC        = 5,
    POISON       = 6
};

opvp.LootMethod = {
    FREE_FOR_ALL      = 1,
    GROUP             = 2,
    MASTER            = 3,
    NEED_BEFORE_GREED = 4,
    ROUNDROBIN        = 5
};

opvp.LootThreshold = {
    POOR      = 0,
    UNCOMMON  = 1,
    RARE      = 2,
    EPIC      = 3,
    LEGENDARY = 4,
    ARTIFACT  = 5
};

opvp.PowerType = {
    NONE                = -1,
    ALTERNATE           = Enum.PowerType.Alternate,
    ALTERNATE_ENCOUNTER = Enum.PowerType.AlternateEncounter,
    ALTERNATE_MOUNT     = Enum.PowerType.AlternateMount,
    ALTERNATE_QUEST     = Enum.PowerType.AlternateQuest,
    ARCANE_CHARGES      = Enum.PowerType.ArcaneCharges,
    BALANCE             = Enum.PowerType.Balance,
    BURNINGEMBERS       = Enum.PowerType.BurningEmbers,
    CHI                 = Enum.PowerType.Chi,
    COMBO_POINTS        = Enum.PowerType.ComboPoints,
    DEMONIC_FURY        = Enum.PowerType.DemonicFury,
    ENERGY              = Enum.PowerType.Energy,
    FOCUS               = Enum.PowerType.Focus,
    FURY                = Enum.PowerType.Fury,
    HAPPINESS           = Enum.PowerType.Happiness,
    HOLY_POWER          = Enum.PowerType.HolyPower,
    INSANITY            = Enum.PowerType.Insanity,
    LUNAR_POWER         = Enum.PowerType.LunarPower,
    MAELSTROM           = Enum.PowerType.Maelstrom,
    MANA                = Enum.PowerType.Mana,
    PAIN                = Enum.PowerType.Pain,
    RAGE                = Enum.PowerType.Rage,
    RUNE_BLOOD          = Enum.PowerType.RuneBlood,
    RUNE_FROST          = Enum.PowerType.RuneFrost,
    RUNE_UNHOLY         = Enum.PowerType.RuneUnholy,
    RUNES               = Enum.PowerType.Runes,
    RUNIC_POWER         = Enum.PowerType.RunicPower,
    SHADOW_ORBS         = Enum.PowerType.ShadowOrbs,
    SOUL_SHARDS         = Enum.PowerType.SoulShards
};

opvp.PvpType = {
    NONE         = 0,
    ARENA        = 1,
    BATTLEGROUND = 2
};

opvp.PvpFlag = {
    BLITZ      = bit.lshift(1,  0),
    BRAWL      = bit.lshift(1,  1),
    CTF        = bit.lshift(1,  2),
    DAMPENING  = bit.lshift(1,  3),
    EPIC       = bit.lshift(1,  4),
    ESCORT     = bit.lshift(1,  5),
    EVENT      = bit.lshift(1,  6),
    NODE       = bit.lshift(1,  7),
    RANDOM     = bit.lshift(1,  8),
    RANDOM_MAP = bit.lshift(1,  9),
    RATED      = bit.lshift(1, 10),
    RBG        = bit.lshift(1, 11),
    RESOURCE   = bit.lshift(1, 12),
    ROUND      = bit.lshift(1, 13),
    SCENARIO   = bit.lshift(1, 14),
    SHUFFLE    = bit.lshift(1, 15),
    SKIRMISH   = bit.lshift(1, 16),
    VEHICLE    = bit.lshift(1, 17),
    ZONE       = bit.lshift(1, 18)
};

opvp.PvpStatId = {
    NONE                  = 0,
    AZERITE_COLLECTED     =  1,
    BASES_ASSAULTED       =  2,
    BASES_DEFENDED        =  3,
    BUILDINGS_DESTROYED   =  4,
    CARTS_CONTROLLED      =  5,
    DEMOLISHERS_DESTROYED =  6,
    FLAG_CAPTURES         =  7,
    FLAG_RETURNS          =  8,
    GATES_DESTROYED       =  9,
    GRAVEYARDS_ASSAULTED  = 10,
    GRAVEYARDS_DEFENDED   = 11,
    ORB_POSSESSIONS       = 12,
    ROUNDS_WON            = 13,
    SECONDARY_OBJECTIVES  = 14,
    TOWERS_ASSAULTED      = 15,
    TOWERS_DEFENDED       = 16,
    VICTORY_POINTS        = 17,
    WALLS_DESTROYED       = 18
};

opvp.Sex = {
    NONE    = Enum.UnitSex.None,
    BOTH    = Enum.UnitSex.Both,
    FEMALE  = Enum.UnitSex.Female,
    MALE    = Enum.UnitSex.Male,
    NEUTRAL = Enum.UnitSex.Neutral
};

opvp.SortOrder = {
    NONE       = 0,
    ASCENDING  = 1,
    DESCENDING = 2
};

opvp.SpellFlag = {
    BLEED     = bit.lshift(1,  0),
    BOSS      = bit.lshift(1,  1),
    CURSE     = bit.lshift(1,  2),
    DISEASE   = bit.lshift(1,  3),
    ENRAGE    = bit.lshift(1,  4),
    HARMFUL   = bit.lshift(1,  5),
    HELPFUL   = bit.lshift(1,  6),
    MAGIC     = bit.lshift(1,  7),
    POISON    = bit.lshift(1,  8),
    RAID      = bit.lshift(1,  9),
    STEALABLE = bit.lshift(1, 10)
};
