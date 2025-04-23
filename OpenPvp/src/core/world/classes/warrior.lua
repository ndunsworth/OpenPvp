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

opvp.Class.WARRIOR = opvp.Class(
    {
        id = opvp.WARRIOR,
        file_id = "WARRIOR",
        races = {
            --~ NEUTRAL
            opvp.Race.DRACTHYR,
            opvp.Race.EARTHEN,
            opvp.Race.PANDAREN,

            --~ ALLIANCE
            opvp.Race.DRAENEI,
            opvp.Race.DWARF,
            opvp.Race.GNOME,
            opvp.Race.HUMAN,
            opvp.Race.NIGHT_ELF,
            opvp.Race.WORGEN,

            --~ ALLIANCE ALLIES
            opvp.Race.DARK_IRON_DWARF,
            opvp.Race.KUL_TIRAN,
            opvp.Race.LIGHTFORGED_DRAENEI,
            opvp.Race.MECHAGNOME,
            opvp.Race.VOID_ELF,
            opvp.Race.WORGEN,

            --~ HORDE
            opvp.Race.BLOOD_ELF,
            opvp.Race.GOBLIN,
            opvp.Race.ORC,
            opvp.Race.TAUREN,
            opvp.Race.TROLL,
            opvp.Race.UNDEAD,

            --~ HORDE ALLIES
            opvp.Race.HIGHMOUNTAIN_TAUREN,
            opvp.Race.MAGHAR_ORC,
            opvp.Race.NIGHTBORNE,
            opvp.Race.VULPERA,
            opvp.Race.ZANDALARI_TROLL
        },
        specs = {
            opvp.ClassSpec.ARMS_WARRIOR,
            opvp.ClassSpec.FURY_WARRIOR,
            opvp.ClassSpec.PROTECTION_WARRIOR
        },
        spells = {
            harmful = {
                base = {
                    {132404, opvp.SpellTrait.SNARE_AURA, 0, 12},                                                  -- Hastring
                },
                talent = {
                    {107574, opvp.SpellTrait.OFFENSIVE_ARUA, opvp.SpellProperty.OFFENSIVE_MEDIUM, 20},          -- Avatar
                    {105771, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT_NO_DR, 1},               -- Charge
                    {5246,   opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.DISORIENT, 8, 0.75},          -- Intimidating Shout
                    {23920,  opvp.SpellTrait.SNARE, 0, 8},                                                        -- Piercing Howl
                    {132168, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 2},                     -- Shockwave
                    {132169, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 4, 0.75},               -- Storm Bolt
                },
                pvp = {
                    {236077, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.DISARM, 5},                   -- Disarm
                    {206572, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellProperty.KNOCKBACK},                        -- Dragon Charge
                }
            },
            helpful = {
                base = {
                    {132404, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 6},                -- Shield Block
                },
                talent = {
                    {                                                                                             -- Berserker Rage
                        18499,
                        opvp.SpellTrait.HELPFUL_IMMUNITY,
                        bit.bor(
                            opvp.SpellProperty.DISORIENT_IMMUNITY,
                            opvp.SpellProperty.INCAPACITATE_IMMUNITY
                        ),
                        6
                    },
                    {                                                                                             -- Berserker Shout
                        384100,
                        opvp.SpellTrait.HELPFUL_IMMUNITY,
                        bit.bor(
                            opvp.SpellProperty.DISORIENT_IMMUNITY,
                            opvp.SpellProperty.INCAPACITATE_IMMUNITY
                        ),
                        6
                    },
                    {386208, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 10},               -- Defensive Stance
                    {316531, opvp.SpellTrait.DEFENSIVE_IMMUNITY, opvp.SpellProperty.PYHSICAL_IMMUNITY, 6},        -- Intervene
                    {97463,  opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 10},               -- Rallying Cry
                    {23920,  opvp.SpellTrait.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 5},       -- Spell Reflection
                }
            }
        },
        auras = {
            helpful = {
                talent = {
                    {147833, opvp.SpellTrait.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.PYHSICAL_IMMUNITY, 6},   -- Intervene
                }
            }
        }
    }
);
