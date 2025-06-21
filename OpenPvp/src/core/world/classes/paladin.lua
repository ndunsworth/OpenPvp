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

opvp.Class.PALADIN = opvp.Class(
    {
        id = opvp.PALADIN,
        file_id = "PALADIN",
        races = {
            --~ NEUTRAL
            opvp.Race.EARTHEN,

            --~ ALLIANCE
            opvp.Race.DRAENEI,
            opvp.Race.DWARF,
            opvp.Race.HUMAN,

            --~ ALLIANCE ALLIES
            opvp.Race.DARK_IRON_DWARF,
            opvp.Race.LIGHTFORGED_DRAENEI,

            --~ HORDE
            opvp.Race.BLOOD_ELF,
            opvp.Race.TAUREN,

            --~ HORDE ALLIES
            opvp.Race.HIGHMOUNTAIN_TAUREN,
            opvp.Race.ZANDALARI_TROLL
        },
        specs = {
            opvp.ClassSpec.HOLY_PALADIN,
            opvp.ClassSpec.PROTECTION_PALADIN,
            opvp.ClassSpec.RETRIBUTION_PALADIN
        },
        spells = {
            harmful = {
                talent = {
                    {105421, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.DISORIENT, 6},          -- Blinding Light
                    {20066,  opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.INCAPACITATE, 6},       -- Repentance
                    {853,    opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 5},               -- Hammer of Justice
                }
            },
            helpful = {
                base = {
                    {642,   opvp.SpellProperty.DEFENSIVE_HIGH_AURA, opvp.CrowdControlSpellProperty.IMMUNITY_ALL, 8},       -- Divine Shield
                },
                talent = {
                    {1044,   0, opvp.CrowdControlSpellProperty.ROOT_IMMUNITY, 8},                                           -- Blessing of Freedom
                    {1022,   opvp.SpellProperty.DEFENSIVE_HIGH_AURA, opvp.CrowdControlSpellProperty.PYHSICAL_IMMUNITY, 10}, -- Blessing of Protection
                    {6940,   opvp.SpellProperty.DEFENSIVE_MEDIUM_AURA, 0, 12},                                              -- Blessing of Sacrifice
                    {317920, opvp.SpellProperty.AURA},                                                                      -- Concentration Aura




                    {                                                                                                       -- Concentration Aura
                        317920,
                        opvp.SpellProperty.AURA,
                        bit.bor(
                            opvp.CrowdControlSpellProperty.INTERRUPT_REDUCTION,
                            opvp.CrowdControlSpellProperty.SILENCE_REDUCTION
                        ),
                        0,
                        0,
                        0.3
                    },


                    {32223,  opvp.SpellProperty.AURA},                                                                      -- Crusader Aura
                    {465,    opvp.SpellProperty.AURA},                                                                      -- Devotion Aura
                }
            }
        }
    }
);
