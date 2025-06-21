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

local spec_info = {
    class  = opvp.DRUID,
    id     = opvp.ClassSpecId.RESTORATION_DRUID,
    index  = 4,
    role   = opvp.Role.HEALER,
    traits = opvp.ClassSpecTrait.RANGED_MAGIC,
    sound  = 5737,
    icon   = "Interface/Icons/spell_nature_healingtouch",
    spells = {
        helpful = {
            talent = {
                {102351, opvp.SpellProperty.AURA, 0, 30},                                                                -- Cenarion Ward
                {391528, opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 3},                                                  -- Convoke the Spirits
                {33891,  opvp.SpellProperty.DEFENSIVE_HIGH, 0, 30},                                                      -- Incarnation: Tree of Life
                {102342, opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 12},                                                 -- Ironbark
                {188550, opvp.SpellProperty.AURA, 0, 12},                                                                -- Lifebloom
                {132158, opvp.SpellProperty.DEFENSIVE_LOW_AURA, 0, 8},                                                   -- Natures Swiftness
                {15577,  opvp.SpellProperty.AURA, 0, 12},                                                                -- Rejuvenation (Germination)
                {8936,   opvp.SpellProperty.AURA, 0, 0},                                                                 -- Regrowth
                {740,    opvp.SpellProperty.DEFENSIVE_MEDIUM, 0, 8},                                                     -- Tranquility
                {48438,  opvp.SpellProperty.AURA, 0, 12},                                                                -- Wild Growth
            },
            pvp = {
                {473909, opvp.SpellProperty.DEFENSIVE_HIGH_IMMUNITY_AURA, opvp.CrowdControlSpellProperty.IMMUNITY_CC},  -- Ancient of Lore
            }
        }
    },
    auras = {
        harmful = {
            base = {
            },
            talent = {
            },
            pvp = {
                {339,    opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.ROOT, 6},                -- Natures Grasp (Entangling Bark)
            }
        },
        helpful = {
            talent = {
                {117679, opvp.SpellProperty.DEFENSIVE_HIGH, 0, 30},                                                     -- Incarnation
                {157982, opvp.SpellProperty.DEFENSIVE_MEDIUM, 0, 8},                                                    -- Tranquility
            }
        }
    }
};

opvp.ClassSpec.RESTORATION_DRUID = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.RESTORATION_DRUID);
table.insert(opvp.ClassSpec.HEALER_SPECS, opvp.ClassSpec.RESTORATION_DRUID);

spec_info = nil;
