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

opvp.MAJOR_VERSION   = 1;
opvp.MINOR_VERSION   = 0;
opvp.RELEASE_VERSION = 5;

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

opvp.Sex = {
    NONE    = Enum.UnitSex.None,
    BOTH    = Enum.UnitSex.Both,
    FEMALE  = Enum.UnitSex.Female,
    MALE    = Enum.UnitSex.Male,
    NEUTRAL = Enum.UnitSex.Neutral
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
    EPIC       = bit.lshift(1,  3),
    ESCORT     = bit.lshift(1,  4),
    EVENT      = bit.lshift(1,  5),
    NODE       = bit.lshift(1,  6),
    RANDOM     = bit.lshift(1,  7),
    RANDOM_MAP = bit.lshift(1,  8),
    RATED      = bit.lshift(1,  9),
    RBG        = bit.lshift(1, 10),
    RESOURCE   = bit.lshift(1, 11),
    ROUND      = bit.lshift(1, 12),
    SCENARIO   = bit.lshift(1, 13),
    SHUFFLE    = bit.lshift(1, 14),
    SKIRMISH   = bit.lshift(1, 15),
    VEHICLE    = bit.lshift(1, 16),
    ZONE       = bit.lshift(1, 17)
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
