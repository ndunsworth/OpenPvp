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
    index  = 3,
    role   = opvp.Role.DPS,
    traits = opvp.ClassSpecTrait.RANGED_MAGIC,
    sound  = 85506,
    icon   = "Interface/Icons/spell_frost_frostbolt02",
    spells = {
        harmful = {
            talent = {
                {12472,  opvp.SpellProperty.OFFENSIVE_HIGH_AURA, 0, 30},                                 -- Icy Veins
            },
            pvp = {
                {198144, opvp.SpellProperty.OFFENSIVE_HIGH_AURA, 0, 17},                                 -- Ice Form
                {389794, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 6}, -- Snowdrift (self)
            }
        }
    },
    auras = {
        helpful = {
            hero = {
                {235313, opvp.SpellProperty.DEFENSIVE_LOW_AURA, 0, 4},                                   -- Blazing Barrier
            },
            pvp = {
                {389831, opvp.SpellProperty.CROWD_CONTROL_AURA, opvp.CrowdControlSpellProperty.STUN, 4}, -- Snowdrift (stun)
            }
        }
    }
};

opvp.ClassSpec.FROST_MAGE = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.FROST_MAGE);
table.insert(opvp.ClassSpec.DPS_SPECS, opvp.ClassSpec.FROST_MAGE);

spec_info = nil;
