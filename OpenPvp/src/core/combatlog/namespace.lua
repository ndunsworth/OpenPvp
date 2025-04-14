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

opvp.combatlog = {
    ARENA_MATCH_START          = "ARENA_MATCH_START",
    ARENA_MATCH_END            = "ARENA_MATCH_END",
    COMBATANT_INFO             = "COMBATANT_INFO",
    DAMAGE_SHIELD              = "DAMAGE_SHIELD",
    DAMAGE_SHIELD_MISSED       = "DAMAGE_SHIELD_MISSED",
    DAMAGE_SPLIT               = "DAMAGE_SPLIT",
    EMOTE                      = "EMOTE",
    ENCHANT_APPLIED            = "ENCHANT_APPLIED",
    ENCHANT_REMOVED            = "ENCOUNTER_END",
    ENCOUNTER_START            = "ENCOUNTER_START",
    ENCOUNTER_END              = "ENCOUNTER_END",
    ENVIRONMENTAL_DAMAGE       = "ENVIRONMENTAL_DAMAGE",
    PARTY_KILL                 = "PARTY_KILL",
    RANGE_DAMAGE               = "RANGE_DAMAGE",
    RANGE_MISSED               = "RANGE_MISSED",
    SPELL_ABSORBED             = "SPELL_ABSORBED",
    SPELL_AURA_APPLIED         = "SPELL_AURA_APPLIED",
    SPELL_AURA_APPLIED_DOSE    = "SPELL_AURA_APPLIED_DOSE",
    SPELL_AURA_BROKEN          = "SPELL_AURA_BROKEN",
    SPELL_AURA_BROKEN_SPELL    = "SPELL_AURA_BROKEN_SPELL",
    SPELL_AURA_REFRESH         = "SPELL_AURA_REFRESH",
    SPELL_AURA_REMOVED         = "SPELL_AURA_REMOVED",
    SPELL_AURA_REMOVED_DOSE    = "SPELL_AURA_REMOVED_DOSE",
    SPELL_BUILDING_DAMAGE      = "SPELL_BUILDING_DAMAGE",
    SPELL_BUILDING_HEAL        = "SPELL_BUILDING_HEAL",
    SPELL_BUILDING_MISSED      = "SPELL_BUILDING_MISSED",
    SPELL_CAST_FAILED          = "SPELL_CAST_FAILED",
    SPELL_CAST_START           = "SPELL_CAST_START",
    SPELL_CAST_SUCCESS         = "SPELL_CAST_SUCCESS",
    SPELL_CREATE               = "SPELL_CREATE",
    SPELL_DAMAGE               = "SPELL_DAMAGE",
    SPELL_DISPEL               = "SPELL_DISPEL",
    SPELL_DISPEL_FAILED        = "SPELL_DISPEL_FAILED",
    SPELL_DISSIPATES           = "SPELL_DISSIPATES",
    SPELL_DRAIN                = "SPELL_DRAIN",
    SPELL_EMPOWER_END          = "SPELL_EMPOWER_END",
    SPELL_EMPOWER_INTERRUPT    = "SPELL_EMPOWER_INTERRUPT",
    SPELL_EMPOWER_START        = "SPELL_EMPOWER_START",
    SPELL_ENERGIZE             = "SPELL_ENERGIZE",
    SPELL_EXTRA_ATTACKS        = "SPELL_EXTRA_ATTACKS",
    SPELL_HEAL                 = "SPELL_HEAL",
    SPELL_HEAL_ABSORBED        = "SPELL_HEAL_ABSORBED",
    SPELL_INSTAKILL            = "SPELL_INSTAKILL",
    SPELL_INTERRUPT            = "SPELL_INTERRUPT",
    SPELL_LEECH                = "SPELL_LEECH",
    SPELL_MISSED               = "SPELL_MISSED",
    SPELL_PERIODIC_DAMAGE      = "SPELL_PERIODIC_DAMAGE",
    SPELL_PERIODIC_ENERGIZE    = "SPELL_PERIODIC_ENERGIZE",
    SPELL_PERIODIC_HEAL        = "SPELL_PERIODIC_HEAL",
    SPELL_PERIODIC_MISSED      = "SPELL_PERIODIC_MISSED",
    SPELL_STOLEN               = "SPELL_STOLEN",
    SPELL_SUMMON               = "SPELL_SUMMON",
    SWING_DAMAGE               = "SWING_DAMAGE",
    SWING_DAMAGE_LANDED        = "SWING_DAMAGE_LANDED",
    SWING_MISSED               = "SWING_MISSED",
    UNIT_DESTROYED             = "UNIT_DESTROYED",
    UNIT_DIED                  = "UNIT_DIED",
    UNIT_DISSIPATES            = "UNIT_DISSIPATES"
};
