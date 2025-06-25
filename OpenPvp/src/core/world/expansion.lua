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

opvp.ExpansionId = {
    CURRENT                = LE_EXPANSION_LEVEL_CURRENT,
    CLASSIC                = LE_EXPANSION_CLASSIC,
    BURNING_CRUSADE        = LE_EXPANSION_BURNING_CRUSADE,
    WRATH_OF_THE_LICH_KING = LE_EXPANSION_WRATH_OF_THE_LICH_KING,
    CATACLYSM              = LE_EXPANSION_CATACLYSM,
    MISTS_OF_PANDARIA      = LE_EXPANSION_MISTS_OF_PANDARIA,
    WARLORDS_OF_DRAENOR    = LE_EXPANSION_WARLORDS_OF_DRAENOR,
    LEGION                 = LE_EXPANSION_LEGION,
    BATTLE_FOR_AZEROTH     = LE_EXPANSION_BATTLE_FOR_AZEROTH,
    SHADOWLANDS            = LE_EXPANSION_SHADOWLANDS,
    DRAGONFLIGHT           = LE_EXPANSION_DRAGONFLIGHT,
    WAR_WITHIN             = LE_EXPANSION_WAR_WITHIN
};

opvp.expansion = {};

function opvp.expansion.forLevel(level)
    return GetExpansionForLevel(level);
end

function opvp.expansion.id()
    return GetExpansionLevel();
end

function opvp.expansion.info(id)
    return GetExpansionDisplayInfo(
        opvp.number_else(id, opvp.ExpansionId.CURRENT)
    );
end

function opvp.expansion.isDemonHunterAvailable()
    return IsDemonHunterAvailable();
end

function opvp.expansion.isLatest()
    return GetMaximumExpansionLevel() == GetExpansionLevel();
end

function opvp.expansion.isTrial()
    return IsExpansionTrial();
end

function opvp.expansion.isUpgradable()
    return CanUpgradeExpansion();
end

function opvp.expansion.name(id)
    return GetExpansionName(
        opvp.number_else(id, opvp.ExpansionId.CURRENT)
    );
end

function opvp.expansion.maxLevel(id)
    return GetMaxLevelForExpansionLevel(
        opvp.number_else(id, opvp.ExpansionId.CURRENT)
    );
end

function opvp.expansion.server()
    return GetServerExpansionLevel();
end
