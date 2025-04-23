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
    class  = opvp.DEMON_HUNTER,
    id     = opvp.ClassSpecId.HAVOC_DEMON_HUNTER,
    role   = opvp.Role.DPS,
    traits = opvp.ClassSpecTrait.MELEE_MAGIC,
    sound  = 170913,
    icon   = "Interface/Icons/ability_demonhunter_specdps",
    spells = {
        harmful = {
            talent = {
                {188499, opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_LOW},         -- Blade Dance
                {188499, opvp.SpellTrait.OFFENSIVE, opvp.SpellProperty.OFFENSIVE_MEDIUM},           -- Essence Break
                {198013, opvp.SpellTrait.OFFENSIVE, opvp.SpellProperty.OFFENSIVE_MEDIUM},           -- Eye Beam
                {211881, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 3},           -- Fel Eruption
            },
            pvp = {
                {205630, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 5},           -- Illidan's Grasp
                {206804, opvp.SpellTrait.OFFENSIVE, opvp.SpellProperty.OFFENSIVE_HIGH, 10},         -- Rain from Above
            }
        },
        helpful = {
            base = {
                {212800, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_MEDIUM, 10}, -- Blur
            },
            pvp = {
                {196555, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_IMMUNE_DMG}, -- Netherwalk
            }
        }
    },
    auras = {
        harmful = {
            hero = {
                {247121, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 5},     -- Blade Ward
            },
            talent = {
                {247121, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN_NO_DR, 3},    -- Metamorphosis (stun)
            }
        },
        helpful = {
            pvp = {
                {354610, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_IMMUNE_CC},  -- Glimpse
            }
        }
    }
};

opvp.ClassSpec.HAVOC_DEMON_HUNTER = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.HAVOC_DEMON_HUNTER);
table.insert(opvp.ClassSpec.DPS_SPECS, opvp.ClassSpec.HAVOC_DEMON_HUNTER);

spec_info = nil;
