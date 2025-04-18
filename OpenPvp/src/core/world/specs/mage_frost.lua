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
    class  = opvp.MAGE,
    id     = opvp.ClassSpecId.FROST_MAGE,
    role   = opvp.Role.DPS,
    traits = opvp.ClassSpecTrait.RANGED_MAGIC,
    sound  = 85506,
    icon   = "Interface/Icons/spell_frost_frostbolt02",
    spells = {
        harmful = {
            pvp    = {
                {389831, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellProperty.STUN, 4},    -- Snowdrift
            },
            talent = {
                {12472,  opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH, 30},  -- Icy Veins
            }
        }
    },
    auras = {
        helpful = {
            pvp = {
                {198144,  opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH, 17}, -- Ice Form
            },
            hero = {
                {235313, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 4},    -- Blazing Barrier
            }
        }
    }
};

opvp.ClassSpec.FROST_MAGE = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.FROST_MAGE);
table.insert(opvp.ClassSpec.DPS_SPECS, opvp.ClassSpec.FROST_MAGE);

spec_info = nil;
