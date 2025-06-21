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

opvp.Class.DRUID = opvp.Class(
    {
        id = opvp.DRUID,
        file_id = "DRUID",
        races = {
            --~ ALLIANCE
            opvp.Race.NIGHT_ELF,
            opvp.Race.WORGEN,

            --~ ALLIANCE ALLIES
            opvp.Race.KUL_TIRAN,

            --~ HORDE
            opvp.Race.TAUREN,
            opvp.Race.TROLL,

            --~ HORDE ALLIES
            opvp.Race.HIGHMOUNTAIN_TAUREN,
            opvp.Race.ZANDALARI_TROLL
        },
        specs = {
            opvp.ClassSpec.BALANCE_DRUID,
            opvp.ClassSpec.FERAL_DRUID,
            opvp.ClassSpec.GUARDIAN_DRUID,
            opvp.ClassSpec.RESTORATION_DRUID
        },
        spells = {
            harmful = {
                talent = {
                    {339,    opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.ROOT, 30, 0.2}, -- Entangling Roots
                    {99,     opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 3},       -- Incapacitating Roar
                    {203123, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 5},       -- Maim
                    {102359, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.ROOT, 10, 0.6}, -- Mass Entanglement
                    {5211,   opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 4},       -- Mighty Bash
                    {163505, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 4},       -- Rake
                    {106839, opvp.SpellProperty.INTERRUPT, 0, 3},                                                  -- Skull Bash
                    {61391,  opvp.SpellProperty.SNARE_AURA, opvp.CrowdControlSpellProperty.KNOCKBACK, 6},          -- Typhoon
                    {127797, opvp.SpellProperty.SNARE_AURA, opvp.CrowdControlSpellProperty.KNOCKBACK, 10, 0.6},    -- Ursols Vortex
                }
            },
            helpful = {
                base = {
                    {22812, opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 8},                                         -- Barkskin
                },
                talent = {
                    {22842,  opvp.SpellProperty.DEFENSIVE_MEDIUM, 0, 3},                                           -- Frenzied Regeneration
                    {319454, opvp.SpellProperty.DEFENSIVE_OFFENSIVE_MEDIUM_AURA, 0, 30},                           -- Heart of the Wild
                    {29155,  opvp.SpellProperty.DEFENSIVE_LOW_AURA, 0, 8},                                         -- Innervate
                    {124974, opvp.SpellProperty.OFFENSIVE_LOW_AURA, 0, 15},                                        -- Natures Vigil
                    {774,    opvp.SpellProperty.AURA, 0, 12},                                                      -- Rejuvenation
                    {108238, opvp.SpellProperty.DEFENSIVE_MEDIUM, 0, 0},                                           -- Renewal
                }
            }
        }
    }
);
