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
    class  = opvp.PALADIN,
    id     = opvp.ClassSpecId.HOLY_PALADIN,
    index  = 1,
    role   = opvp.Role.HEALER,
    traits = opvp.ClassSpecTrait.MELEE_MAGIC,
    sound  = 96464,
    icon   = "Interface/Icons/paladin_holy",
    spells = {
        harmful = {
        },
        helpful = {
            talent = {
                    {31821,  opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 8},                                             -- Aura Mastery
                    {216331, opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 8},                                             -- Avenging Crusader
                    {31884,  opvp.SpellProperty.DEFENSIVE_HIGH_AURA, opvp.CrowdControlSpellProperty.IMMUNITY_ALL, 8},   -- Avenging Wrath
            },
        }
    },
    auras = {
        harmful = {
        },
        helpful = {
            hero = {
                    {317929, opvp.SpellProperty.DEFENSIVE_MEDIUM, opvp.CrowdControlSpellProperty.SILENCE_IMMUNITY, 8},  -- Aura Mastery (Concentration Aura)
                    {379017, opvp.SpellProperty.DEFENSIVE_LOW, 0, 5},                                                   -- Faiths Armor
                    {432607, opvp.SpellProperty.DEFENSIVE_MEDIUM, 0, 30},                                               -- Holy Bulwark
                    {432502, opvp.SpellProperty.OFFENSIVE_MEDIUM, 0, 20},                                               -- Sacred Weapon
            },
        }
    }
};

opvp.ClassSpec.HOLY_PALADIN = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.HOLY_PALADIN);
table.insert(opvp.ClassSpec.HEALER_SPECS, opvp.ClassSpec.HOLY_PALADIN);

spec_info = nil;
